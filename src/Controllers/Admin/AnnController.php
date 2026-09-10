<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Ann;
use App\Models\Config;
use App\Models\EmailQueue;
use App\Models\User;
use App\Services\I18n;
use App\Services\Notification;
use App\Utils\Env;
use App\Utils\Tools;
use Exception;
use GuzzleHttp\Exception\GuzzleException;
use League\HTMLToMarkdown\HtmlConverter;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function in_array;
use function strip_tags;
use function strlen;
use function time;
use const PHP_EOL;

final class AnnController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.announcement.fields.operation',
            'id' => 'admin.announcement.fields.id',
            'status' => 'admin.announcement.fields.status',
            'sort' => 'admin.announcement.fields.sort',
            'date' => 'admin.announcement.fields.date',
            'content' => 'admin.announcement.fields.content',
        ],
    ];

    private static array $update_field = [
        'status',
        'sort',
    ];

    /**
     * 后台公告页面
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
        return $response->write($view->fetch('admin/announcement/index.tpl'));
    }

    /**
     * 后台公告创建页面
     *
     * @throws Exception
     */
    public function create(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('update_field', self::$update_field);
        return $response->write($view->fetch('admin/announcement/create.tpl'));
    }

    /**
     * 后台添加公告
     */
    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $status = (int) $request->getParam('status');
        $sort = (int) $request->getParam('sort');
        $email_notify_class = (int) $request->getParam('email_notify_class');
        $email_notify = $request->getParam('email_notify') === 'true' ? 1 : 0;
        $content = $request->getParam('content');

        if ($content === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.announcement.messages.content_required', $this->user->locale),
            ]);
        }

        $ann = new Ann();
        $ann->status = in_array($status, [0, 1, 2]) ? $status : 1;
        $ann->sort = $sort > 999 || $sort < 0 ? 0 : $sort;
        $ann->date = Tools::toDateTime(time());
        $ann->content = $content;

        if (! $ann->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.announcement.messages.create_failed', $this->user->locale),
            ]);
        }

        if ($email_notify) {
            $users = (new User())->where('class', '>=', $email_notify_class)
                ->where('is_banned', '=', 0)
                ->get();
            $subject = Env::get('appName') . ' - ' . I18n::trans('admin.announcement.messages.new_subject', $this->user->locale);

            foreach ($users as $user) {
                (new EmailQueue())->add(
                    $user->email,
                    $subject,
                    'warn.tpl',
                    [
                        'user' => $user,
                        'text' => $content,
                    ]
                );
            }
        }

        if (Config::obtain('im_bot_group_notify_ann_create')) {
            $converter = new HtmlConverter(['strip_tags' => true]);
            $content = $converter->convert($content);

            try {
                Notification::notifyUserGroup(I18n::trans('admin.announcement.messages.new_notification', $this->user->locale) . PHP_EOL . $content);
            } catch (TelegramSDKException | GuzzleException) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans($email_notify === 1
                        ? 'admin.announcement.messages.created_email_im_failed'
                        : 'admin.announcement.messages.created_im_failed', $this->user->locale),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans($email_notify === 1
                ? 'admin.announcement.messages.created_email_sent'
                : 'admin.announcement.messages.created', $this->user->locale),
        ]);
    }

    /**
     * 后台编辑公告页面
     *
     * @throws Exception
     */
    public function edit(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('ann', (new Ann())->find($args['id']))
            ->assign('update_field', self::$update_field);
        return $response->write($view->fetch('admin/announcement/edit.tpl'));
    }

    /**
     * 后台编辑公告提交
     */
    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $status = (int) $request->getParam('status');
        $sort = (int) $request->getParam('sort');
        $content = $request->getParam('content');

        if ($content === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.announcement.messages.content_required', $this->user->locale),
            ]);
        }

        $ann = (new Ann())->find($args['id']);

        if ($ann === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.announcement.messages.not_found', $this->user->locale),
            ]);
        }

        $ann->status = in_array($status, [0, 1, 2]) ? $status : 1;
        $ann->sort = $sort > 999 || $sort < 0 ? 0 : $sort;
        $ann->content = $content;
        $ann->date = Tools::toDateTime(time());

        if (! $ann->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.announcement.messages.update_failed', $this->user->locale),
            ]);
        }

        if (Config::obtain('im_bot_group_notify_ann_update')) {
            $converter = new HtmlConverter(['strip_tags' => true]);
            $content = $converter->convert($ann->content);

            try {
                Notification::notifyUserGroup(I18n::trans('admin.announcement.messages.updated_notification', $this->user->locale) . PHP_EOL . $content);
            } catch (TelegramSDKException | GuzzleException) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans('admin.announcement.messages.updated_im_failed', $this->user->locale),
                ]);
            }
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.announcement.messages.updated', $this->user->locale),
        ]);
    }

    /**
     * 后台删除公告
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        if ((new Ann())->find($args['id'])->delete()) {
            return $response->withJson([
                'ret' => 1,
                'msg' => I18n::trans('admin.announcement.messages.deleted', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 0,
            'msg' => I18n::trans('admin.announcement.messages.delete_failed', $this->user->locale),
        ]);
    }

    /**
     * 后台公告页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $anns = (new Ann())->orderBy('id')->get();

        foreach ($anns as $ann) {
            $ann->op = '<button class="btn btn-red" id="delete-announcement-' . $ann->id . '" 
            onclick="deleteAnn(' . $ann->id . ')">' . I18n::trans('admin.announcement.actions.delete', $this->user->locale) . '</button>
            <a class="btn btn-primary" href="/admin/announcement/' . $ann->id . '/edit">' . I18n::trans('admin.announcement.actions.edit', $this->user->locale) . '</a>';
            $ann->status = I18n::trans('admin.announcement.status.' . $ann->status, $this->user->locale);
            $ann->content = strlen($ann->content) > 40 ? mb_substr(strip_tags($ann->content), 0, 40, 'UTF-8') . '...' : $ann->content;
        }

        return $response->withJson([
            'anns' => $anns,
        ]);
    }
}
