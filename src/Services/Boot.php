<?php

declare(strict_types=1);

namespace App\Services;

use App\Utils\Env;
use function date_default_timezone_set;
use function microtime;
use function Sentry\init;

final class Boot
{
    public static function setTime(): void
    {
        date_default_timezone_set(Env::getString('timeZone'));
        View::$beginTime = microtime(true);
    }

    public static function bootDb(): void
    {
        DB::init();
    }

    public static function bootSentry(): void
    {
        $dsn = Env::getString('sentry_dsn');

        if ($dsn !== '') {
            init([
                'dsn' => $dsn,
            ]);
        }
    }
}
