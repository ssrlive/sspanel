<?php

declare(strict_types=1);

namespace App\Utils;

final class Env
{
    public static function get(string $key, mixed $default = null): mixed
    {
        $value = $_ENV[$key] ?? $default;

        if (! is_string($value)) {
            return $value;
        }

        $normalized = trim(strtolower($value));

        if ($normalized === 'true' || $normalized === 'yes' || $normalized === 'on') {
            return true;
        }

        if ($normalized === 'false' || $normalized === 'no' || $normalized === 'off') {
            return false;
        }

        if ($normalized === 'null') {
            return null;
        }

        if (preg_match('/^-?[0-9]+$/', $value)) {
            return (int) $value;
        }

        if (preg_match('/^-?[0-9]*\.[0-9]+$/', $value)) {
            return (float) $value;
        }

        $decoded = json_decode($value, true);

        if (json_last_error() === JSON_ERROR_NONE) {
            return $decoded;
        }

        return $value;
    }

    public static function getString(string $key, string $default = ''): string
    {
        $value = self::get($key, $default);

        return is_string($value) ? $value : (string) $value;
    }

    public static function getBool(string $key, bool $default = false): bool
    {
        $value = self::get($key);

        if ($value === null) {
            return $default;
        }

        if (is_bool($value)) {
            return $value;
        }

        if (is_numeric($value)) {
            return (int) $value !== 0;
        }

        $value = strtolower(trim((string) $value));

        return in_array($value, ['1', 'true', 'yes', 'on'], true);
    }

    public static function getInt(string $key, int $default = 0): int
    {
        $value = self::get($key);

        if ($value === null) {
            return $default;
        }

        if (is_int($value)) {
            return $value;
        }

        if (is_numeric($value)) {
            return (int) $value;
        }

        return $default;
    }

    public static function getArray(string $key, array $default = []): array
    {
        $value = self::get($key);

        if (is_array($value)) {
            return $value;
        }

        if (is_string($value) && $value !== '') {
            $decoded = json_decode($value, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                return $decoded;
            }
        }

        return $default;
    }
}
