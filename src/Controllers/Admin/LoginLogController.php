<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\LoginIp;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use MaxMind\Db\Reader\InvalidDatabaseException;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class LoginLogController extends BaseController
{
    private static array $details = [
        'field' => [
            'id' => 'admin.login_log.fields.event_id',
            'userid' => 'admin.login_log.fields.user_id',
            'ip' => 'admin.login_log.fields.login_ip',
            'location' => 'admin.login_log.fields.location',
            'datetime' => 'admin.login_log.fields.datetime',
            'type' => 'admin.login_log.fields.type',
        ],
    ];

    /**
     * 后台登录记录页面
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
        return $response->write($view->fetch('admin/log/login.tpl'));
    }

    /**
     * 后台登录记录页面 AJAX
     *
     * @throws InvalidDatabaseException
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $login_log = LoginIp::query();

        $search = $request->getParam('search')['value'];

        if ($search !== '') {
            $login_log->where('userid', '=', $search)
                ->orWhere('ip', 'LIKE', "%{$search}%");
        }

        $order = $request->getParam('order')[0]['dir'];

        if ($request->getParam('order')[0]['column'] !== '0') {
            $order_by = $request->getParam('columns')[$request->getParam('order')[0]['column']]['data'];

            $login_log->orderBy($order_by, $order)->orderBy('id', 'desc');
        } else {
            $login_log->orderBy('id', $order);
        }

        $filtered = $login_log->count();
        $total = (new LoginIp())->count();

        $logins = $login_log->paginate($length, '*', '', $page);

        foreach ($logins as $login) {
            $login->location = Tools::getIpLocation($login->ip);
            if ($login->location === 'GeoIP2 服务未配置') {
                $login->location = I18n::trans('admin.login_log.geoip_unavailable', $this->user->locale);
            }
            $login->datetime = Tools::toDateTime((int) $login->datetime);
            $login->type = I18n::trans($login->type === 0 ? 'admin.login_log.success' : 'admin.login_log.failure', $this->user->locale);
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $filtered,
            'logins' => $logins,
        ]);
    }
}
