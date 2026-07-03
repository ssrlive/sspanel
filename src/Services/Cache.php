<?php

declare(strict_types=1);

namespace App\Services;

use App\Utils\Env;
use Redis;

final class Cache
{
    public function initRedis(): Redis
    {
        return new Redis(self::getRedisConfig());
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
