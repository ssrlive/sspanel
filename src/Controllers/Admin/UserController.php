<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\AuthController;
use App\Controllers\BaseController;
use App\Models\Config;
use App\Models\User;
use App\Models\UserMoneyLog;
use App\Services\I18n;
use App\Utils\Hash;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class UserController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.user.fields.operation',
            'id' => 'admin.user.fields.id',
            'user_name' => 'admin.user.fields.nickname',
            'email' => 'admin.user.fields.email',
            'money' => 'admin.user.fields.balance',
            'ref_by' => 'admin.user.fields.referrer',
            'transfer_enable' => 'admin.user.fields.traffic_limit',
            'transfer_used' => 'admin.user.fields.current_usage',
            'class' => 'admin.user.fields.class',
            'is_admin' => 'admin.user.fields.is_admin',
            'is_banned' => 'admin.user.fields.is_banned',
            'is_inactive' => 'admin.user.fields.is_inactive',
            'reg_date' => 'admin.user.fields.registered_at',
            'class_expire' => 'admin.user.fields.class_expires',
        ],
        'create_dialog' => [
            [
                'id' => 'email',
                'info' => 'admin.user.fields.login_email',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'password',
                'info' => 'admin.user.fields.login_password',
                'type' => 'input',
                'placeholder' => 'admin.user.placeholders.random_password',
            ],
            [
                'id' => 'ref_by',
                'info' => 'admin.user.fields.referrer',
                'type' => 'input',
                'placeholder' => 'admin.user.placeholders.referrer',
            ],
            [
                'id' => 'balance',
                'info' => 'admin.user.fields.balance',
                'type' => 'input',
                'placeholder' => 'admin.user.placeholders.balance',
            ],
        ],
    ];

    private static array $update_field = [
        'email',
        'user_name',
        'pass',
        'money',
        'ref_by',
        'port',
        'method',
        'transfer_enable',
        'node_group',
        'class',
        'class_expire',
        'auto_reset_day',
        'auto_reset_bandwidth',
        'node_speedlimit',
        'node_iplimit',
        'locale',
        'banned_reason',
        'remark',
    ];

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('details', self::$details);
        return $response->write($view->fetch('admin/user/index.tpl'));
    }

    /**
     * @throws Exception
     */
    public function create(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $email = $request->getParam('email');
        $ref_by = $request->getParam('ref_by');
        $password = $request->getParam('password');
        $balance = $request->getParam('balance');

        if ($email === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.user.messages.email_required', $this->user->locale),
            ]);
        }

        $exist = (new User())->where('email', $email)->first();

        if ($exist !== null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.user.messages.email_exists', $this->user->locale),
            ]);
        }

        if ($password === '') {
            $password = Tools::genRandomChar(16);
        }

        $remoteAddr = $request->getServerParam('REMOTE_ADDR') ?? '';

        (new AuthController())->registerHelper(
            $response,
            'user',
            $email,
            $password,
            '',
            '0',
            '',
            $balance,
            $remoteAddr,
            $request->getCookieParams(),
            $request->getServerParams(),
            false
        );
        $user = (new User())->where('email', $email)->first();

        if ($ref_by !== '') {
            $user->ref_by = (int) $ref_by;
            $user->save();
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.user.messages.created', $this->user->locale, ['email' => $email, 'password' => $password]),
        ]);
    }

    /**
     * @throws Exception
     */
    public function edit(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $user = (new User())->find($args['id']);
        $user->last_use_time = Tools::toDateTime($user->last_use_time);
        $user->last_check_in_time = Tools::toDateTime($user->last_check_in_time);
        $user->last_login_time = Tools::toDateTime($user->last_login_time);

        $view = $this->view();
        $view->assign('update_field', self::$update_field)
            ->assign('edit_user', $user)
            ->assign('ss_methods', Tools::getSsMethod())
            ->assign('locales', I18n::getLocaleList());
        return $response->write($view->fetch('admin/user/edit.tpl'));
    }

    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = (int) $args['id'];
        $user = (new User())->find($id);

        if ($request->getParam('pass') !== '' && $request->getParam('pass') !== null) {
            $user->pass = Hash::passwordHash($request->getParam('pass'));

            if (Config::obtain('enable_forced_replacement')) {
                $user->removeLink();
            }
        }

        if (
            $request->getParam('money') !== '' &&
            $request->getParam('money') !== null &&
            (float) $request->getParam('money') !== $user->money
        ) {
            $money = (float) $request->getParam('money');
            $diff = $money - $user->money;
            $remark = ($diff > 0 ? I18n::trans('admin.user.messages.balance_added', $this->user->locale) : I18n::trans('admin.user.messages.balance_deducted', $this->user->locale));
            (new UserMoneyLog())->add($id, (float) $user->money, $money, $diff, $remark);
            $user->money = $money;
        }

        $user->email = $request->getParam('email');
        $user->user_name = $request->getParam('user_name');
        $user->ref_by = $request->getParam('ref_by');
        $user->port = $request->getParam('port');
        $user->method = $request->getParam('method');
        $user->transfer_enable = Tools::autoBytesR($request->getParam('transfer_enable'));
        $user->node_group = $request->getParam('node_group');
        $user->class = $request->getParam('class');
        $user->class_expire = $request->getParam('class_expire');
        $user->auto_reset_day = $request->getParam('auto_reset_day');
        $user->auto_reset_bandwidth = $request->getParam('auto_reset_bandwidth');
        $user->node_speedlimit = $request->getParam('node_speedlimit');
        $user->node_iplimit = $request->getParam('node_iplimit');
        $user->locale = $request->getParam('locale');
        $user->is_admin = $request->getParam('is_admin') === 'true' ? 1 : 0;
        $user->ga_enable = $request->getParam('ga_enable') === 'true' ? 1 : 0;
        $user->is_shadow_banned = $request->getParam('is_shadow_banned') === 'true' ? 1 : 0;
        $user->is_banned = $request->getParam('is_banned') === 'true' ? 1 : 0;
        $user->banned_reason = $request->getParam('banned_reason');
        $user->remark = $request->getParam('remark');

        if (! $user->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.user.messages.update_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.user.messages.updated', $this->user->locale),
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $user = (new User())->find((int) $id);

        if (! $user->kill()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.user.messages.delete_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.user.messages.deleted', $this->user->locale),
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $users = (new User())->orderBy('id', 'desc')->get();

        foreach ($users as $user) {
            $user->op = '<button class="btn btn-red" id="delete-user-' . $user->id . '" 
            onclick="deleteUser(' . $user->id . ')">' . I18n::trans('admin.user.delete', $this->user->locale) . '</button>
            <a class="btn btn-primary" href="/admin/user/' . $user->id . '/edit">' . I18n::trans('admin.user.edit', $this->user->locale) . '</a>';
            $user->transfer_enable = $user->enableTraffic();
            $user->transfer_used = $user->usedTraffic();
            $user->is_admin = $user->is_admin === 1 ? I18n::trans('admin.user.options.yes', $this->user->locale) : I18n::trans('admin.user.options.no', $this->user->locale);
            $user->is_banned = $user->is_banned === 1 ? I18n::trans('admin.user.options.yes', $this->user->locale) : I18n::trans('admin.user.options.no', $this->user->locale);
            $user->is_inactive = $user->is_inactive === 1 ? I18n::trans('admin.user.options.yes', $this->user->locale) : I18n::trans('admin.user.options.no', $this->user->locale);
        }

        return $response->withJson([
            'users' => $users,
        ]);
    }
}
