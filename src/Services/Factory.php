<?php

declare(strict_types=1);

namespace App\Services;

use App\Services\Auth\Cookie;

final class Factory
{
    public static function createAuth()
    {
        $method = $_ENV['authDriver'];
        switch ($method) {
            case 'cookie':
                return new Cookie();
        }
        return new Cookie();
    }
}
