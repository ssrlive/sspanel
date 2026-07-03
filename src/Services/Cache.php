<?php

declare(strict_types=1);

namespace App\Services;

use App\Utils\Env;
use Redis;

final class Cache
{
    public function initRedis(): Redis
    {
        $config = self::getRedisConfig();
        $redis = new Redis();

        $host = $config['host'];
        $port = is_string($config['port']) ? (int) $config['port'] : $config['port'];
        $connectTimeout = $config['connectTimeout'];
        $readTimeout = $config['readTimeout'];
        $context = $config['ssl'] ?? null;

        if (is_string($host) && str_contains($host, '/')) {
            $redis->connect($host, 0, $connectTimeout, null, 0, $readTimeout, $context);
        } else {
            $redis->connect($host, (int) $port, $connectTimeout, null, 0, $readTimeout, $context);
        }

        if (isset($config['auth'])) {
            $auth = $config['auth'];
            if (isset($auth['user']) && $auth['user'] !== '') {
                $redis->auth([$auth['user'], $auth['pass'] ?? '']);
            } elseif (isset($auth['pass']) && $auth['pass'] !== '') {
                $redis->auth($auth['pass']);
            }
        }

        return $redis;
    }

    public static function getRedisConfig(): array
    {
        $config = [
            'host' => Env::get('redis_host'),
            'port' => Env::get('redis_port'),
            'connectTimeout' => Env::get('redis_connect_timeout'),
            'readTimeout' => Env::get('redis_read_timeout'),
        ];

        if (Env::get('redis_username') !== '') {
            $config['auth']['user'] = Env::get('redis_username');
        }

        if (Env::get('redis_password') !== '') {
            $config['auth']['pass'] = Env::get('redis_password');
        }

        if (Env::get('redis_ssl')) {
            $config['ssl'] = Env::get('redis_ssl_context');
        }

        return $config;
    }
}
