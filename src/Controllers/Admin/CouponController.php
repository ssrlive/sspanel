<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\UserCoupon;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function in_array;
use function json_decode;
use function json_encode;
use function property_exists;
use function time;

final class CouponController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.coupon.fields.operation',
            'id' => 'admin.coupon.fields.id',
            'code' => 'admin.coupon.fields.code',
            'type' => 'admin.coupon.fields.type',
            'value' => 'admin.coupon.fields.value',
            'product_id' => 'admin.coupon.fields.product_id',
            'use_time' => 'admin.coupon.fields.use_time',
            'total_use_time' => 'admin.coupon.fields.total_use_time',
            'new_user' => 'admin.coupon.fields.new_user',
            'disabled' => 'admin.coupon.fields.disabled',
            'use_count' => 'admin.coupon.fields.use_count',
            'create_time' => 'admin.coupon.fields.created_at',
            'expire_time' => 'admin.coupon.fields.expires_at',
        ],
        'create_dialog' => [
            [
                'id' => 'code',
                'info' => 'admin.coupon.fields.code',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'type',
                'info' => 'admin.coupon.fields.type',
                'type' => 'select',
                'select' => [
                    'percentage' => 'admin.coupon.types.percentage',
                    'fixed' => 'admin.coupon.types.fixed',
                ],
            ],
            [
                'id' => 'value',
                'info' => 'admin.coupon.fields.value',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'product_id',
                'info' => 'admin.coupon.fields.product_id_help',
                'type' => 'input',
                'placeholder' => '',
            ],
            [
                'id' => 'use_time',
                'info' => 'admin.coupon.fields.use_time_help',
                'type' => 'input',
                'placeholder' => '-1',
            ],
            [
                'id' => 'total_use_time',
                'info' => 'admin.coupon.fields.total_use_time_help',
                'type' => 'input',
                'placeholder' => '-1',
            ],
            [
                'id' => 'new_user',
                'info' => 'admin.coupon.fields.new_user',
                'type' => 'select',
                'select' => [
                    '1' => 'admin.coupon.options.enabled',
                    '0' => 'admin.coupon.options.disabled',
                ],
            ],
            [
                'id' => 'generate_method',
                'info' => 'admin.coupon.fields.generate_method',
                'type' => 'select',
                'select' => [
                    'char' => 'admin.coupon.generate.char',
                    'random' => 'admin.coupon.generate.random',
                    'char_random' => 'admin.coupon.generate.char_random',
                ],
            ],
        ],
    ];

    /**
     * 后台优惠码页面
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
        foreach ($details['create_dialog'] as &$detail) {
            $detail['info'] = I18n::trans($detail['info'], $this->user->locale);
            if (isset($detail['select'])) {
                foreach ($detail['select'] as $key => $value) {
                    $detail['select'][$key] = I18n::trans($value, $this->user->locale);
                }
            }
        }
        unset($detail);
        $view->assign('details', $details);
        return $response->write($view->fetch('admin/coupon.tpl'));
    }

    /**
     * 添加优惠码
     */
    public function add(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $code = $request->getParam('code');
        $type = $request->getParam('type');
        $value = $request->getParam('value');
        $product_id = $request->getParam('product_id');
        $use_time = $request->getParam('use_time');
        $total_use_time = $request->getParam('total_use_time');
        $new_user = $request->getParam('new_user');
        $generate_method = $request->getParam('generate_method');
        $expire_time = $request->getParam('expire_time');

        if ($code === '' && in_array($generate_method, ['char', 'char_ramdom'])) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.coupon.messages.code_required', $this->user->locale),
            ]);
        }

        if ($type === '' || $value === '' || ($expire_time !== '' && $expire_time < time())) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.coupon.messages.invalid', $this->user->locale),
            ]);
        }

        if ($generate_method === 'char' && (new UserCoupon())->where('code', $code)->count() !== 0) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.coupon.messages.exists', $this->user->locale),
            ]);
        }

        if ($generate_method === 'char_random') {
            $code .= Tools::genRandomChar();

            if ((new UserCoupon())->where('code', $code)->count() !== 0) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans('admin.coupon.messages.retry', $this->user->locale),
                ]);
            }
        }

        if ($generate_method === 'random') {
            $code = Tools::genRandomChar();

            if ((new UserCoupon())->where('code', $code)->count() !== 0) {
                return $response->withJson([
                    'ret' => 0,
                    'msg' => I18n::trans('admin.coupon.messages.retry', $this->user->locale),
                ]);
            }
        }

        $content = [
            'type' => $type,
            'value' => $value,
        ];

        $limit = [
            'product_id' => $product_id,
            'use_time' => $use_time,
            'total_use_time' => $total_use_time,
            'new_user' => $new_user,
            'disabled' => 0,
        ];

        $coupon = new UserCoupon();
        $coupon->code = $code;
        $coupon->content = json_encode($content);
        $coupon->limit = json_encode($limit);
        $coupon->create_time = time();

        if ($expire_time !== '') {
            $coupon->expire_time = $expire_time;
        } else {
            $coupon->expire_time = 0;
        }

        $coupon->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.coupon.messages.created', $this->user->locale, ['%code%' => $code]),
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $coupon_id = $args['id'];
        (new UserCoupon())->find($coupon_id)->delete();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.coupon.messages.deleted', $this->user->locale),
        ]);
    }

    public function disable(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $coupon_id = $args['id'];
        $coupon = (new UserCoupon())->find($coupon_id)->first();
        $limit = json_decode($coupon->limit);
        $limit->disabled = 1;
        $coupon->limit = json_encode($limit);
        $coupon->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.coupon.messages.disabled', $this->user->locale),
        ]);
    }

    /**
     * 后台商品优惠码页面 AJAX
     */
    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $coupons = (new UserCoupon())->orderBy('id', 'desc')->get();

        foreach ($coupons as $coupon) {
            $content = json_decode($coupon->content);
            $limit = json_decode($coupon->limit);

            $coupon->op = '<button class="btn btn-red" id="delete-coupon-' . $coupon->id . '"
                onclick="deleteCoupon(' . $coupon->id . ')">' . I18n::trans('admin.coupon.actions.delete', $this->user->locale) . '</button>' .
                ($limit->disabled !== 1 ? '
                <button class="btn btn-orange" id="disable-coupon-' .
                    $coupon->id . '" onclick="disableCoupon(' . $coupon->id . ')">' . I18n::trans('admin.coupon.actions.disable', $this->user->locale) . '</button>' : '');

            $coupon->type = $coupon->type();
            $coupon->value = $content->value;
            $coupon->product_id = $limit->product_id;
            $coupon->use_time = (int) $limit->use_time < 0 ? I18n::trans('admin.coupon.unlimited', $this->user->locale) : $limit->use_time;
            $coupon->total_use_time = ! property_exists($limit, 'total_use_time') ||
                (int) $limit->total_use_time < 0 ? I18n::trans('admin.coupon.unlimited', $this->user->locale) : $limit->total_use_time;
            $coupon->new_user = $limit->new_user === 1 ? I18n::trans('admin.coupon.yes', $this->user->locale) : I18n::trans('admin.coupon.no', $this->user->locale);
            $coupon->disabled = $limit->disabled === 1 ? I18n::trans('admin.coupon.yes', $this->user->locale) : I18n::trans('admin.coupon.no', $this->user->locale);
            $coupon->create_time = Tools::toDateTime((int) $coupon->create_time);
            $coupon->expire_time = $coupon->expire_time === 0 ? I18n::trans('admin.coupon.permanent', $this->user->locale) : Tools::toDateTime((int) $coupon->expire_time);
        }

        return $response->withJson([
            'coupons' => $coupons,
        ]);
    }
}
