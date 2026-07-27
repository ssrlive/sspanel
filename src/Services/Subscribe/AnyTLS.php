<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Models\Config;
use App\Models\Node;
use App\Models\User;
use App\Services\Subscribe;
use function filter_var;
use function http_build_query;
use function is_array;
use function json_decode;
use function json_encode;
use const FILTER_VALIDATE_BOOLEAN;
use const JSON_UNESCAPED_SLASHES;
use const JSON_UNESCAPED_UNICODE;

final class AnyTLS extends Base
{
    public function getContent(User $user): string
    {
        $servers = [];

        if (! Config::obtain('enable_anytls_sub')) {
            return json_encode([
                'version' => 1,
                'servers' => $servers,
                'bytes_used' => (int) ($user->u + $user->d),
                'bytes_remaining' => max(0, (int) ($user->transfer_enable - $user->u - $user->d)),
            ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
        }

        $nodes_raw = Subscribe::getUserNodes($user);

        foreach ($nodes_raw as $node_raw) {
            /** @var Node $node_raw */
            if ($node_raw->sort() !== 'AnyTLS') {
                continue;
            }

            if ($node_raw->getNodeOnlineStatus() !== 1) {
                continue;
            }

            $nodeUrl = self::assembleNodeUrl($node_raw, $user->uuid);
            if ($nodeUrl === '') {
                continue;
            }

            $servers[] = [
                'url' => $nodeUrl,
                'type' => 'anytls',
            ];
        }

        return json_encode([
            'version' => 1,
            'servers' => $servers,
            'bytes_used' => (int) ($user->u + $user->d),
            'bytes_remaining' => max(0, (int) ($user->transfer_enable - $user->u - $user->d)),
        ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }

    public static function assembleNodeUrl(Node $node, string $userUuid): string
    {
        if ($node->sort() !== 'AnyTLS') {
            return '';
        }

        if ($node->server === '') {
            return '';
        }

        $node_custom_config = json_decode($node->custom_config, true);
        if (! is_array($node_custom_config)) {
            $node_custom_config = [];
        }

        $password = $node_custom_config['password'] ?? '';
        $listen = trim((string) ($node_custom_config['listen'] ?? ''));
        $host = $node->server;
        $port = 443;

        if ($listen !== '') {
            $listen_info = parse_url('tcp://' . $listen);
            if (is_array($listen_info) && isset($listen_info['host'])) {
                $host = $listen_info['host'];
            }
            if (is_array($listen_info) && isset($listen_info['port'])) {
                $port = (int) $listen_info['port'];
            }
        }

        $sni = $node_custom_config['sni'] ?? '';
        if ($sni === '' && filter_var($host, FILTER_VALIDATE_IP) === false) {
            $sni = $host;
        }

        $insecure = filter_var($node_custom_config['insecure'] ?? false, FILTER_VALIDATE_BOOLEAN);
        $display_name = $node->name;

        $uri = 'anytls://';
        if ($password !== '') {
            $uri .= rawurlencode($password) . '@';
        }

        $uri .= $host;
        if ($port !== 443) {
            $uri .= ':' . $port;
        }

        $query = [];
        if ($sni !== '') {
            $query['sni'] = $sni;
        }
        if ($userUuid !== null && $userUuid !== '') {
            $query['client_id'] = $userUuid;
        }
        if ($insecure) {
            $query['insecure'] = '1';
        }

        if (count($query) > 0) {
            $uri .= '/?' . http_build_query($query);
        }

        if ($display_name !== '') {
            $uri .= '#' . rawurlencode($display_name);
        }

        return $uri;
    }
}
