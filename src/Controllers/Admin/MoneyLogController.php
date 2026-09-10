<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\UserMoneyLog;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class MoneyLogController extends BaseController
{
    private static array $details = [
        'field' => [
            'id' => 'admin.money_log.fields.event_id',
            'user_id' => 'admin.money_log.fields.user_id',
            'before' => 'admin.money_log.fields.before',
            'after' => 'admin.money_log.fields.after',
            'amount' => 'admin.money_log.fields.amount',
            'remark' => 'admin.money_log.fields.remark',
            'create_time' => 'admin.money_log.fields.create_time',
        ],
    ];

    /**
     * 后台用户余额记录页面
     *
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $details = self::$details;
        foreach ($details['field'] as $key => $value) {
            $details['field'][$key] = I18n::trans($value, $this->user->locale);
        }
        $view->assign('details', $details);
        return $response->write($view->fetch('admin/log/money.tpl'));
    }

    /**
     * 后台用户余额记录页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $money_logs = (new UserMoneyLog())->orderBy('id', 'desc')->get();

        foreach ($money_logs as $money_log) {
            $money_log->create_time = Tools::toDateTime((int) $money_log->create_time);
        }

        return $response->withJson([
            'money_logs' => $money_logs,
        ]);
    }
}
