<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Payback;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class PaybackController extends BaseController
{
    private static array $details = [
        'field' => [
            'id' => 'admin.payback_log.fields.event_id',
            'total' => 'admin.payback_log.fields.total',
            'userid' => 'admin.payback_log.fields.user_id',
            'user_name' => 'admin.payback_log.fields.user_name',
            'ref_by' => 'admin.payback_log.fields.ref_user_id',
            'ref_user_name' => 'admin.payback_log.fields.ref_user_name',
            'ref_get' => 'admin.payback_log.fields.ref_amount',
            'invoice_id' => 'admin.payback_log.fields.invoice_id',
            'datetime' => 'admin.payback_log.fields.datetime',
        ],
    ];

    /**
     * 后台邀请记录页面
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
        return $response->write($view->fetch('admin/log/payback.tpl'));
    }

    /**
     * 后台登录记录页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $paybacks = (new Payback())->orderBy('id', 'desc')->get();

        foreach ($paybacks as $payback) {
            $payback->datetime = Tools::toDateTime((int) $payback->datetime);
            $payback->user_name = $payback->getAttributes();
            $payback->ref_user_name = $payback->getAttributes();
        }

        return $response->withJson([
            'paybacks' => $paybacks,
        ]);
    }
}
