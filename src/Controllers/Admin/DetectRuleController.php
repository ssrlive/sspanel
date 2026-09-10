<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\DetectRule;
use App\Services\I18n;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;

final class DetectRuleController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.detect.fields.operation',
            'id' => 'admin.detect.fields.id',
            'name' => 'admin.detect.fields.name',
            'text' => 'admin.detect.fields.description',
            'regex' => 'admin.detect.fields.regex',
            'type' => 'admin.detect.fields.type',
        ],
        'add_dialog' => [
            [
                'id' => 'name',
                'info' => 'admin.detect.fields.name',
                'type' => 'input',
                'placeholder' => 'admin.detect.placeholders.name',
            ],
            [
                'id' => 'text',
                'info' => 'admin.detect.fields.description',
                'type' => 'input',
                'placeholder' => 'admin.detect.placeholders.description',
            ],
            [
                'id' => 'regex',
                'info' => 'admin.detect.fields.regex',
                'type' => 'input',
                'placeholder' => 'admin.detect.placeholders.regex',
            ],
            [
                'id' => 'type',
                'info' => 'admin.detect.fields.type',
                'type' => 'select',
                'select' => [
                    '1' => 'admin.detect.types.plaintext',
                    '0' => 'admin.detect.types.hex',
                ],
            ],
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
        foreach ($details['add_dialog'] as &$detail) {
            $detail['info'] = I18n::trans($detail['info'], $this->user->locale);
            if (isset($detail['placeholder'])) {
                $detail['placeholder'] = I18n::trans($detail['placeholder'], $this->user->locale);
            }
            if (isset($detail['select'])) {
                foreach ($detail['select'] as $key => $value) {
                    $detail['select'][$key] = I18n::trans($value, $this->user->locale);
                }
            }
        }
        unset($detail);
        $view->assign('details', $details);
        return $response->write($view->fetch('admin/detect.tpl'));
    }

    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $rule = new DetectRule();
        $rule->name = $request->getParam('name');
        $rule->text = $request->getParam('text');
        $rule->regex = $request->getParam('regex');
        $rule->type = $request->getParam('type');

        if (! $rule->save()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.detect.messages.create_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.detect.messages.created', $this->user->locale),
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $rule = (new DetectRule())->find($id);

        if (! $rule->delete()) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.detect.messages.delete_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.detect.messages.deleted', $this->user->locale),
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $rules = (new DetectRule())->orderBy('id', 'desc')->get();

        foreach ($rules as $rule) {
            $rule->op = '<button class="btn btn-red" id="delete-rule-' . $rule->id .
                '" onclick="deleteRule(' . $rule->id . ')">' . I18n::trans('admin.detect.actions.delete', $this->user->locale) . '</button>';
            $rule->type = $rule->type();
        }

        return $response->withJson([
            'rules' => $rules,
        ]);
    }
}
