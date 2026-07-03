<?php

declare(strict_types=1);

namespace App\Services;

use App\Utils\Env;
use Exception;
use Illuminate\Database\Capsule\Manager;
use const PHP_EOL;

final class DB extends Manager
{
    public static function init(): void
    {
        $db = new DB();

        try {
            $db->addConnection(self::getConfig());
            $db->getConnection()->getPdo();
        } catch (Exception $e) {
            if (Env::getBool('debug')) {
                die('Databse Error' . PHP_EOL . 'Reason: ' . $e->getMessage());
            }

            die('Databse Error');
        }

        $db->setAsGlobal();
        $db->bootEloquent();

        View::$connection = $db->getDatabaseManager();
        $db->getDatabaseManager()->connection('default')->enableQueryLog();
    }

    public static function getConfig(): array
    {
        if (Env::getBool('enable_db_rw_split')) {
            return [
                'driver' => 'mariadb',
                'read' => [
                    'host' => Env::getString('read_db_hosts'),
                ],
                'write' => [
                    'host' => Env::getString('write_db_host'),
                ],
                'sticky' => true,
                'database' => Env::getString('db_database'),
                'username' => Env::getString('db_username'),
                'password' => Env::getString('db_password'),
                'charset' => Env::getString('db_charset'),
                'collation' => Env::getString('db_collation'),
                'prefix' => Env::getString('db_prefix'),
                'port' => Env::getString('db_port'),
            ];
        }

        return [
            'driver' => 'mariadb',
            'host' => Env::getString('db_host'),
            'unix_socket' => Env::getString('db_socket'),
            'database' => Env::getString('db_database'),
            'username' => Env::getString('db_username'),
            'password' => Env::getString('db_password'),
            'charset' => Env::getString('db_charset'),
            'collation' => Env::getString('db_collation'),
            'prefix' => Env::getString('db_prefix'),
            'port' => Env::getString('db_port'),
        ];
    }
}
