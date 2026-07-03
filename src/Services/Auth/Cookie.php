<?php

declare(strict_types=1);

namespace App\Services\Auth;

use App\Models\Node;
use App\Models\User;
use App\Utils\Cookie as CookieUtils;
use App\Utils\Env;
use App\Utils\Hash;
use function time;

final class Cookie extends Base
{
    public function login(int $uid, int $time, array $server = [], array $cookies = []): void
    {
        $user = (new User())->find($uid);
        $expire_in = $time + time();

        $domain = $server['HTTP_HOST'] ?? '';
        if (str_contains($domain, ':')) {
            $domain = preg_replace('/:\d+$/', '', $domain);
        }

        $remoteAddr = $server['REMOTE_ADDR'] ?? '';
        $userAgent = $server['HTTP_USER_AGENT'] ?? '';

        CookieUtils::setWithDomain([
            'uid' => (string) $uid,
            'email' => $user->email,
            'key' => Hash::cookieHash($user->pass, $expire_in),
            'ip' => Hash::ipHash($remoteAddr, $uid, $expire_in),
            'device' => Hash::deviceHash($userAgent, $uid, $expire_in),
            'expire_in' => (string) $expire_in,
        ], $expire_in, $domain, $server);
    }

    public function getUser(array $server = [], array $cookies = []): User
    {
        $uid = CookieUtils::get('uid', $cookies);
        $email = CookieUtils::get('email', $cookies);
        $key = CookieUtils::get('key', $cookies);
        $ipHash = CookieUtils::get('ip', $cookies);
        $deviceHash = CookieUtils::get('device', $cookies);
        $expire_in = CookieUtils::get('expire_in', $cookies);

        $user = new User();
        $user->isLogin = false;

        if (
            $uid === '' ||
            $email === '' ||
            $key === '' ||
            $ipHash === '' ||
            $deviceHash === '' ||
            $expire_in === ''
        ) {
            return $user;
        }

        $expire_in = (int) $expire_in;
        if ($expire_in < time()) {
            return $user;
        }

        $remoteAddr = $server['REMOTE_ADDR'] ?? '';
        $userAgent = $server['HTTP_USER_AGENT'] ?? '';

        if (Env::get('enable_login_bind_ip')) {
            $node = (new Node())->where('ipv4', $remoteAddr)->orWhere('ipv6', $remoteAddr)->first();

            if ($node === null && $ipHash !== Hash::ipHash($remoteAddr, (int) $uid, $expire_in)) {
                return $user;
            }
        }

        if (Env::get('enable_login_bind_device')) {
            if ($deviceHash !== Hash::deviceHash($userAgent, (int) $uid, $expire_in)) {
                return $user;
            }
        }

        $user = (new User())->find($uid);

        if ($user === null) {
            $user = new User();
            $user->isLogin = false;
            return $user;
        }

        if ($user->email !== $email) {
            $user = new User();
            $user->isLogin = false;
            return $user;
        }

        if (Hash::cookieHash($user->pass, $expire_in) !== $key) {
            $user = new User();
            $user->isLogin = false;
            return $user;
        }

        $user->isLogin = true;

        return $user;
    }

    public function logout(array $server = []): void
    {
        $domain = $server['HTTP_HOST'] ?? '';
        if (str_contains($domain, ':')) {
            $domain = preg_replace('/:\d+$/', '', $domain);
        }

        CookieUtils::setWithDomain([
            'uid' => '',
            'email' => '',
            'key' => '',
            'ip' => '',
            'device' => '',
            'expire_in' => '',
        ], 0, $domain, $server);
    }
}
