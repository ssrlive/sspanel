<?php

declare(strict_types=1);

namespace App\Utils;

final class Cookie
{
    public static function set(array $arg, int $time): void
    {
        $secure = self::isSecure();
        foreach ($arg as $key => $value) {
            setcookie($key, $value, $time, path: '/', secure: $secure, httponly: true);
        }
    }

    public static function setWithDomain(array $arg, int $time, string $domain): void
    {
        $secure = self::isSecure();
        foreach ($arg as $key => $value) {
            setcookie($key, $value, $time, path: '/', domain: $domain, secure: $secure, httponly: true);
        }
    }

    public static function get(string $key): string
    {
        return $_COOKIE[$key] ?? '';
    }

    private static function isSecure(): bool
    {
        if (isset($_SERVER['HTTPS']) && strcasecmp($_SERVER['HTTPS'], 'off') !== 0) {
            return true;
        }

        return self::isSecureServerPort() || self::isForwardedProtoHttps() || self::isForwardedSslOn();
    }

    private static function isSecureServerPort(): bool
    {
        return isset($_SERVER['SERVER_PORT']) && (int) $_SERVER['SERVER_PORT'] === 443;
    }

    private static function isForwardedProtoHttps(): bool
    {
        return isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strcasecmp($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') === 0;
    }

    private static function isForwardedSslOn(): bool
    {
        return isset($_SERVER['HTTP_X_FORWARDED_SSL']) && strcasecmp($_SERVER['HTTP_X_FORWARDED_SSL'], 'on') === 0;
    }
}
