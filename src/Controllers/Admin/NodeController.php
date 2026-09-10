<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Models\Node;
use App\Services\I18n;
use App\Services\Notification;
use App\Utils\Env;
use App\Utils\Tools;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Smarty\Exception as SmartyException;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function json_decode;
use function json_encode;
use function round;
use function str_replace;
use function trim;

final class NodeController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.node.fields.operation',
            'id' => 'admin.node.fields.id',
            'name' => 'admin.node.fields.name',
            'server' => 'admin.node.fields.server',
            'type' => 'admin.node.fields.status',
            'sort' => 'admin.node.fields.type',
            'traffic_rate' => 'admin.node.fields.traffic_rate',
            'is_dynamic_rate' => 'admin.node.fields.dynamic_rate',
            'dynamic_rate_type' => 'admin.node.fields.dynamic_rate_type',
            'node_class' => 'admin.node.fields.class',
            'node_group' => 'admin.node.fields.group',
            'node_bandwidth_limit' => 'admin.node.fields.bandwidth_limit',
            'node_bandwidth' => 'admin.node.fields.bandwidth_used',
            'bandwidthlimit_resetday' => 'admin.node.fields.reset_day',
        ],
    ];

    private static array $update_field = [
        'name',
        'server',
        'traffic_rate',
        'is_dynamic_rate',
        'dynamic_rate_type',
        'max_rate',
        'max_rate_time',
        'min_rate',
        'min_rate_time',
        'node_group',
        'node_speedlimit',
        'sort',
        'node_class',
        'node_bandwidth_limit',
        'bandwidthlimit_resetday',
    ];

    /**
     * 后台节点页面
     *
     * @throws SmartyException
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $details = self::$details;
        foreach ($details['field'] as $key => $value) {
            $details['field'][$key] = I18n::trans($value, $this->user->locale);
        }
        $view->assign('details', $details);
        return $response->write($view->fetch('admin/node/index.tpl'));
    }

    /**
     * 后台创建节点页面
     *
     * @throws SmartyException
     */
    public function create(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('update_field', self::$update_field);
        return $response->write($view->fetch('admin/node/create.tpl'));
    }

    /**
     * 后台添加节点
     */
    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = new Node();

        $node->name = $request->getParam('name');
        $node->node_group = $request->getParam('node_group');
        $node->server = trim($request->getParam('server'));
        $node->traffic_rate = $request->getParam('traffic_rate') ?? 1;
        $node->is_dynamic_rate = $request->getParam('is_dynamic_rate') === 'true' ? 1 : 0;
        $node->dynamic_rate_type = $request->getParam('dynamic_rate_type') ?? 0;
        $node->dynamic_rate_config = json_encode([
            'max_rate' => $request->getParam('max_rate') ?? 1,
            'max_rate_time' => $request->getParam('max_rate_time') ?? 22,
            'min_rate' => $request->getParam('min_rate') ?? 1,
            'min_rate_time' => $request->getParam('min_rate_time') ?? 3,
        ]);

        $custom_config = $request->getParam('custom_config') ?? '{}';

        if ($custom_config !== '') {
            $node->custom_config = $custom_config;
        } else {
            $node->custom_config = '{}';
        }

        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->type = $request->getParam('type') === 'true' ? 1 : 0;
        $node->sort = $request->getParam('sort');
        $node->node_class = $request->getParam('node_class');
        $node->node_bandwidth_limit = Tools::gbToB((int) $request->getParam('node_bandwidth_limit'));
        $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');
        $node->password = Tools::genRandomChar(32);

        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.node.messages.create_failed', $this->user->locale),
            ]);
        }

        if (Config::obtain('im_bot_group_notify_add_node')) {
            try {
                Notification::notifyUserGroup(
                    str_replace(
                        '%node_name%',
                        $request->getParam('name'),
                        I18n::trans('bot.node_added', Env::get('locale'))
                    )
                );
            } catch (TelegramSDKException | GuzzleException) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => I18n::trans('admin.node.messages.created_im_failed', $this->user->locale),
                    'node_id' => $node->id,
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.node.messages.created', $this->user->locale),
            'node_id' => $node->id,
        ]);
    }

    /**
     * 后台编辑指定节点页面
     *
     * @throws SmartyException
     */
    public function edit(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = (new Node())->find($args['id']);

        $dynamic_rate_config = json_decode($node->dynamic_rate_config);
        $node->max_rate = $dynamic_rate_config?->max_rate ?? 1;
        $node->max_rate_time = $dynamic_rate_config?->max_rate_time ?? 22;
        $node->min_rate = $dynamic_rate_config?->min_rate ?? 1;
        $node->min_rate_time = $dynamic_rate_config?->min_rate_time ?? 3;

        $node->node_bandwidth = Tools::autoBytes($node->node_bandwidth);
        $node->node_bandwidth_limit = Tools::bToGB($node->node_bandwidth_limit);

        $view = $this->view();
        $view->assign('node', $node)
            ->assign('update_field', self::$update_field);
        return $response->write($view->fetch('admin/node/edit.tpl'));
    }

    /**
     * 后台更新指定节点内容
     */
    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = (new Node())->find($args['id']);

        $node->name = $request->getParam('name');
        $node->node_group = $request->getParam('node_group') ?? 0;
        $node->server = trim($request->getParam('server'));
        $node->traffic_rate = $request->getParam('traffic_rate') ?? 1;
        $node->is_dynamic_rate = $request->getParam('is_dynamic_rate') === 'true' ? 1 : 0;
        $node->dynamic_rate_type = $request->getParam('dynamic_rate_type') ?? 0;
        $node->dynamic_rate_config = json_encode([
            'max_rate' => $request->getParam('max_rate') ?? 1,
            'max_rate_time' => $request->getParam('max_rate_time') ?? 0,
            'min_rate' => $request->getParam('min_rate') ?? 1,
            'min_rate_time' => $request->getParam('min_rate_time') ?? 0,
        ]);

        $custom_config = $request->getParam('custom_config') ?? '{}';

        if ($custom_config !== '') {
            $node->custom_config = $custom_config;
        } else {
            $node->custom_config = '{}';
        }

        $node->node_speedlimit = $request->getParam('node_speedlimit');
        $node->type = $request->getParam('type') === 'true' ? 1 : 0;
        $node->sort = $request->getParam('sort');
        $node->node_class = $request->getParam('node_class');
        $node->node_bandwidth_limit = Tools::gbToB((int) $request->getParam('node_bandwidth_limit'));
        $node->bandwidthlimit_resetday = $request->getParam('bandwidthlimit_resetday');

        if (! $node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.node.messages.update_failed', $this->user->locale),
            ]);
        }

        if (Config::obtain('im_bot_group_notify_update_node')) {
            try {
                Notification::notifyUserGroup(
                    str_replace(
                        '%node_name%',
                        $request->getParam('name'),
                        I18n::trans('bot.node_updated', Env::get('locale'))
                    )
                );
            } catch (TelegramSDKException | GuzzleException) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => I18n::trans('admin.node.messages.updated_im_failed', $this->user->locale),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.node.messages.updated', $this->user->locale),
        ]);
    }

    public function resetPassword(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = (new Node())->find($args['id']);
        $node->password = Tools::genRandomChar(32);
        $node->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.node.messages.password_reset', $this->user->locale),
            'data' => [
                'password' => $node->password,
            ],
        ]);
    }

    public function resetBandwidth(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = (new Node())->find($args['id']);
        $node->node_bandwidth = 0;
        $node->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.node.messages.bandwidth_reset', $this->user->locale),
            'data' => [
                'node_bandwidth' => $node->node_bandwidth,
            ],
        ]);
    }

    /**
     * 后台删除指定节点
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $node = (new Node())->find($args['id']);

        if (! $node->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.node.messages.delete_failed', $this->user->locale),
            ]);
        }

        if (Config::obtain('im_bot_group_notify_delete_node')) {
            try {
                Notification::notifyUserGroup(
                    str_replace(
                        '%node_name%',
                        $node->name,
                        I18n::trans('bot.node_deleted', Env::get('locale'))
                    )
                );
            } catch (TelegramSDKException | GuzzleException) {
                return $response->withJson([
                    'ret' => 1,
                    'msg' => I18n::trans('admin.node.messages.deleted_im_failed', $this->user->locale),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.node.messages.deleted', $this->user->locale),
        ]);
    }

    public function copy(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $old_node = (new Node())->find($args['id']);
        $new_node = $old_node->replicate([
            'node_bandwidth',
        ]);
        $new_node->name .= ' (副本)';
        $new_node->node_bandwidth = 0;
        $new_node->password = Tools::genRandomChar(32);

        if (! $new_node->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.node.messages.copy_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.node.messages.copied', $this->user->locale),
        ]);
    }

    /**
     * 后台节点页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $nodes = (new Node())->orderBy('id', 'desc')->get();

        foreach ($nodes as $node) {
            $node->op = '<button class="btn btn-red" id="delete-node-' . $node->id . '" 
            onclick="deleteNode(' . $node->id . ')">' . I18n::trans('admin.node.actions.delete', $this->user->locale) . '</button>
            <button class="btn btn-orange" id="copy-node-' . $node->id . '" 
            onclick="copyNode(' . $node->id . ')">' . I18n::trans('admin.node.actions.copy', $this->user->locale) . '</button>
            <a class="btn btn-primary" href="/admin/node/' . $node->id . '/edit">' . I18n::trans('admin.node.actions.edit', $this->user->locale) . '</a>';
            $node->type = I18n::trans($node->type ? 'admin.node.options.visible' : 'admin.node.options.hidden', $this->user->locale);
            $node->sort = $node->sort();
            $node->is_dynamic_rate = I18n::trans($node->is_dynamic_rate ? 'admin.node.options.yes' : 'admin.node.options.no', $this->user->locale);
            $node->dynamic_rate_type = $node->dynamicRateType();
            $node->node_bandwidth = round(Tools::bToGB($node->node_bandwidth), 2);
            $node->node_bandwidth_limit = Tools::bToGB($node->node_bandwidth_limit);
        }

        return $response->withJson([
            'nodes' => $nodes,
        ]);
    }
}
