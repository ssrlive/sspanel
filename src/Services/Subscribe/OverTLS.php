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
            if ((int) $node_raw->sort !== 4) {
                continue;
            }

            if ($node_raw->getNodeOnlineStatus() !== 1) {
                continue;
            }

            $node_custom_config = json_decode($node_raw->custom_config, true);
            if (! is_array($node_custom_config)) {
                $node_custom_config = [];
            }

            $otPath = $node_custom_config['tunnel_path'] ?? '';
            if ($otPath === '') {
                continue;
            }

            $host = $node_custom_config['client_settings']['server_host'] ?? $node_raw->server;

            $port = $node_custom_config['client_settings']['server_port'] ??
                $node_custom_config['server_settings']['listen_port'] ?? 443;

            $protocol = 'origin';
            $method = 'none';
            $obfs = 'plain';
            $password = 'password';

            $remarks = $node_custom_config['remarks'] ?? $node_raw->name;

            $otDomain = $node_custom_config['client_settings']['server_domain'] ?? '';

            $clientId = $user->uuid;

            $query = [
                'remarks' => $this->base64UrlEncode($remarks),
                'ot_enable' => '1',
                'ot_path' => $this->base64UrlEncode($otPath),
            ];

            if ($otDomain !== '') {
                $query['ot_domain'] = $this->base64UrlEncode($otDomain);
            }

            if ($clientId !== null && $clientId !== '') {
                $query['client_id'] = $clientId;
            }

            $base64Pass = $this->base64UrlEncode($password);
            $rawUrl = $host . ':' . $port . ':' . $protocol . ':' . $method . ':' . $obfs . ':' . $base64Pass . '/?' . http_build_query($query);
            $servers[] = [
                'url' => 'ssr://' . $this->base64UrlEncode($rawUrl),
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

    private function base64UrlEncode(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }
}
