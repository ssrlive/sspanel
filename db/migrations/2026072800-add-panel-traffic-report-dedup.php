<?php

declare(strict_types=1);

use App\Interfaces\MigrationInterface;
use App\Services\DB;

return new class() implements MigrationInterface {
    public function up(): int
    {
        DB::getPdo()->exec(
            'CREATE TABLE `panel_traffic_report` (
                `node_id` bigint(20) unsigned NOT NULL,
                `reporter_id` char(36) NOT NULL,
                `last_sequence` bigint(20) unsigned NOT NULL DEFAULT 0,
                PRIMARY KEY (`node_id`, `reporter_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci'
        );

        return 2026072800;
    }

    public function down(): int
    {
        DB::getPdo()->exec('DROP TABLE `panel_traffic_report`');

        return 2026072700;
    }
};
