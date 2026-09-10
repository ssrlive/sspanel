<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\SysLog;
use App\Services\I18n;
use App\Utils\Tools;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Smarty\Exception;
use function in_array;
use function strlen;

final class SysLogController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.syslog.fields.operation',
            'id' => 'admin.syslog.fields.event_id',
            'user_id' => 'admin.syslog.fields.trigger_user',
            'ip' => 'admin.syslog.fields.trigger_ip',
            'message' => 'admin.syslog.fields.message',
            'level' => 'admin.syslog.fields.level',
            'channel' => 'admin.syslog.fields.channel',
            'datetime' => 'admin.syslog.fields.datetime',
        ],
    ];

    /**
     * 系统日志页面
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
        return $response->write($view->fetch('admin/syslog/index.tpl'));
    }

    /**
     * 系统日志详情页面
     *
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $syslog = (new SysLog())->find($args['id']);

        if ($syslog === null) {
            return $response->withRedirect('/admin/syslog');
        }

        $syslog->level_text = $syslog->level();
        $syslog->context = json_decode($syslog->context);
        $syslog->channel_text = I18n::trans('admin.syslog.channels.' . $syslog->channel, $this->user->locale);
        $syslog->datetime = Tools::toDateTime($syslog->datetime);

        $view = $this->view();
        $view->assign('syslog', $syslog);
        return $response->write($view->fetch('admin/syslog/view.tpl'));
    }

    /**
     * 系统日志页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');
        $syslog = SysLog::query();
        $search = $request->getParam('search')['value'];

        if ($search !== '') {
            $syslog->where('user_id', '=', $search)
                ->orWhere('ip', 'LIKE', "%{$search}%")
                ->orWhere('message', 'LIKE', "%{$search}%")
                ->orWhere('level', 'LIKE', "%{$search}%")
                ->orWhere('channel', 'LIKE', "%{$search}%");
        }

        $order = $request->getParam('order')[0]['dir'];

        if ($request->getParam('order')[0]['column'] !== '0') {
            $order_by = $request->getParam('columns')[$request->getParam('order')[0]['column']]['data'];
            $syslog->orderBy($order_by, $order)->orderBy('id', 'desc');
        } else {
            $syslog->orderBy('id', $order);
        }

        $filtered = $syslog->count();
        $total = (new SysLog())->count();
        $syslogs = $syslog->paginate($length, '*', '', $page);

        foreach ($syslogs as $log) {
            $log->op = '<a class="btn btn-primary" href="/admin/syslog/' . $log->id . '/view">'
                . I18n::trans('admin.syslog.actions.view', $this->user->locale) . '</a>';
            $log->message = strlen($log->message) > 25 ?
                substr($log->message, 0, 25) . '...' : $log->message;
            $log->level = $log->level();
            $channel = in_array($log->channel, ['cron', 'sub', 'auth', 'user', 'admin'], true) ? $log->channel : 'unknown';
            $log->channel = I18n::trans('admin.syslog.channels.' . $channel, $this->user->locale);
            $log->datetime = Tools::toDateTime($log->datetime);
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $filtered,
            'syslogs' => $syslogs,
        ]);
    }
}
