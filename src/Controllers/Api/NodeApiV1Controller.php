<?php

declare(strict_types=1);

namespace App\Controllers\Api;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Models\DetectLog;
use App\Models\DetectRule;
use App\Models\HourlyUsage;
use App\Models\Node;
use App\Models\OnlineLog;
use App\Models\User;
use App\Services\DynamicRate;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function count;
use function date;
use function is_array;
use function json_decode;
use function time;

final class NodeApiV1Controller extends BaseController
{
    public function getHeartbeat(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = $this->getEnabledNode($request, $response);

        if ($node === null) {
            return $response;
        }

        $node->update(['node_heartbeat' => time()]);

        return ResponseHelper::successWithData($response, 'ok', [
            'node_id' => $node->id,
            'node_heartbeat' => $node->node_heartbeat,
        ]);
    }

    public function getInfo(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = $this->getEnabledNode($request, $response);

        if ($node === null) {
            return $response;
        }

        return ResponseHelper::successWithData($response, '', [
            'node_id' => $node->id,
            'name' => $node->name,
            'type' => $node->type,
            'sort' => $node->sort,
            'server' => $node->server,
            'ipv4' => $node->ipv4,
            'ipv6' => $node->ipv6,
            'node_speedlimit' => $node->node_speedlimit,
            'node_class' => $node->node_class,
            'node_group' => $node->node_group,
            'traffic_rate' => $node->traffic_rate,
            'is_dynamic_rate' => $node->is_dynamic_rate,
            'dynamic_rate_type' => $node->dynamic_rate_type,
            'dynamic_rate_config' => json_decode($node->dynamic_rate_config, true),
            'node_bandwidth_limit' => $node->node_bandwidth_limit,
            'bandwidthlimit_resetday' => $node->bandwidthlimit_resetday,
            'node_bandwidth' => $node->node_bandwidth,
            'node_heartbeat' => $node->node_heartbeat,
            'online_user' => $node->online_user,
            'gfw_block' => $node->gfw_block,
            'custom_config' => json_decode($node->custom_config, true),
        ]);
    }

    public function getUser(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        return $this->getUsers($request, $response, $args);
    }

    public function getUsers(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = $this->getEnabledNode($request, $response);

        if ($node === null) {
            return $response;
        }

        if ($node->node_bandwidth_limit !== 0 && $node->node_bandwidth_limit <= $node->node_bandwidth) {
            return ResponseHelper::error($response, 'Node out of bandwidth.');
        }

        $users_raw = (new User())
            ->where(static function ($query) use ($node): void {
                $query->where('class', '>=', $node->node_class)
                    ->where(static function ($query) use ($node): void {
                        if ($node->node_group !== 0) {
                            $query->where('node_group', $node->node_group);
                        }
                    });
            })
            ->orWhere('is_admin', 1)
            ->get([
                'id',
                'u',
                'd',
                'transfer_enable',
                'node_speedlimit',
                'node_iplimit',
                'method',
                'port',
                'passwd',
                'uuid',
                'is_admin',
                'is_banned',
                'class_expire',
            ]);

        $users = [];
        $now = date('Y-m-d H:i:s');

        foreach ($users_raw as $user_raw) {
            $enable = true;

            if ($user_raw->is_banned === 1 || $user_raw->class_expire <= $now) {
                $enable = false;
            }

            $online_user_count = (new OnlineLog())
                ->where('user_id', $user_raw->id)
                ->where('last_time', '>', time() - 90)
                ->count();

            if ($user_raw->node_iplimit !== 0 && $user_raw->node_iplimit < $online_user_count) {
                $enable = false;
            }

            if ($user_raw->transfer_enable <= $user_raw->u + $user_raw->d && ! $_ENV['keep_connect']) {
                $enable = false;
            }

            $users[] = [
                'client_id' => $user_raw->uuid,
                'enable' => $enable,
            ];
        }

        return ResponseHelper::successWithDataEtag($request, $response, [
            'users' => $users,
        ]);
    }

    public function getDetectRule(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = $this->getEnabledNode($request, $response);

        if ($node === null) {
            return $response;
        }

        return ResponseHelper::successWithDataEtag($request, $response, [
            'node_id' => $node->id,
            'rules' => Config::obtain('detect_rule') ? DetectRule::all()->toArray() : [],
        ]);
    }

    public function addUserTraffic(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $data = json_decode($request->getBody()->__toString());

        if (! $data || ! is_array($data->data ?? null)) {
            return ResponseHelper::error($response, 'Invalid data.');
        }

        $node = $this->getEnabledNode($request, $response);

        if ($node === null) {
            return $response;
        }

        $rate = $this->getNodeTrafficRate($node);
        $sum = 0;
        $is_traffic_log = Config::obtain('traffic_log');

        foreach ($data->data as $log) {
            $u = (int) ($log?->u ?? 0);
            $d = (int) ($log?->d ?? 0);
            $user_id = (int) ($log?->user_id ?? 0);
            $client_id = (string) ($log?->client_id ?? '');

            if ($user_id <= 0 && $client_id !== '') {
                $user = (new User())->where('uuid', $client_id)->first();
                if ($user !== null) {
                    $user_id = (int) $user->id;
                }
            }

            if ($user_id > 0) {
                $billed_u = (int) ($u * $rate);
                $billed_d = (int) ($d * $rate);

                $user = (new User())->find($user_id);

                if ($user !== null) {
                    $user->update([
                        'last_use_time' => time(),
                        'u' => $user->u + $billed_u,
                        'd' => $user->d + $billed_d,
                        'transfer_total' => $user->transfer_total + $u + $d,
                        'transfer_today' => $user->transfer_today + $billed_u + $billed_d,
                    ]);
                }
            }

            if ($is_traffic_log) {
                (new HourlyUsage())->add($user_id, $u + $d);
            }

            $sum += $u + $d;
        }

        $node->update([
            'node_bandwidth' => $node->node_bandwidth + $sum,
            'online_user' => count($data->data) - 1,
        ]);

        return ResponseHelper::success($response, 'ok');
    }

    public function addUserOnlineIp(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $data = json_decode($request->getBody()->__toString());

        if (! $data || ! is_array($data->data ?? null)) {
            return ResponseHelper::error($response, 'Invalid data.');
        }

        $node = $this->getEnabledNode($request, $response);

        if ($node === null) {
            return $response;
        }

        foreach ($data->data as $log) {
            $ip = (string) ($log?->ip ?? '');
            $user_id = (int) ($log?->user_id ?? 0);

            if (Tools::isIPv4($ip)) {
                $ip = '::ffff:' . $ip;
            } elseif (! Tools::isIPv6($ip)) {
                continue;
            }

            (new OnlineLog())->upsert(
                [
                    'user_id' => $user_id,
                    'ip' => $ip,
                    'node_id' => $node->id,
                    'first_time' => time(),
                    'last_time' => time(),
                ],
                ['user_id', 'ip'],
                ['node_id', 'last_time']
            );
        }

        return ResponseHelper::success($response, 'ok');
    }

    public function addUserDetectLog(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $data = json_decode($request->getBody()->__toString());

        if (! $data || ! is_array($data->data ?? null)) {
            return ResponseHelper::error($response, 'Invalid data.');
        }

        $node = $this->getEnabledNode($request, $response);

        if ($node === null) {
            return $response;
        }

        foreach ($data->data as $log) {
            (new DetectLog())->insert([
                'user_id' => (int) ($log?->user_id ?? 0),
                'list_id' => (int) ($log?->list_id ?? 0),
                'node_id' => $node->id,
                'datetime' => time(),
            ]);
        }

        return ResponseHelper::success($response, 'ok');
    }

    private function getEnabledNode(ServerRequest $request, Response $response): ?Node
    {
        $nodeId = (int) $request->getQueryParam('node_id', 0);
        $node = (new Node())->find($nodeId);

        if ($node === null) {
            ResponseHelper::error($response, 'Node not found.');

            return null;
        }

        if ($node->type === 0) {
            ResponseHelper::error($response, 'Node is not enabled.');

            return null;
        }

        return $node;
    }

    private function getNodeUserUnsetFields(Node $node): array
    {
        return match ($node->sort) {
            14, 11 => ['u', 'd', 'transfer_enable', 'method', 'port', 'passwd', 'node_iplimit'],
            2 => ['u', 'd', 'transfer_enable', 'method', 'port', 'node_iplimit'],
            1 => ['u', 'd', 'transfer_enable', 'method', 'port', 'uuid', 'node_iplimit'],
            default => ['u', 'd', 'transfer_enable', 'uuid', 'node_iplimit'],
        };
    }

    private function getNodeTrafficRate(Node $node): float|int
    {
        if ($node->is_dynamic_rate) {
            $dynamic_rate_config = json_decode($node->dynamic_rate_config);

            $dynamic_rate_type = match ($node->dynamic_rate_type) {
                1 => 'linear',
                default => 'logistic',
            };

            return DynamicRate::getRateByTime(
                (float) ($dynamic_rate_config?->max_rate ?? 1),
                (int) ($dynamic_rate_config?->max_rate_time ?? 0),
                (float) ($dynamic_rate_config?->min_rate ?? 1),
                (int) ($dynamic_rate_config?->min_rate_time ?? 0),
                (int) date('H'),
                $dynamic_rate_type
            );
        }

        return $node->traffic_rate;
    }
}
