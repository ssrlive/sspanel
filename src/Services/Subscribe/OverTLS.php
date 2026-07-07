<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Models\User;
use App\Services\Subscribe;
use const PHP_EOL;

final class OverTLS extends Base
{
    public function getContent(User $user): string
    {
        $links = '';
        $nodes_raw = Subscribe::getUserNodes($user);

        foreach ($nodes_raw as $node_raw) {
            if ((int) $node_raw->sort === 4) {
                $links .= 'overtls://placeholder#' . rawurlencode($node_raw->name) . PHP_EOL;
            }
        }

        return $links;
    }
}
