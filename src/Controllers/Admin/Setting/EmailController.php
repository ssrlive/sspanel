<?php

declare(strict_types=1);

namespace App\Controllers\Admin\Setting;

use App\Controllers\BaseController;
use App\Models\Config;
use App\Services\I18n;
use App\Services\Mail;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Smarty\Exception;
use Throwable;

final class EmailController extends BaseController
{
    private array $update_field;
    private array $settings;

    public function __construct()
    {
        parent::__construct();
        $this->update_field = Config::getItemListByClass('email');
        $this->settings = Config::getClass('email');
    }

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('update_field', $this->update_field)
            ->assign('settings', $this->settings);
        return $response->write($view->fetch('admin/setting/email.tpl'));
    }

    public function save(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        foreach ($this->update_field as $item) {
            if (! Config::set($item, $request->getParam($item))) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans('admin.email.messages.save_failed', $this->user->locale, ['field' => $item]),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.email.messages.saved', $this->user->locale),
        ]);
    }

    public function testEmail(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $to = $request->getParam('recipient');

        try {
            Mail::send(
                $to,
                I18n::trans('admin.email.messages.test_subject', $this->user->locale),
                'test.tpl'
            );
        } catch (Throwable $e) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.email.messages.test_failed', $this->user->locale) . ' ' . $e->getMessage(),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.email.messages.test_success', $this->user->locale),
        ]);
    }
}
