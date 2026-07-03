<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\User;

final class Auth
{
    private static ?User $user = null;
    private static array $server = [];
    private static array $cookies = [];

    public static function setRequestContext(array $server, array $cookies): void
    {
        self::$server = $server;
        self::$cookies = $cookies;
    }

    public static function login(int $uid, int $time, array $server = []): void
    {
        self::getDriver()->login($uid, $time, $server === [] ? self::$server : $server);
    }

    public static function getUser(array $server = [], array $cookies = []): User
    {
        if (self::$user === null) {
            self::$user = self::getDriver()->getUser(
                $server === [] ? self::$server : $server,
                $cookies === [] ? self::$cookies : $cookies
            );
        }

        return self::$user;
    }

    public static function logout(array $server = []): void
    {
        self::getDriver()->logout($server === [] ? self::$server : $server);
    }

    private static function getDriver(): Auth\Cookie
    {
        return Factory::createAuth();
    }
}
