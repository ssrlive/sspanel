<?php

declare(strict_types=1);

namespace App\Controllers\Admin\Setting;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Services\I18n;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Smarty\Exception;

final class LlmController extends BaseController
{
    private array $update_field;
    private array $settings;

    public function __construct()
    {
        parent::__construct();
        $this->update_field = Config::getItemListByClass('llm');
        $this->settings = Config::getClass('llm');
    }

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('update_field', $this->update_field)
            ->assign('settings', $this->settings);
        return $response->write($view->fetch('admin/setting/llm.tpl'));
    }

    public function save(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        foreach ($this->update_field as $item) {
            if (! Config::set($item, $request->getParam($item))) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans('admin.llm.messages.save_failed', $this->user->locale, ['field' => $item]),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.llm.messages.saved', $this->user->locale),
        ]);
    }
}
