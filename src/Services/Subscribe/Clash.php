<?php

declare(strict_types=1);

namespace App\Services\Subscribe;

use App\Models\User;
use App\Services\Subscribe;
use App\Utils\Tools;
use function in_array;
use function json_decode;
use function str_contains;
use function stripos;
use function yaml_emit;
use const YAML_UTF8_ENCODING;

final class Clash extends Base
{
    public function getContent(User $user): string
    {
        $nodes = [];
        $clash_config = $_ENV['Clash_Config'];
        $clash_group_indexes = $_ENV['Clash_Group_Indexes'];
        $clash_group_config = $_ENV['Clash_Group_Config'];

        // 1. 读取全局配置中定义好的国家分组名字
        $clash_hk_group_name = $_ENV['Clash_HK_Group_Index'] ?? '香港节点';
        $clash_jp_group_name = $_ENV['Clash_JP_Group_Index'] ?? '日本节点';
        $clash_us_group_name = $_ENV['Clash_US_Group_Index'] ?? '美国节点';

        $nodes_raw = Subscribe::getUserNodes($user);

        foreach ($nodes_raw as $node_raw) {
            $node_custom_config = json_decode($node_raw->custom_config, true);

            switch ((int) $node_raw->sort) {
                case 0:
                    $plugin = $node_custom_config['plugin'] ?? '';
                    $plugin_option = $node_custom_config['plugin_option'] ?? null;
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'ss',
                        'server' => $node_raw->server,
                        'port' => (int) $user->port,
                        'password' => $user->passwd,
                        'cipher' => $user->method,
                        'udp' => (bool) $udp,
                        'plugin' => $plugin,
                        'plugin-opts' => $plugin_option,
                    ];

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

                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $server_key = $node_custom_config['server_key'] ?? '';
                    $uot = $node_custom_config['uot'] ?? false;

                    $node = [
                        'name' => $node_raw->name,
                        'type' => 'ss',
                        'server' => $node_raw->server,
                        'port' => (int) $ss_2022_port,
                        'password' => $server_key === '' ? $user_pk : $server_key . ':' . $user_pk,
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
                    // Only Clash.Meta core has TUIC support
                    // Tuic V5 Only
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
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? false;
                    $tls = $security === 'tls';
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $h2_opts = $node_custom_config['h2-opts'] ?? $node_custom_config['h2_opts'] ?? null;
                    $http_opts = $node_custom_config['http-opts'] ?? $node_custom_config['http_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;
                    // HTTPUpgrade 在 Clash.Meta 内核中属于 ws 类型
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
                        'skip-cert-verify' => (bool) $allow_insecure,
                        'servername' => $host,
                        'network' => $network,
                        'ws-opts' => $ws_opts,
                        'h2-opts' => $h2_opts,
                        'http-opts' => $http_opts,
                        'grpc-opts' => $grpc_opts,
                    ];

                    break;
                case 14:
                    $trojan_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $network = $node_custom_config['header']['type'] ?? $node_custom_config['network'] ?? 'tcp';
                    $host = $node_custom_config['host'] ?? '';
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? false;
                    // Clash 特定配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;
                    // HTTPUpgrade 在 Clash.Meta 内核中属于 ws 类型
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
                        'skip-cert-verify' => (bool) $allow_insecure,
                        'ws-opts' => $ws_opts,
                        'grpc-opts' => $grpc_opts,
                    ];

                    break;
                case 16: // 完美集成 VLESS 协议支持
                    $vless_port = $node_custom_config['offset_port_user'] ??
                        ($node_custom_config['offset_port_node'] ?? 443);
                    $security = $node_custom_config['security'] ?? 'none';
                    $network = $node_custom_config['network'] ?? 'tcp';
                    $host = $node_custom_config['header']['request']['headers']['Host'][0] ??
                        $node_custom_config['host'] ?? '';
                    $allow_insecure = $node_custom_config['allow_insecure'] ?? false;
                    $tls = $security === 'tls' || $security === 'reality';

                    $uuid = $user->uuid;
                    $flow = $node_custom_config['flow'] ?? '';

                    // Reality 属性特殊提取
                    $reality_opts = null;
                    if ($security === 'reality') {
                        $reality_opts = [
                            'public-key' => $node_custom_config['reality_public_key'] ?? '',
                            'short-id' => $node_custom_config['reality_short_id'] ?? '',
                        ];
                    }

                    // 传输层配置
                    $udp = $node_custom_config['udp'] ?? true;
                    $ws_opts = $node_custom_config['ws-opts'] ?? $node_custom_config['ws_opts'] ?? null;
                    $h2_opts = $node_custom_config['h2-opts'] ?? $node_custom_config['h2_opts'] ?? null;
                    $http_opts = $node_custom_config['http-opts'] ?? $node_custom_config['http_opts'] ?? null;
                    $grpc_opts = $node_custom_config['grpc-opts'] ?? $node_custom_config['grpc_opts'] ?? null;

                    // 兼容 Clash 内核类型转换
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
                        'skip-cert-verify' => (bool) $allow_insecure,
                        'servername' => $host,
                        'network' => $network,
                    ];

                    if ($flow !== '') {
                        $node['flow'] = $flow;
                    }
                    if ($security === 'reality') {
                        $node['reality-opts'] = $reality_opts;
                    }
                    if ($ws_opts !== null) {
                        $node['ws-opts'] = $ws_opts;
                    }
                    if ($h2_opts !== null) {
                        $node['h2-opts'] = $h2_opts;
                    }
                    if ($http_opts !== null) {
                        $node['http-opts'] = $http_opts;
                    }
                    if ($grpc_opts !== null) {
                        $node['grpc-opts'] = $grpc_opts;
                    }

                    break;
                default:
                    $node = [];
                    break;
            }

            if ($node === []) {
                continue;
            }

            $nodes[] = $node;

            // 2. 注入全局/分流默认组
            foreach ($clash_group_indexes as $index) {
                if (isset($clash_group_config['proxy-groups'][$index])) {
                    $clash_group_config['proxy-groups'][$index]['proxies'][] = $node_raw->name;
                }
            }

            // 3. 多国家名字匹配过滤逻辑
            foreach ($clash_group_config['proxy-groups'] as $key => $group) {
                // 过滤香港
                if ($group['name'] === $clash_hk_group_name) {
                    if (
                        str_contains($node_raw->name, '香港') ||
                        stripos($node_raw->name, 'HK') !== false ||
                        stripos($node_raw->name, 'HongKong') !== false
                    ) {
                        $clash_group_config['proxy-groups'][$key]['proxies'][] = $node_raw->name;
                    }
                }

                // 过滤日本
                if ($group['name'] === $clash_jp_group_name) {
                    if (
                        str_contains($node_raw->name, '日本') ||
                        stripos($node_raw->name, 'JP') !== false ||
                        stripos($node_raw->name, 'Japan') !== false
                    ) {
                        $clash_group_config['proxy-groups'][$key]['proxies'][] = $node_raw->name;
                    }
                }

                // 过滤美国
                if ($group['name'] === $clash_us_group_name) {
                    if (
                        str_contains($node_raw->name, '美国') ||
                        stripos($node_raw->name, 'US') !== false ||
                        stripos($node_raw->name, 'States') !== false ||
                        str_contains($node_raw->name, '美')
                    ) {
                        $clash_group_config['proxy-groups'][$key]['proxies'][] = $node_raw->name;
                    }
                }
            }
        } // 节点循环结束

        // ====== ⚙️ 核心修复：按标准严格控制 YAML 字段的渲染顺序 ======
        $final_clash = [];

        // 1. 注入通用的基础全局配置（避免覆盖核心大件）
        foreach ($clash_config as $key => $value) {
            if (! in_array($key, ['proxies', 'proxy-groups', 'rules'])) {
                $final_clash[$key] = $value;
            }
        }

        // 2. 严格按 Karing 等新版内核喜好的顺序依次码放核心对象
        $final_clash['proxies'] = $nodes;
        $final_clash['proxy-groups'] = $clash_group_config['proxy-groups'] ?? [];

        // 3. 提取并注入路由规则，确保规则能正确映射到策略组
        $final_clash['rules'] = $clash_config['rules'] ?? ($clash_group_config['rules'] ?? []);

        // 4. 打包并返回标准 UTF-8 编码的 YAML
        return yaml_emit($final_clash, YAML_UTF8_ENCODING);
    }
}
