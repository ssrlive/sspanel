<?php

declare(strict_types=1);

namespace App\Utils;

final class Cookie
{
    public static function set(array $arg, int $time, array $server = []): void
    {
        $secure = self::isSecure($server);
        foreach ($arg as $key => $value) {
            setcookie($key, $value, $time, path: '/', secure: $secure, httponly: true);
        }
    }

    public static function setWithDomain(array $arg, int $time, string $domain, array $server = []): void
    {
        $secure = self::isSecure($server);
        foreach ($arg as $key => $value) {
            setcookie($key, $value, $time, path: '/', domain: $domain, secure: $secure, httponly: true);
        }
    }

    public static function get(string $key, array $cookies = []): string
    {
        return $cookies[$key] ?? '';
    }

    private static function isSecure(array $server = []): bool
    {
        if (isset($server['HTTPS']) ? strcasecmp($server['HTTPS'], 'off') !== 0 : false) {
            return true;
        }

        return self::isSecureServerPort($server) || self::isForwardedProtoHttps($server) || self::isForwardedSslOn($server);
    }

    private static function isSecureServerPort(array $server = []): bool
    {
        return isset($server['SERVER_PORT']) && (int) $server['SERVER_PORT'] === 443;
    }

    private static function isForwardedProtoHttps(array $server = []): bool
    {
        return isset($server['HTTP_X_FORWARDED_PROTO']) && strcasecmp($server['HTTP_X_FORWARDED_PROTO'], 'https') === 0;
    }

    private static function isForwardedSslOn(array $server = []): bool
    {
        return isset($server['HTTP_X_FORWARDED_SSL']) && strcasecmp($server['HTTP_X_FORWARDED_SSL'], 'on') === 0;
    }
}
