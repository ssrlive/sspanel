<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Models\User;
use App\Services\Subscribe;
use App\Utils\Tools;
use function array_filter;
use function array_merge;
use function json_decode;
use function json_encode;
use function str_contains;
use function stripos;

final class SingBox extends Base
{
    public function getContent(User $user): string
    {
        $nodes = [];
        $singbox_config = $_ENV['SingBox_Config'] ?? [];
        $singbox_config['outbounds'] = $singbox_config['outbounds'] ?? [];
        $singbox_config['experimental'] = $singbox_config['experimental'] ?? [];
        $singbox_config['experimental']['cache_file'] = $singbox_config['experimental']['cache_file'] ?? [];
        $nodes_raw = Subscribe::getUserNodes($user);

        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = json_decode($node_raw->custom_config, true) ?? [];

            switch ((int) $node_raw->sort) {
                case 0:
                    $node = [
                        'type' => 'shadowsocks',
                        'tag' => $node_raw->name,
                        'server' => $node_raw->server,
                        'server_port' => (int) $user->port,
                        'method' => $user->method,
                        'password' => $user->passwd,
                    ];

                    break;
                case 1:
                    $ss_2022_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $method = $node_custom_config['method'] ?? '2022-blake3-aes-128-gcm';
                    $user_pk = Tools::genSs2022UserPk($user->passwd, $method);
                    $uot = $node_custom_config['uot'] ?? false;

                    if (! $user_pk) {
                        $node = [];
                        break;
                    }

                    $server_key = $node_custom_config['server_key'] ?? '';

                    $node = [
                        'type' => 'shadowsocks',
                        'tag' => $node_raw->name,
                        'server' => $node_raw->server,
                        'server_port' => (int) $ss_2022_port,
                        'method' => $method,
                        'password' => $server_key === '' ? $user_pk : $server_key . ':' . $user_pk,
                        'udp_over_tcp' => (bool) $uot,
                    ];

                    break;
                case 2:
                    $tuic_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = filter_var($node_custom_config['allow_insecure'] ?? false, FILTER_VALIDATE_BOOLEAN);
                    $congestion_control = $node_custom_config['congestion_control'] ?? 'bbr';

                    $node = [
                        'type' => 'tuic',
                        'tag' => $node_raw->name,
                        'server' => $node_raw->server,
                        'server_port' => (int) $tuic_port,
                        'uuid' => $user->uuid,
                        'password' => $user->passwd,
                        'congestion_control' => $congestion_control,
                        'zero_rtt_handshake' => true,
                        'tls' => [
                            'enabled' => true,
                            'server_name' => $host,
                            'insecure' => $allow_insecure,
                        ],
                    ];

                    $node['tls'] = array_filter($node['tls']);

                    break;
                case 11:
                    $v2_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $transport = $node_custom_config['network'] ?? '';
                    if ($transport === 'tcp') {
                        $transport = '';
                    } elseif ($transport === 'httpupgrade') {
                        $transport = 'ws';
                    }
                    $header_request = $node_custom_config['header']['request'] ?? [];
                    $host = $header_request['headers']['Host'][0] ??
                        $node_custom_config['host'] ?? '';
                    $path = $header_request['path'][0] ?? $node_custom_config['path'] ?? '';
                    $headers = $header_request['headers'] ?? [];
                    $service_name = $node_custom_config['servicename'] ?? '';
                    $utls = filter_var($node_custom_config['utls'] ?? false, FILTER_VALIDATE_BOOLEAN);
                    $method = $node_custom_config['method'] ?? '';
                    $max_early_data = $node_custom_config['max_early_data'] ?? '';
                    $early_data_header_name = $node_custom_config['early_data_header_name'] ?? '';

                    $node = [
                        'type' => 'vmess',
                        'tag' => $node_raw->name,
                        'server' => $node_raw->server,
                        'server_port' => (int) $v2_port,
                        'uuid' => $user->uuid,
                        'security' => 'auto',
                        'alter_id' => 0,
                        'tls' => [
                            'enabled' => true,
                            'server_name' => $host,
                        ],
                        'packet_encoding' => 'xudp',
                        'global_padding' => true,
                        'authenticated_length' => true,
                        'transport' => [
                            'type' => $transport,
                            'path' => $path,
                            'method' => $method,
                            'headers' => $headers,
                            'service_name' => $service_name,
                            'max_early_data' => (int) $max_early_data,
                            'early_data_header_name' => $early_data_header_name,
                        ],
                    ];

                    if ($utls) {
                        $node['tls']['utls'] = [
                            'enabled' => true,
                            'fingerprint' => 'chrome',
                        ];
                    }

                    $node['tls'] = array_filter($node['tls']);
                    $node['transport'] = array_filter($node['transport']);

                    break;
                case 14:
                    $trojan_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = filter_var($node_custom_config['allow_insecure'] ?? false, FILTER_VALIDATE_BOOLEAN);
                    $transport = $node_custom_config['network'] ?? '';
                    if ($transport === 'httpupgrade') {
                        $transport = 'ws';
                    }
                    $header_request = $node_custom_config['header']['request'] ?? [];
                    $path = $header_request['path'][0] ?? $node_custom_config['path'] ?? '';
                    $headers = $header_request['headers'] ?? [];
                    $service_name = $node_custom_config['servicename'] ?? '';

                    $node = [
                        'type' => 'trojan',
                        'tag' => $node_raw->name,
                        'server' => $node_raw->server,
                        'server_port' => (int) $trojan_port,
                        'password' => $user->uuid,
                        'tls' => [
                            'enabled' => true,
                            'server_name' => $host,
                            'insecure' => $allow_insecure,
                        ],
                        'transport' => [
                            'type' => $transport,
                            'path' => $path,
                            'headers' => $headers,
                            'service_name' => $service_name,
                        ],
                    ];

                    $node['tls'] = array_filter($node['tls']);
                    $node['transport'] = array_filter($node['transport']);

                    break;
                case 16:
                    $vless_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $security = $node_custom_config['security'] ?? 'none';
                    $transport = $node_custom_config['network'] ?? '';
                    if ($transport === 'tcp') {
                        $transport = '';
                    } elseif ($transport === 'httpupgrade') {
                        $transport = 'ws';
                    }
                    $header_request = $node_custom_config['header']['request'] ?? [];
                    $host = $header_request['headers']['Host'][0] ??
                        $node_custom_config['host'] ?? '';
                    $path = $header_request['path'][0] ?? $node_custom_config['path'] ?? '';
                    $headers = $header_request['headers'] ?? [];
                    $service_name = $node_custom_config['servicename'] ?? '';
                    $flow = $node_custom_config['flow'] ?? '';
                    $allow_insecure = filter_var($node_custom_config['allow_insecure'] ?? false, FILTER_VALIDATE_BOOLEAN);
                    $utls = filter_var($node_custom_config['utls'] ?? false, FILTER_VALIDATE_BOOLEAN);

                    $node = [
                        'type' => 'vless',
                        'tag' => $node_raw->name,
                        'server' => $node_raw->server,
                        'server_port' => (int) $vless_port,
                        'uuid' => $user->uuid,
                        'packet_encoding' => 'xudp',
                        'tls' => [
                            'enabled' => $security === 'tls' || $security === 'reality',
                            'server_name' => $host,
                            'insecure' => $allow_insecure,
                        ],
                        'transport' => [
                            'type' => $transport,
                            'path' => $path,
                            'headers' => $headers,
                            'service_name' => $service_name,
                        ],
                    ];

                    if ($flow !== '') {
                        $node['flow'] = $flow;
                    }

                    if ($security === 'reality') {
                        $node['tls']['reality'] = [
                            'enabled' => true,
                            'public_key' => $node_custom_config['reality_public_key'] ?? '',
                            'short_id' => $node_custom_config['reality_short_id'] ?? '',
                        ];
                    }

                    if ($utls) {
                        $node['tls']['utls'] = [
                            'enabled' => true,
                            'fingerprint' => 'chrome',
                        ];
                    }

                    $node['tls'] = array_filter($node['tls']);
                    $node['transport'] = array_filter($node['transport']);

                    break;
                default:
                    $node = [];
                    break;
            }

            if ($node === []) {
                continue;
            }

            $nodes[] = $node;

            if (isset($singbox_config['outbounds'][0]['outbounds'])) {
                $singbox_config['outbounds'][0]['outbounds'][] = $node_raw->name;
            }
            if (isset($singbox_config['outbounds'][1]['outbounds'])) {
                $singbox_config['outbounds'][1]['outbounds'][] = $node_raw->name;
            }

            // 读取并匹配美国组
            $sb_us_group = $_ENV['Clash_US_Group_Index'] ?? '🇺🇸美国节点';

            foreach ($singbox_config['outbounds'] as $key => $outbound) {
                if (($outbound['type'] ?? '') === 'selector' || ($outbound['type'] ?? '') === 'urltest') {
                    if (($outbound['tag'] ?? '') === $sb_us_group) {
                        if (str_contains($node_raw->name, '美国') || stripos($node_raw->name, 'US') !== false || stripos($node_raw->name, 'States') !== false || str_contains($node_raw->name, '美')) {
                            $singbox_config['outbounds'][$key]['outbounds'][] = $node_raw->name;
                        }
                    }
                }
            }
        }

        // 【修复】Sing-Box 出站防爆空值校验逻辑
        $sb_us_group = $_ENV['Clash_US_Group_Index'] ?? '🇺🇸美国节点';
        foreach ($singbox_config['outbounds'] as $key => $outbound) {
            if (($outbound['tag'] ?? '') === $sb_us_group) {
                if (! isset($singbox_config['outbounds'][$key]['outbounds']) || $singbox_config['outbounds'][$key]['outbounds'] === []) {
                    if ($nodes !== []) {
                        $singbox_config['outbounds'][$key]['outbounds'][] = $nodes[0]['tag'];
                    } else {
                        $singbox_config['outbounds'][$key]['outbounds'][] = 'direct';
                    }
                }
            }
        }

        $singbox_config['outbounds'] = array_merge($singbox_config['outbounds'], $nodes);
        $singbox_config['experimental']['cache_file']['cache_id'] = $_ENV['appName'] ?? 'ss-panel';

        return json_encode($singbox_config);
    }
}
