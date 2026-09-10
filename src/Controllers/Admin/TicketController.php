<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Ticket;
use App\Models\User;
use App\Services\I18n;
use App\Services\LLM;
use App\Services\Notification;
use App\Utils\Env;
use App\Utils\ResponseHelper;
use App\Utils\Tools;
use GuzzleHttp\Exception\GuzzleException;
use Psr\Http\Client\ClientExceptionInterface;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use Smarty\Exception;
use Telegram\Bot\Exceptions\TelegramSDKException;
use function array_merge;
use function count;
use function json_decode;
use function json_encode;
use function nl2br;
use function time;

final class TicketController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.ticket.fields.operation',
            'id' => 'admin.ticket.fields.id',
            'title' => 'admin.ticket.fields.title',
            'status' => 'admin.ticket.fields.status',
            'type' => 'admin.ticket.fields.type',
            'userid' => 'admin.ticket.fields.user',
            'datetime' => 'admin.ticket.fields.created_at',
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
        return $response->write($view->fetch('admin/ticket/index.tpl'));
    }

    public function reply(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $comment = $request->getParam('comment') ?? '';

        if ($comment === '') {
            return ResponseHelper::error($response, I18n::trans('admin.ticket.messages.comment_required', $this->user->locale));
        }

        $ticket = (new Ticket())->where('id', $id)->first();

        if ($ticket === null) {
            return ResponseHelper::error($response, I18n::trans('admin.ticket.messages.not_found', $this->user->locale));
        }

        $content_old = json_decode($ticket->content, true);
        $content_new = [
            [
                'comment_id' => $content_old[count($content_old) - 1]['comment_id'] + 1,
                'commenter_type' => 'admin',
                'commenter_name' => 'Admin',
                'comment' => $comment,
                'datetime' => time(),
            ],
        ];

        $ticket->content = json_encode(array_merge($content_old, $content_new));
        $ticket->status = 'open_wait_user';
        $ticket->save();

        try {
            Notification::notifyUser(
                (new User())->find($ticket->userid),
                Env::get('appName') . ' - ' . I18n::trans('admin.ticket.notifications.replied_subject', $this->user->locale),
                I18n::trans('admin.ticket.notifications.replied_body', $this->user->locale, [
                    '%url%' => Env::get('baseUrl') . '/user/ticket/' . $ticket->id . '/view',
                ])
            );
        } catch (TelegramSDKException | GuzzleException | ClientExceptionInterface $e) {
            return $response->withHeader('HX-Refresh', 'true');
        }

        return $response->withHeader('HX-Refresh', 'true');
    }

    public function llmReply(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $ticket = (new Ticket())->where('id', $id)->first();

        if ($ticket === null) {
            return ResponseHelper::error($response, I18n::trans('admin.ticket.messages.not_found', $this->user->locale));
        }

        $content_old = json_decode($ticket->content, true);

        if (count($content_old) === 1) {
            $context = [
                [
                    'role' => 'user',
                    'content' => $ticket->title,
                ],
                [
                    'role' => 'user',
                    'content' => $content_old[0]['comment'],
                ],
            ];
        } else {
            $context = [
                [
                    'role' => 'user',
                    'content' => $ticket->title,
                ],
            ];

            foreach ($content_old as $comment) {
                $context[] = [
                    'role' => $comment['commenter_type'] ?? $comment['commenter_name'] === 'Admin' ? 'admin' : 'user',
                    'content' => $comment['comment'],
                ];
            }
        }

        $llm_response = LLM::genTextResponseWithContext($context);

        $content_new = [
            [
                'comment_id' => $content_old[count($content_old) - 1]['comment_id'] + 1,
                'commenter_type' => 'llm',
                'commenter_name' => 'AI Assistant',
                'comment' => $llm_response,
                'datetime' => time(),
            ],
        ];

        $ticket->content = json_encode(array_merge($content_old, $content_new));
        $ticket->status = 'open_wait_user';
        $ticket->save();

        try {
            Notification::notifyUser(
                (new User())->find($ticket->userid),
                Env::get('appName') . ' - ' . I18n::trans('admin.ticket.notifications.ai_replied_subject', $this->user->locale),
                I18n::trans('admin.ticket.notifications.ai_replied_body', $this->user->locale, [
                    '%url%' => Env::get('baseUrl') . '/user/ticket/' . $ticket->id . '/view',
                ])
            );
        } catch (TelegramSDKException | GuzzleException | ClientExceptionInterface $e) {
            return $response->withHeader('HX-Refresh', 'true');
        }

        return $response->withHeader('HX-Refresh', 'true');
    }

    /**
     * 后台查看指定工单
     *
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $ticket = (new Ticket())->where('id', '=', $id)->first();

        if ($ticket === null) {
            return $response->withRedirect('/admin/ticket');
        }

        $comments = json_decode($ticket->content);

        foreach ($comments as $comment) {
            $comment->comment = nl2br($comment->comment);
            $comment->datetime = Tools::toDateTime((int) $comment->datetime);
        }

        $view = $this->view();
        $view->assign('ticket', $ticket)
            ->assign('comments', $comments);
        return $response->write($view->fetch('admin/ticket/view.tpl'));
    }

    /**
     * 后台关闭工单
     */
    public function close(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $ticket = (new Ticket())->where('id', '=', $id)->first();

        if ($ticket === null) {
            return ResponseHelper::error($response, I18n::trans('admin.ticket.messages.not_found', $this->user->locale));
        }

        if ($ticket->status === 'closed') {
            return ResponseHelper::error($response, I18n::trans('admin.ticket.messages.already_closed', $this->user->locale));
        }

        $ticket->status = 'closed';
        $ticket->save();

        return ResponseHelper::success($response, I18n::trans('admin.ticket.messages.closed', $this->user->locale));
    }

    /**
     * 后台删除工单
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        (new Ticket())->where('id', '=', $id)->delete();

        return ResponseHelper::success($response, I18n::trans('admin.ticket.messages.deleted', $this->user->locale));
    }

    /**
     * 后台工单页面 Ajax
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $tickets = (new Ticket())->orderBy('id', 'desc')->get();

        foreach ($tickets as $ticket) {
            $ticket->op = '<button class="btn btn-red" id="delete-ticket" 
            onclick="deleteTicket(' . $ticket->id . ')">' . I18n::trans('admin.ticket.actions.delete', $this->user->locale) . '</button>';

            if ($ticket->status !== 'closed') {
                $ticket->op .= '
                <button class="btn btn-orange" id="close-ticket" 
                onclick="closeTicket(' . $ticket->id . ')">' . I18n::trans('admin.ticket.actions.close', $this->user->locale) . '</button>';
            }

            $ticket->op .= '
            <a class="btn btn-primary" href="/admin/ticket/' . $ticket->id . '/view">' . I18n::trans('admin.ticket.actions.view', $this->user->locale) . '</a>';
            $ticket->status = $ticket->status();
            $ticket->type = $ticket->type();
            $ticket->datetime = Tools::toDateTime((int) $ticket->datetime);
        }

        return $response->withJson([
            'tickets' => $tickets,
        ]);
    }
}
