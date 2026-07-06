<?php

declare(strict_types=1);

namespace App\Controllers\Admin\Setting;

use App\Controllers\BaseController;
use App\Models\Config;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Smarty\Exception;

final class SubController extends BaseController
{
    private array $update_field;
    private array $settings;

    public function __construct()
    {
        parent::__construct();
        $this->ensureUniversalSubscribeSettings();
        $this->update_field = Config::getItemListByClass('subscribe');
        $this->settings = Config::getClass('subscribe');
    }

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('update_field', $this->update_field)
            ->assign('settings', $this->settings);
        return $response->write($view->fetch('admin/setting/sub.tpl'));
    }

    public function save(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        foreach ($this->update_field as $item) {
            if (! Config::set($item, $request->getParam($item))) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => '保存 ' . $item . ' 时出错',
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => '保存成功',
        ]);
    }

    private function ensureUniversalSubscribeSettings(): void
    {
        $default_subscribe_settings = [
            'enable_json_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'Json 通用订阅开关',
            ],
            'enable_clash_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'Clash 通用订阅开关',
            ],
            'enable_singbox_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'SingBox 通用订阅开关',
            ],
            'enable_v2rayjson_sub' => [
                'value' => '1',
                'type' => 'bool',
                'is_public' => 1,
                'default' => '1',
                'mark' => 'V2Ray Json 通用订阅开关',
            ],
        ];

        foreach ($default_subscribe_settings as $item => $meta) {
            if ((new Config())->where('item', $item)->count() === 0) {
                Config::query()->insert([
                    'item' => $item,
                    'value' => $meta['value'],
                    'class' => 'subscribe',
                    'is_public' => $meta['is_public'],
                    'type' => $meta['type'],
                    'default' => $meta['default'],
                    'mark' => $meta['mark'],
                ]);
            }
        }
    }
}
