<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        $defaultSubscribeSettings = [
            'enable_json_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'Json 通用订阅开关',
            ],
            'enable_clash_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'Clash 通用订阅开关',
            ],
            'enable_singbox_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'SingBox 通用订阅开关',
            ],
            'enable_v2rayjson_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'V2Ray Json 通用订阅开关',
            ],
            'enable_overtls_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'OverTLS 通用订阅开关',
            ],
            'enable_anytls_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'AnyTLS 通用订阅开关',
            ],
        ];

        foreach ($defaultSubscribeSettings as $item => $meta) {
            $count = DB::getPdo()->prepare('SELECT COUNT(*) FROM `config` WHERE `item` = ?');
            $count->execute([$item]);
            if ((int) $count->fetchColumn() === 0) {
                $insert = DB::getPdo()->prepare(
                    'INSERT INTO `config` (`item`, `value`, `class`, `is_public`, `type`, `default`, `mark`) VALUES (?, ?, ?, ?, ?, ?, ?)'
                );
                $insert->execute([
                    $item,
                    $meta['value'],
                    'subscribe',
                    $meta['is_public'],
                    $meta['type'],
                    $meta['default'],
                    $meta['mark'],
                ]);
            }
        }

        return 2026072700;
    }

    public function down(): int
    {
        $items = [
            'enable_json_sub',
            'enable_clash_sub',
            'enable_singbox_sub',
            'enable_v2rayjson_sub',
            'enable_overtls_sub',
            'enable_anytls_sub',
        ];

        $delete = DB::getPdo()->prepare('DELETE FROM `config` WHERE `item` = ?');
        foreach ($items as $item) {
            $delete->execute([$item]);
        }

        return 2023020100;
    }
};
