<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\DetectBanLog;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class DetectBanLogController extends BaseController
{
    private static array $columns = [
        'id',
        'user_id',
        'detect_number',
        'ban_time',
        'start_time',
        'end_time',
        'ban_end_time',
        'all_detect_number',
    ];

    private static array $details = [
        'field' => [
            'id' => 'admin.detect_ban_log.fields.event_id',
            'user_id' => 'admin.detect_ban_log.fields.user_id',
            'detect_number' => 'admin.detect_ban_log.fields.detect_number',
            'ban_time' => 'admin.detect_ban_log.fields.ban_time',
            'start_time' => 'admin.detect_ban_log.fields.start_time',
            'end_time' => 'admin.detect_ban_log.fields.end_time',
            'ban_end_time' => 'admin.detect_ban_log.fields.ban_end_time',
            'all_detect_number' => 'admin.detect_ban_log.fields.all_detect_number',
        ],
    ];

    /**
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
        return $response->write($view->fetch('admin/log/detect_ban.tpl'));
    }

    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $length = $request->getParam('length');
        $page = $request->getParam('start') / $length + 1;
        $draw = $request->getParam('draw');

        $detect_ban_log = DetectBanLog::query();

        $search = $request->getParam('search')['value'];

        if ($search !== '') {
            $detect_ban_log->where('user_id', '=', $search);
        }

        $order = $request->getParam('order')[0]['dir'];

        if ($request->getParam('order')[0]['column'] !== '0') {
            $order_field = self::$columns[(int) $request->getParam('order')[0]['column']] ?? 'id';

            $detect_ban_log->orderBy($order_field, $order)->orderBy('id', 'desc');
        } else {
            $detect_ban_log->orderBy('id', $order);
        }

        $filtered = $detect_ban_log->count();
        $total = (new DetectBanLog())->count();

        $bans = $detect_ban_log->paginate($length, '*', '', $page);

        foreach ($bans as $ban) {
            $ban->start_time = Tools::toDateTime((int) $ban->start_time);
            $ban->end_time = Tools::toDateTime((int) $ban->end_time);
            $ban->ban_end_time = $ban->banEndTime();
        }

        return $response->withJson([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $filtered,
            'bans' => $bans,
        ]);
    }
}
