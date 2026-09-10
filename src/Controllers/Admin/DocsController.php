<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Docs;
use App\Services\I18n;
use App\Services\LLM;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function time;

final class DocsController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.docs.fields.operation',
            'id' => 'admin.docs.fields.id',
            'status' => 'admin.docs.fields.status',
            'sort' => 'admin.docs.fields.sort',
            'date' => 'admin.docs.fields.date',
            'title' => 'admin.docs.fields.title',
        ],
    ];

    private static array $update_field = [
        'status',
        'sort',
        'title',
    ];

    /**
     * 后台文档页面
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
        return $response->write($view->fetch('admin/docs/index.tpl'));
    }

    /**
     * 后台文档创建页面
     *
     * @throws Exception
     */
    public function create(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $view->assign('update_field', self::$update_field);
        return $response->write($view->fetch('admin/docs/create.tpl'));
    }

    /**
     * 后台添加文档
     */
    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $status = (int) $request->getParam('status');
        $sort = (int) $request->getParam('sort');
        $title = $request->getParam('title');
        $content = $request->getParam('content');

        if ($title === '' || $content === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.docs.messages.content_required', $this->user->locale),
            ]);
        }

        $doc = new Docs();
        $doc->status = in_array($status, [0, 1]) ? $status : 1;
        $doc->sort = $sort > 999 || $sort < 0 ? 0 : $sort;
        $doc->date = Tools::toDateTime(time());
        $doc->title = $title;
        $doc->content = $content;

        if (! $doc->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.docs.messages.create_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.docs.messages.created', $this->user->locale),
        ]);
    }

    /**
     * 使用LLM生成文档
     *
     * @param ServerRequest $request
     * @param Response $response
     * @param array $args
     *
     * @return ResponseInterface
     */
    public function generate(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $content = LLM::genTextResponse($request->getParam('question'));

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.docs.messages.generated', $this->user->locale),
            'content' => $content,
        ]);
    }

    /**
     * 文档编辑页面
     *
     * @throws Exception
     */
    public function edit(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $doc = (new Docs())->find($args['id']);

        $view = $this->view();
        $view->assign('doc', $doc)
            ->assign('update_field', self::$update_field);
        return $response->write($view->fetch('admin/docs/edit.tpl'));
    }

    /**
     * 后台编辑文档提交
     */
    public function update(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $status = (int) $request->getParam('status');
        $sort = (int) $request->getParam('sort');
        $title = $request->getParam('title');
        $content = $request->getParam('content');

        if ($title === '' || $content === '') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.docs.messages.content_required', $this->user->locale),
            ]);
        }

        $doc = (new Docs())->find($args['id']);

        if ($doc === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.docs.messages.not_found', $this->user->locale),
            ]);
        }

        $doc->status = in_array($status, [0, 1]) ? $status : 1;
        $doc->sort = $sort > 999 || $sort < 0 ? 0 : $sort;
        $doc->title = $request->getParam('title');
        $doc->content = $request->getParam('content');
        $doc->date = Tools::toDateTime(time());

        if (! $doc->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.docs.messages.update_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.docs.messages.updated', $this->user->locale),
        ]);
    }

    /**
     * 后台删除文档
     */
    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $doc = (new Docs())->find($args['id']);

        if (! $doc->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.docs.messages.delete_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.docs.messages.deleted', $this->user->locale),
        ]);
    }

    /**
     * 后台文档页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $docs = (new Docs())->orderBy('id')->get();

        foreach ($docs as $doc) {
            $doc->op = '<button class="btn btn-red" id="delete-doc-' . $doc->id . '" 
            onclick="deleteDoc(' . $doc->id . ')">' . I18n::trans('admin.docs.actions.delete', $this->user->locale) . '</button>
            <a class="btn btn-primary" href="/admin/docs/' . $doc->id . '/edit">' . I18n::trans('admin.docs.actions.edit', $this->user->locale) . '</a>';
            $doc->status = I18n::trans('admin.docs.status.' . $doc->status, $this->user->locale);
        }

        return $response->withJson([
            'docs' => $docs,
        ]);
    }
}
