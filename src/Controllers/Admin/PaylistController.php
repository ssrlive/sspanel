<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Paylist;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class PaylistController extends BaseController
{
    private static array $details = [
        'field' => [
            'id' => 'admin.gateway_log.fields.event_id',
            'userid' => 'admin.gateway_log.fields.user_id',
            'total' => 'admin.gateway_log.fields.amount',
            'status' => 'admin.gateway_log.fields.status',
            'gateway' => 'admin.gateway_log.fields.gateway',
            'tradeno' => 'admin.gateway_log.fields.transaction_id',
            'datetime' => 'admin.gateway_log.fields.payment_time',
            'invoice_id' => 'admin.gateway_log.fields.invoice_id',
        ],
    ];

    /**
     * 后台网关记录页面
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
        return $response->write($view->fetch('admin/log/gateway.tpl'));
    }

    /**
     * 后台网关记录页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $paylists = (new Paylist())->orderBy('id', 'desc')->get();

        foreach ($paylists as $paylist) {
            $paylist->status = I18n::trans(match ((int) $paylist->status) {
                0 => 'admin.gateway_log.status.unpaid',
                1 => 'admin.gateway_log.status.paid',
                default => 'admin.gateway_log.status.unknown',
            }, $this->user->locale);
            $paylist->datetime = Tools::toDateTime((int) $paylist->datetime);
        }

        return $response->withJson([
            'paylists' => $paylists,
        ]);
    }
}
