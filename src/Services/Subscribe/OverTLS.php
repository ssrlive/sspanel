<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Models\Node;
use App\Models\User;
use App\Services\Subscribe;
use const JSON_UNESCAPED_SLASHES;
use const JSON_UNESCAPED_UNICODE;

final class OverTLS extends Base
{
    public function getContent(User $user): string
    {
        $servers = [];
        $nodes_raw = Subscribe::getUserNodes($user);

        foreach ($nodes_raw as $node_raw) {
            /** @var Node $node_raw */
            if ($node_raw->sort() !== "OverTLS") {
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
                'type' => 'overtls',
            ];
        }

        $payload = [
            'version' => 1,
            'servers' => $servers,
            'bytes_used' => (int) ($user->u + $user->d),
            'bytes_remaining' => max(0, (int) ($user->transfer_enable - $user->u - $user->d)),
        ];

        return json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }

    public static function assembleNodeUrl(Node $node, string $userUuid): string
    {
        if ($node->sort() !== "OverTLS") {
            return '';
        }

        $node_custom_config = json_decode($node->custom_config, true);
        if (! is_array($node_custom_config)) {
            $node_custom_config = [];
        }

        $otPath = $node_custom_config['tunnel_path'] ?? '';
        if ($otPath === '') {
            return '';
        }

        $clientSettings = is_array($node_custom_config['client_settings'] ?? null)
            ? $node_custom_config['client_settings'] : [];

        $serverSettings = is_array($node_custom_config['server_settings'] ?? null)
            ? $node_custom_config['server_settings'] : [];

        $host = $clientSettings['server_host'] ?? $node->server;
        if ($host === '') {
            return '';
        }

        $port = $clientSettings['server_port'] ?? $serverSettings['listen_port'] ?? 443;

        $protocol = 'origin';
        $method = 'none';
        $obfs = 'plain';
        $password = 'password';

        $remarks = $node_custom_config['remarks'] ?? $node->name;

        $otDomain = $clientSettings['server_domain'] ?? '';

        $clientId = $userUuid;

        $query = [
            'remarks' => self::base64UrlEncode($remarks),
            'ot_enable' => '1',
            'ot_path' => self::base64UrlEncode($otPath),
        ];

        if ($otDomain !== '') {
            $query['ot_domain'] = self::base64UrlEncode($otDomain);
        }

        if ($clientId !== null && $clientId !== '') {
            $query['client_id'] = $clientId;
        }

        $base64Pass = self::base64UrlEncode($password);
        return 'ssr://' . self::base64UrlEncode($host . ':' . $port . ':' . $protocol . ':' . $method . ':' . $obfs . ':' . $base64Pass . '/?' . http_build_query($query));
    }

    private static function base64UrlEncode(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }
}
