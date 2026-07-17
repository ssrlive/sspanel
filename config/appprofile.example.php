<?php

declare(strict_types=1);

// =========================================================================
// 1. V2RayJson 基础配置模板
// =========================================================================
$_ENV['V2RayJson_Config'] = [
    'log' => [
        'error' => [
            'level' => 'error',
            'type'  => 'console',
        ],
        'access' => [
            'type' => 'none',
        ],
    ],
    'dns' => [
        'nameServer' => [
            ['address' => '1.1.1.1'],
            ['address' => '1.0.0.1'],
        ],
    ],
    'inbounds' => [
        [
            'protocol' => 'socks',
            'settings' => [
                'udpEnabled'     => true,
                'address'        => '127.0.0.1',
                'packetEncoding' => 'packet',
            ],
            'port'     => 7892,
            'listen'   => '127.0.0.1',
        ],
        [
            'protocol' => 'http',
            'settings' => [],
            'port'     => 7893,
            'listen'   => '127.0.0.1',
        ],
    ],
    'outbounds' => [],
];

// =========================================================================
// 2. 全局本地化变量定义 (增加美国节点组)
// =========================================================================
$_ENV['Clash_US_Group_Index'] = '🇺🇸美国节点';

// =========================================================================
// 3. SingBox 基础配置模板
// =========================================================================
$_ENV['SingBox_Config'] = [
    'log' => [
        'disabled'  => false,
        'level'     => 'error',
        'timestamp' => true,
    ],
    'dns' => [
        'servers' => [
            [
                'tag'  => 'local',
                'type' => 'local',
            ],
            [
                'tag'         => 'alidns',
                'type'        => 'quic',
                'server'      => '223.6.6.6',
                'server_port' => 853,
            ],
            [
                'tag'         => 'cloudflare',
                'type'        => 'tls',
                'server'      => '1.1.1.1',
                'server_port' => 853,
                'detour'      => 'select',
            ],
            [
                'tag'         => 'google',
                'type'        => 'tls',
                'server'      => '8.8.8.8',
                'server_port' => 853,
                'detour'      => 'select',
            ],
            [
                'tag'         => 'opendns',
                'type'        => 'tls',
                'server'      => '208.67.222.222',
                'server_port' => 853,
                'detour'      => 'select',
            ],
            [
                'tag'             => 'mine_853',
                'type'            => $_ENV['dns_type_853'] ?? 'tls',
                'server'          => $_ENV['dns_server_853'] ?? '1.1.1.1',
                'server_port'     => $_ENV['dns_server_port_853'] ?? 853,
                'domain_resolver' => 'alidns',
            ],
            [
                'tag'             => 'mine_443',
                'type'            => $_ENV['dns_type_443'] ?? 'https',
                'server'          => $_ENV['dns_server_443'] ?? '1.1.1.1',
                'server_port'     => $_ENV['dns_server_port_443'] ?? 443,
                'path'            => $_ENV['dns_path_443'] ?? '/dns-query',
                'domain_resolver' => 'alidns',
            ],
            [
                'tag'         => 'fakeip',
                'type'        => 'fakeip',
                'inet4_range' => '198.18.0.0/15',
                'inet6_range' => 'fc00::/18',
            ],
        ],
        'rules' => [
            [
                'query_type' => ['SVCB', 'HTTPS'],
                'action'     => 'predefined',
                'rcode'      => 'REFUSED',
            ],
            [
                'domain_keyword' => [
                    'telemetry',
                    'analytics',
                    'analysis',
                    'tracking',
                    'log-upload',
                    'metrics',
                    'adservice',
                    'adsystem',
                    'tongji',
                    'p2p',
                    'strategy'
                ],
                'action'         => 'predefined',
                'rcode'          => 'REFUSED',
            ],
            [
                'rule_set' => ['geosite-category-ads-all'],
                'action'   => 'predefined',
                'rcode'    => 'REFUSED',
            ],
            [
                'clash_mode' => 'Global',
                'server'     => 'fakeip',
            ],
            [
                'rule_set' => [
                    'geosite-geolocation-cn',
                    'geosite-cn',
                    'geosite-netease',
                    'geosite-bilibili',
                ],
                'server'   => 'fakeip',
            ],
            [
                'type'          => 'logical',
                'mode'          => 'and',
                'rules'         => [
                    [
                        'rule_set' => ['geosite-geolocation-!cn'],
                        'invert'   => true,
                    ],
                    [
                        'rule_set' => ['geoip-cn'],
                    ],
                ],
                'action'        => 'route',
                'server'        => $_ENV['dns_select'] ?? 'local',
                'disable_cache' => true,
                'client_subnet' => '111.222.0.0',
            ],
            [
                'clash_mode' => 'Rule',
                'server'     => 'fakeip',
            ],
            [
                'clash_mode' => 'Direct',
                'server'     => 'local',
            ],
        ],
        'final'             => 'cloudflare',
        'disable_cache'     => true,
        'independent_cache' => true,
    ],
    'inbounds' => [
        [
            'type'         => 'tun',
            'tag'          => 'in',
            'address'      => [
                '172.18.0.1/30',
                'fdfe:dcba:9876::1/126',
            ],
            'auto_route'   => true,
            'strict_route' => true,
            'udp_timeout'  => 60,
            'stack'        => 'mixed',
        ],
    ],
    'outbounds' => [
        [
            'tag'                         => 'select',
            'type'                        => 'selector',
            'outbounds'                   => ['auto'],
            'default'                     => 'auto',
            'interrupt_exist_connections' => true,
        ],
        [
            'type'                        => 'urltest',
            'tag'                         => 'auto',
            'outbounds'                   => [],
            'url'                         => 'https://cp.cloudflare.com/generate_204',
            'interval'                    => '3m',
            'tolerance'                   => 50,
            'idle_timeout'                => '30m',
            'interrupt_exist_connections' => true,
        ],
        [
            'type'      => 'selector',
            'tag'       => $_ENV['Clash_US_Group_Index'],
            'outbounds' => [],
        ],
        [
            'tag'                         => 'rules_download',
            'type'                        => 'selector',
            'outbounds'                   => ['select', 'auto', 'direct'],
            'default'                     => 'select',
            'interrupt_exist_connections' => true,
        ],
        [
            'type' => 'direct',
            'tag'  => 'direct',
        ],
    ],
    'route' => [
        'rules' => [
            [
                'inbound' => 'in',
                'action'  => 'sniff',
                'timeout' => '1s',
            ],
            [
                'inbound'  => 'in',
                'protocol' => 'dns',
                'port'     => [53],
                'action'   => 'hijack-dns',
            ],
            [
                'domain_keyword' => [
                    'telemetry',
                    'analytics',
                    'analysis',
                    'tracking',
                    'log-upload',
                    'metrics',
                    'adservice',
                    'adsystem',
                    'tongji',
                    'p2p',
                    'strategy'
                ],
                'action'         => 'reject',
                'method'         => 'default',
            ],
            [
                'rule_set' => ['geosite-category-ads-all'],
                'action'   => 'reject',
                'method'   => 'default',
            ],
            [
                'clash_mode' => 'Direct',
                'outbound'   => 'direct',
            ],
            [
                'clash_mode' => 'Global',
                'outbound'   => 'select',
            ],
            [
                'protocol' => 'stun',
                'action'   => 'reject',
                'method'   => 'default',
            ],
            [
                'rule_set' => ['geosite-geolocation-!cn'],
                'outbound' => 'select',
            ],
            [
                'type'     => 'logical',
                'mode'     => 'and',
                'rules'    => [
                    [
                        'rule_set' => [
                            'geosite-geolocation-!cn',
                            'geosite-geolocation-cn',
                            'geosite-cn',
                            'geosite-netease',
                            'geosite-bilibili',
                        ],
                        'invert'   => true,
                    ],
                    [
                        'rule_set' => ['geoip-cn'],
                        'invert'   => true,
                    ],
                ],
                'action'   => 'route',
                'outbound' => 'select',
            ],
            [
                'rule_set' => [
                    'geosite-geolocation-cn',
                    'geosite-cn',
                    'geosite-netease',
                    'geosite-bilibili',
                ],
                'outbound' => 'direct',
            ],
            [
                'rule_set' => ['geoip-cn'],
                'outbound' => 'direct',
            ],
            [
                'type'     => 'logical',
                'mode'     => 'and',
                'rules'    => [
                    [
                        'rule_set' => ['geosite-geolocation-!cn'],
                        'invert'   => true,
                    ],
                    [
                        'rule_set' => ['geoip-cn'],
                    ],
                ],
                'action'   => 'route',
                'outbound' => 'direct',
            ],
            [
                'ip_is_private' => true,
                'outbound'      => 'direct',
            ],
        ],
        'rule_set' => [
            [
                'tag'             => 'geoip-cn',
                'type'            => 'remote',
                'format'          => 'binary',
                'url'             => 'https://' . ($_ENV['jsdelivr_url'] ?? 'fastly.jsdelivr.net') . '/gh/SagerNet/sing-geoip@rule-set/geoip-cn.srs',
                'download_detour' => 'rules_download',
                'update_interval' => '1d',
            ],
            [
                'tag'             => 'geosite-cn',
                'type'            => 'remote',
                'format'          => 'binary',
                'url'             => 'https://' . ($_ENV['jsdelivr_url'] ?? 'fastly.jsdelivr.net') . '/gh/SagerNet/sing-geosite@rule-set/geosite-cn.srs',
                'download_detour' => 'rules_download',
                'update_interval' => '1d',
            ],
            [
                'tag'             => 'geosite-category-ads-all',
                'type'            => 'remote',
                'format'          => 'binary',
                'url'             => 'https://' . ($_ENV['jsdelivr_url'] ?? 'fastly.jsdelivr.net') . '/gh/SagerNet/sing-geosite@rule-set/geosite-category-ads-all.srs',
                'download_detour' => 'rules_download',
                'update_interval' => '1d',
            ],
            [
                'tag'             => 'geosite-geolocation-cn',
                'type'            => 'remote',
                'format'          => 'binary',
                'url'             => 'https://' . ($_ENV['jsdelivr_url'] ?? 'fastly.jsdelivr.net') . '/gh/SagerNet/sing-geosite@rule-set/geosite-geolocation-cn.srs',
                'download_detour' => 'rules_download',
                'update_interval' => '1d',
            ],
            [
                'tag'             => 'geosite-geolocation-!cn',
                'type'            => 'remote',
                'format'          => 'binary',
                'url'             => 'https://' . ($_ENV['jsdelivr_url'] ?? 'fastly.jsdelivr.net') . '/gh/SagerNet/sing-geosite@rule-set/geosite-geolocation-!cn.srs',
                'download_detour' => 'rules_download',
                'update_interval' => '1d',
            ],
            [
                'tag'             => 'geosite-netease',
                'type'            => 'remote',
                'format'          => 'binary',
                'url'             => 'https://' . ($_ENV['jsdelivr_url'] ?? 'fastly.jsdelivr.net') . '/gh/SagerNet/sing-geosite@rule-set/geosite-netease.srs',
                'download_detour' => 'rules_download',
                'update_interval' => '1d',
            ],
            [
                'tag'             => 'geosite-bilibili',
                'type'            => 'remote',
                'format'          => 'binary',
                'url'             => 'https://' . ($_ENV['jsdelivr_url'] ?? 'fastly.jsdelivr.net') . '/gh/SagerNet/sing-geosite@rule-set/geosite-bilibili.srs',
                'download_detour' => 'rules_download',
                'update_interval' => '1d',
            ],
        ],
        'final'                   => 'select',
        'auto_detect_interface'   => true,
        'override_android_vpn'    => true,
        'default_domain_resolver' => [
            'server'      => 'local',
            'rewrite_tll' => 60,
        ],
    ],
    'experimental' => [
        'cache_file' => [
            'enabled'  => true,
            'cache_id' => '',
            'path'     => 'cache.db',
        ],
    ],
];

// =========================================================================
// 4. Clash 基础配置模板
// =========================================================================
$_ENV['Clash_Config'] = [
    'port'                => 7890,
    'socks-port'          => 7891,
    'allow-lan'           => false,
    'mode'                => 'Rule',
    'ipv6'                => true,
    'log-level'           => 'error',
    'tcp-concurrent'      => $_ENV['tcp_concurrent'] ?? true,
    'external-controller' => '0.0.0.0:9091',
];

$_ENV['Clash_Group_Indexes'] = [0, 1, 2, 3, 4, 6, 8, 13];

$_ENV['Clash_Group_Config'] = [
    'proxy-groups' => [
        ['name' => '🔰 手动选择', 'type' => 'select', 'proxies' => ['♻️ 自动选择', '🎯 Direct']],
        ['name' => '♻️ 自动选择', 'type' => 'url-test', 'url' => 'http://cp.cloudflare.com/generate_204', 'interval' => 300, 'proxies' => []],
        ['name' => '🎥 Netflix', 'type' => 'select', 'proxies' => ['🔰 手动选择', '♻️ 自动选择', $_ENV['Clash_US_Group_Index'], '🎯 Direct']],
        ['name' => '🎧 TikTok', 'type' => 'select', 'proxies' => ['🔰 手动选择', '♻️ 自动选择', '🇺🇸美国节点', '🎯 Direct']],
        ['name' => '🌍 主流媒体', 'type' => 'select', 'proxies' => ['🔰 手动选择', '♻️ 自动选择', '🎯 Direct']],
        ['name' => '🇨🇳 中国媒体', 'type' => 'select', 'proxies' => ['🎯 Direct', '🔰 手动选择', '♻️ 自动选择']],
        ['name' => '📲 Telegram', 'type' => 'select', 'proxies' => ['🔰 手动选择', '♻️ 自动选择', $_ENV['Clash_US_Group_Index'], '🎯 Direct']],
        ['name' => 'Ⓜ️ Microsoft', 'type' => 'select', 'proxies' => ['🎯 Direct', $_ENV['Clash_US_Group_Index'], '🔰 手动选择', '♻️ 自动选择']],
        ['name' => '🍎 Apple', 'type' => 'select', 'proxies' => ['🔰 手动选择', '♻️ 自动选择', '🎯 Direct']],
        ['name' => $_ENV['Clash_US_Group_Index'], 'type' => 'url-test', 'url' => 'http://cp.cloudflare.com/generate_204', 'interval' => 300, 'proxies' => []],
        ['name' => '🎯 Direct', 'type' => 'select', 'proxies' => ['DIRECT']],
        ['name' => '🛑 Block', 'type' => 'select', 'proxies' => ['REJECT']],
        ['name' => '⛔️ 广告拦截', 'type' => 'select', 'proxies' => ['🛑 Block', '🎯 Direct', '🔰 手动选择']],
        ['name' => '🐟 漏网之鱼', 'type' => 'select', 'proxies' => ['🔰 手动选择', '♻️ 自动选择', '🎯 Direct']],
    ],
    'rules' => [
        // ====== 1. 绝对优先拦截层 ======
        'GEOSITE,category-ads-all,⛔️ 广告拦截',
        'GEOIP,ad,⛔️ 广告拦截',

        // 防追踪/广告域名
        'DOMAIN-KEYWORD,telemetry,🛑 Block',
        'DOMAIN-KEYWORD,analytics,🛑 Block',
        'DOMAIN-KEYWORD,analysis,🛑 Block',
        'DOMAIN-KEYWORD,tracking,🛑 Block',
        'DOMAIN-KEYWORD,log-upload,🛑 Block',
        'DOMAIN-KEYWORD,metrics,🛑 Block',
        'DOMAIN-KEYWORD,adservice,🛑 Block',
        'DOMAIN-KEYWORD,adsystem,🛑 Block',
        'DOMAIN-KEYWORD,tongji,🛑 Block',
        'DOMAIN-KEYWORD,p2p,🛑 Block',
        'DOMAIN-KEYWORD,strategy,🛑 Block',

        // Microsoft
        'GEOSITE,microsoft,Ⓜ️ Microsoft',
        'GEOSITE,microsoft-dev,Ⓜ️ Microsoft',
        'GEOSITE,microsoft-pki,Ⓜ️ Microsoft',

        // 苹果、电报及流媒体分流
        'GEOSITE,apple,🍎 Apple',
        'GEOSITE,telegram,📲 Telegram',
        'GEOIP,telegram,📲 Telegram',
        'GEOSITE,tiktok,🎧 TikTok',
        'GEOIP,tiktok,🎧 TikTok',
        'GEOSITE,netflix,🎥 Netflix',
        'GEOIP,netflix,🎥 Netflix',
        'GEOSITE,category-media,🌍 主流媒体',

        // ====== 3. 国内直连层 ======
        'GEOSITE,category-media-cn,🇨🇳 中国媒体',

        // 常用 P2P/下载直连
        'DOMAIN-KEYWORD,oray,🎯 Direct',
        'DOMAIN-KEYWORD,todesk,🎯 Direct',
        'DOMAIN-KEYWORD,onedrive,🎯 Direct',
        'DOMAIN-KEYWORD,Thunder,🎯 Direct',
        'DOMAIN-KEYWORD,XLLiveUD,🎯 Direct',
        'DOMAIN-KEYWORD,aria2,🎯 Direct',
        'DOMAIN-KEYWORD,miner,🎯 Direct',
        'DOMAIN-KEYWORD,mining,🎯 Direct',
        'DOMAIN-KEYWORD,monero,🎯 Direct',
        'DOMAIN-KEYWORD,pool,🎯 Direct',
        'DOMAIN-KEYWORD,xmr,🎯 Direct',
        'DOMAIN-KEYWORD,xunlei,🎯 Direct',
        'DOMAIN-KEYWORD,yunpan,🎯 Direct',

        // 常用直连端口
        'DST-PORT,10300,🎯 Direct',
        'DST-PORT,10343,🎯 Direct',
        'DST-PORT,18080,🎯 Direct',
        'DST-PORT,2222,🎯 Direct',
        'DST-PORT,3333,🎯 Direct',
        'DST-PORT,5555,🎯 Direct',
        'DST-PORT,7777,🎯 Direct',
        'DST-PORT,8333,🎯 Direct',
        'DST-PORT,8888,🎯 Direct',
        'DST-PORT,9000,🎯 Direct',
        'DST-PORT,9999,🎯 Direct',

        // 大陆路由直连
        'GEOSITE,apple-cn,🎯 Direct',
        'GEOSITE,cn,🎯 Direct',
        'GEOIP,private,🎯 Direct,no-resolve',
        'GEOIP,CN,🎯 Direct,no-resolve',

        // 常用下载进程
        'PROCESS-NAME,DownloadService,🎯 Direct',
        'PROCESS-NAME,Folx,🎯 Direct',
        'PROCESS-NAME,Motrix,🎯 Direct',
        'PROCESS-NAME,NetTransport,🎯 Direct',
        'PROCESS-NAME,Thunder,🎯 Direct',
        'PROCESS-NAME,Transmission,🎯 Direct',
        'PROCESS-NAME,WebTorrent Helper,🎯 Direct',
        'PROCESS-NAME,WebTorrent,🎯 Direct',
        'PROCESS-NAME,Weiyun,🎯 Direct',
        'PROCESS-NAME,aria2c,🎯 Direct',
        'PROCESS-NAME,fdm,🎯 Direct',
        'PROCESS-NAME,qbittorrent,🎯 Direct',
        'PROCESS-NAME,uTorrent,🎯 Direct',

        // ====== 4. 终极兜底层 ======
        'MATCH,🐟 漏网之鱼',
    ],
];
