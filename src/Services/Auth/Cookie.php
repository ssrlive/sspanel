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

        $this->setLoginCookie($user, $expire_in, $time, $server);
    }

    public function getUser(array $server = [], array $cookies = []): User
    {
        $uid = CookieUtils::get('uid', $cookies);
        $email = CookieUtils::get('email', $cookies);
        $key = CookieUtils::get('key', $cookies);
        $ipHash = CookieUtils::get('ip', $cookies);
        $deviceHash = CookieUtils::get('device', $cookies);
        $expire_in = CookieUtils::get('expire_in', $cookies);
        $expire_duration = CookieUtils::get('expire_duration', $cookies);

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
            $node = (new Node())->where('server', $remoteAddr)->first();

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

        if ($expire_duration !== '') {
            $expire_duration = (int) $expire_duration;
            if ($expire_duration > 0) {
                $this->setLoginCookie($user, time() + $expire_duration, $expire_duration, $server);
            }
        }

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

    private function setLoginCookie(User $user, int $expire_in, int $expire_duration, array $server = []): void
    {
        $domain = $server['HTTP_HOST'] ?? '';
        if (str_contains($domain, ':')) {
            $domain = preg_replace('/:\d+$/', '', $domain);
        }

        $remoteAddr = $server['REMOTE_ADDR'] ?? '';
        $userAgent = $server['HTTP_USER_AGENT'] ?? '';

        CookieUtils::setWithDomain([
            'uid' => (string) $user->id,
            'email' => $user->email,
            'key' => Hash::cookieHash($user->pass, $expire_in),
            'ip' => Hash::ipHash($remoteAddr, $user->id, $expire_in),
            'device' => Hash::deviceHash($userAgent, $user->id, $expire_in),
            'expire_in' => (string) $expire_in,
            'expire_duration' => (string) $expire_duration,
        ], $expire_in, $domain, $server);
    }
}
