<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Services\Subscribe;
use App\Utils\Tools;
use function array_merge;
use function json_decode;
use function yaml_emit;
use function str_contains;
use function stripos;
use function in_array;
use const YAML_UTF8_ENCODING;

final class Clash extends Base
{
    public function getContent($user): string
    {
        $nodes = [];
        $clash_config = $_ENV['Clash_Config'] ?? [];
        $clash_group_indexes = $_ENV['Clash_Group_Indexes'] ?? [];
        $clash_group_config = $_ENV['Clash_Group_Config'] ?? [];
        
        // 仅保留美国组标签读取（安全默认值防报错）
        $clash_us_group_name = $_ENV['Clash_US_Group_Index'] ?? '🇺🇸美国节点';
        
        $nodes_raw = Subscribe::getUserNodes($user);

        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = json_decode($node_raw->custom_config, true) ?? [];

            switch ((int) $node_raw->sort) {
                case 0:
                    $plugin = $node_custom_config['plugin'] ?? '';
                    $plugin_option = $node_custom_config['plugin_option'] ?? null;
                    $udp = $node_custom_config['udp'] ?? true;

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'ss',
                        'server' => $node_raw->server,
                        'port' => (int) $user->port,
                        'password' => $user->passwd,
                        'cipher' => $user->method,
                        'udp' => (bool) $udp,
                    ];
                    if (!empty($plugin)) {
                        $node['plugin'] = $plugin;
                    }
                    if ($plugin_option !== null) {
                        $node['plugin-opts'] = $plugin_option;
                    }

                    break;
                case 1:
                    $ss_2022_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $method = $node_custom_config['method'] ?? '2022-blake3-aes-128-gcm';
                    $user_pk = Tools::genSs2022UserPk($user->passwd, $method);

                    if (! $user_pk) {
                        $node = [];
                        break;
                    }

                    $udp = $node_custom_config['udp'] ?? true;
                    $server_key = $node_custom_config['server_key'] ?? '';
                    $uot = $node_custom_config['uot'] ?? false;

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'ss',
                        'server' => $node_raw->server,
                        'port' => (int) $ss_2022_port,
                        'password' => $server_key === '' ? $user_pk : $server_key . ':' .$user_pk,
                        'cipher' => $method,
                        'udp' => (bool) $udp,
                        'udp_over_tcp' => (bool) $uot,
                    ];

                    break;
                case 2:
                    $tuic_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $host = $node_custom_config['host'] ?? '';
                    $congestion_control = $node_custom_config['congestion_control'] ?? 'bbr';

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'tuic',
                        'server' => $node_raw->server,
                        'port' => (int) $tuic_port,
                        'password' => $user->passwd,
                        'uuid' => $user->uuid,
                        'sni' => $host,
                        'congestion-controller' => $congestion_control,
                        'reduce-rtt' => true,
                    ];

                    break;
                case 11:
                    $v2_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $security = $node_custom_config['security'] ?? 'none';
                    $encryption = $node_custom_config['encryption'] ?? 'auto';
                    $network = $node_custom_config['network'] ?? '';
                    $host = $node_custom_config['header']['request']['headers']['Host'][0] ??
                        $node_custom_config['host'] ?? '';
                    $allow_insecure = filter_var($node_custom_config['allow_insecure'] ?? false, FILTER_VALIDATE_BOOLEAN);
                    $tls = $security === 'tls';
                    $udp = $node_custom_config['udp'] ?? true;
                    
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $h2_opts = $node_custom_config['h2-opts'] ?? $node_custom_config['h2_opts'] ?? null;
                    $http_opts = $node_custom_config['http-opts'] ?? $node_custom_config['http_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    if ($network === 'httpupgrade') {
                        $network = 'ws';
                    }

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'vmess',
                        'server' => $node_raw->server,
                        'port' => (int) $v2_port,
                        'uuid' => $user->uuid,
                        'alterId' => 0,
                        'cipher' => $encryption,
                        'udp' => (bool) $udp,
                        'tls' => $tls,
                        'skip-cert-verify' => $allow_insecure,
                        'servername' => $host,
                        'network' => $network,
                    ];

                    if ($ws_opts !== null) $node['ws-opts'] = $ws_opts;
                    if ($h2_opts !== null) $node['h2-opts'] = $h2_opts;
                    if ($http_opts !== null) $node['http-opts'] = $http_opts;
                    if ($grpc_opts !== null) $node['grpc-opts'] = $grpc_opts;

                    break;
                case 14:
                    $trojan_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $network = $node_custom_config['header']['type'] ?? $node_custom_config['network'] ?? 'tcp';
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = filter_var($node_custom_config['allow_insecure'] ?? false, FILTER_VALIDATE_BOOLEAN);
                    $udp = $node_custom_config['udp'] ?? true;
                    
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    if ($network === 'httpupgrade') {
                        $network = 'ws';
                    }

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'trojan',
                        'server' => $node_raw->server,
                        'sni' => $host,
                        'port' => (int) $trojan_port,
                        'password' => $user->uuid,
                        'network' => $network,
                        'udp' => (bool) $udp,
                        'skip-cert-verify' => $allow_insecure,
                    ];

                    if ($ws_opts !== null) $node['ws-opts'] = $ws_opts;
                    if ($grpc_opts !== null) $node['grpc-opts'] = $grpc_opts;

                    break;
                case 16:
                    $vless_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $security = $node_custom_config['security'] ?? 'none';
                    $network = $node_custom_config['network'] ?? 'tcp';
                    $host = $node_custom_config['header']['request']['headers']['Host'][0] ??
                        $node_custom_config['host'] ?? '';
                    $allow_insecure = filter_var($node_custom_config['allow_insecure'] ?? false, FILTER_VALIDATE_BOOLEAN);
                    $tls = $security === 'tls' || $security === 'reality';
                    
                    $uuid = $user->uuid;
                    $flow = $node_custom_config['flow'] ?? '';
                    
                    $reality_opts = null;
                    if ($security === 'reality') {
                        $reality_opts = [
                            'public-key' => $node_custom_config['reality_public_key'] ?? '',
                            'short-id' => $node_custom_config['reality_short_id'] ?? '',
                        ];
                    }

                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $h2_opts = $node_custom_config['h2-opts'] ?? $node_custom_config['h2_opts'] ?? null;
                    $http_opts = $node_custom_config['http-opts'] ?? $node_custom_config['http_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    if ($network === 'httpupgrade') {
                        $network = 'ws';
                    }

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'vless',
                        'server' => $node_raw->server,
                        'port' => (int) $vless_port,
                        'uuid' => $uuid,
                        'udp' => (bool) $udp,
                        'tls' => $tls,
                        'skip-cert-verify' => $allow_insecure,
                        'servername' => $host,
                        'network' => $network,
                    ];

                    if ($flow !== '') {
                        $node['flow'] = $flow;
                    }
                    if ($security === 'reality') {
                        $node['reality-opts'] = $reality_opts;
                    }
                    if ($ws_opts !== null) $node['ws-opts'] = $ws_opts;
                    if ($h2_opts !== null) $node['h2-opts'] = $h2_opts;
                    if ($http_opts !== null) $node['http-opts'] = $http_opts;
                    if ($grpc_opts !== null) $node['grpc-opts'] = $grpc_opts;

                    break;
                default:
                    $node = [];
                    break;
            }

            if ($node === []) {
                continue;
            }

            $nodes[] = $node;

            // 全局/分流子组映射
            foreach ($clash_group_indexes as $index) {
                if (isset($clash_group_config['proxy-groups'][$index])) {
                    $clash_group_config['proxy-groups'][$index]['proxies'][] = $node_raw->name;
                }
            }

            // 执行美国节点的过滤和自动分发
            foreach ($clash_group_config['proxy-groups'] as $key => $group) {
                if ($group['name'] === $clash_us_group_name) {
                    if (str_contains($node_raw->name, '美国') || stripos($node_raw->name, 'US') !== false || stripos($node_raw->name, 'States') !== false || str_contains($node_raw->name, '美')) {
                        $clash_group_config['proxy-groups'][$key]['proxies'][] = $node_raw->name;
                    }
                }
            }
        }

        // =========================================================================
        // 【核心修复】防爆空值校验逻辑
        // =========================================================================
        foreach ($clash_group_config['proxy-groups'] as $key => $group) {
            if ($group['name'] === $clash_us_group_name) {
                // 如果发现筛选出来的美国节点为空
                if (empty($clash_group_config['proxy-groups'][$key]['proxies'])) {
                    // 如果有其他任何可用节点，就把第一个节点丢进去兜底，否则就塞入 DIRECT（直连）防止软件闪退崩溃
                    if (!empty($nodes)) {
                        $clash_group_config['proxy-groups'][$key]['proxies'][] = $nodes[0]['name'];
                    } else {
                        $clash_group_config['proxy-groups'][$key]['proxies'][] = 'DIRECT';
                    }
                }
            }
        }

        $final_clash = [];
        foreach ($clash_config as $key => $value) {
            if (!in_array($key, ['proxies', 'proxy-groups', 'rules'])) {
                $final_clash[$key] = $value;
            }
        }

        $final_clash['proxies'] = $nodes;
        $final_clash['proxy-groups'] = $clash_group_config['proxy-groups'] ?? [];
        $final_clash['rules'] = $clash_config['rules'] ?? ($clash_group_config['rules'] ?? []);

        return yaml_emit($final_clash, YAML_UTF8_ENCODING);
    }
}
