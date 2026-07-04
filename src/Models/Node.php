<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Query\Builder;
use function time;

/**
 * @property int    $id                      节点ID
 * @property string $name                    节点名称
 * @property int    $type                    节点启用
 * @property string $server                  节点地址
 * @property string $custom_config           自定义配置
 * @property int    $sort                    节点类型
 * @property float  $traffic_rate            流量倍率
 * @property int    $is_dynamic_rate         是否启用动态流量倍率
 * @property int    $dynamic_rate_type       动态流量倍率计算方式
 * @property string $dynamic_rate_config     动态流量倍率配置
 * @property int    $node_class              节点等级
 * @property int    $node_speedlimit         节点限速
 * @property int    $node_bandwidth          节点流量
 * @property int    $node_bandwidth_limit    节点流量限制
 * @property int    $bandwidthlimit_resetday 流量重置日
 * @property int    $node_heartbeat          节点心跳
 * @property int    $online_user             节点在线用户
 * @property int    $node_group              节点群组
 * @property int    $online                  在线状态
 * @property int    $gfw_block               是否被GFW封锁
 * @property string $password                后端连接密码
 *
 * @mixin Builder
 */
final class Node extends Model
{
    protected $connection = 'default';
    protected $table = 'node';

    protected $casts = [
        'traffic_rate' => 'float',
        'node_heartbeat' => 'int',
    ];

    /**
     * 节点状态颜色
     */
    public function getColorAttribute(): string
    {
        return match ($this->getNodeOnlineStatus()) {
            0 => 'orange',
            1 => 'green',
            default => 'red',
        };
    }

    /**
     * 节点是否显示和隐藏
     */
    public function type(): string
    {
        return $this->type ? '显示' : '隐藏';
    }

    /**
     * 节点类型
     */
    public function sort(): string
    {
        return match ($this->sort) {
            0 => 'Shadowsocks',
            1 => 'Shadowsocks2022',
            2 => 'TUIC',
            3 => 'WireGuard',
            4 => 'OverTLS',
            11 => 'Vmess',
            14 => 'Trojan',
            default => '未知',
        };
    }

    public function isDynamicRate(): string
    {
        return $this->is_dynamic_rate ? '是' : '否';
    }

    public function dynamicRateType(): string
    {
        return match ($this->dynamic_rate_type) {
            0 => 'Logistic',
            1 => 'Linear',
            default => '未知',
        };
    }

    /**
     * 获取节点在线状态
     *
     * @return int 0 = new node, -1 = offline, 1 = online
     */
    public function getNodeOnlineStatus(): int
    {
        return $this->node_heartbeat === 0 ? 0 : ($this->node_heartbeat + 600 > time() ? 1 : -1);
    }
}
