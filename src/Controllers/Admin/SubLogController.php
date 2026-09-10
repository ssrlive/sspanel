<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\SubscribeLog;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use MaxMind\Db\Reader\InvalidDatabaseException;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class SubLogController extends BaseController
{
    private static array $details = [
        'field' => [
            'id' => 'admin.sub_log.fields.event_id',
            'user_id' => 'admin.sub_log.fields.user_id',
            'type' => 'admin.sub_log.fields.type',
            'request_ip' => 'admin.sub_log.fields.request_ip',
            'location' => 'admin.sub_log.fields.location',
            'request_time' => 'admin.sub_log.fields.request_time',
            'request_user_agent' => 'admin.sub_log.fields.request_user_agent',
        ],
    ];

    /**
     * 后台订阅记录页面
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
        return $response->write($view->fetch('admin/log/sub.tpl'));
    }

    /**
     * 后台订阅记录页面 AJAX
     *
     * @throws InvalidDatabaseException
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $sub_log = SubscribeLog::query();

        $search = $request->getParam('search')['value'];

        if ($search !== '') {
            $sub_log->where('user_id', '=', $search)
                ->orWhere('type', 'LIKE', "%{$search}%")
                ->orWhere('request_ip', 'LIKE', "%{$search}%")
                ->orWhere('request_user_agent', 'LIKE', "%{$search}%");
        }

        $order = $request->getParam('order')[0]['dir'];

        if ($request->getParam('order')[0]['column'] !== '0') {
            $order_by = $request->getParam('columns')[$request->getParam('order')[0]['column']]['data'];

            $sub_log->orderBy($order_by, $order)->orderBy('id', 'desc');
        } else {
            $sub_log->orderBy('id', $order);
        }

        $filtered = $sub_log->count();
        $total = (new SubscribeLog())->count();

        $subscribes = $sub_log->paginate($length, '*', '', $page);

        foreach ($subscribes as $subscribe) {
            $subscribe->request_time = Tools::toDateTime($subscribe->request_time);
            $subscribe->location = $subscribe->getAttributes();
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $filtered,
            'subscribes' => $subscribes,
        ]);
    }
}
