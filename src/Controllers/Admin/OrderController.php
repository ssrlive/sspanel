<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Invoice;
use App\Models\Order;
use App\Services\Cron;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function in_array;
use function json_decode;
use function time;

final class OrderController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'operation',
            'id' => 'order_id',
            'user_id' => 'submitting_user',
            'product_id' => 'product_id',
            'product_type' => 'product_type',
            'product_name' => 'product_name',
            'coupon' => 'coupon',
            'price' => 'amount',
            'status' => 'status',
            'create_time' => 'created_at',
            'update_time' => 'updated_at',
        ],
    ];

    /**
     * @throws Exception
     */
    public function index(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $view = $this->view();
        $details = self::$details;
        foreach ($details['field'] as $key => $translationKey) {
            $details['field'][$key] = I18n::trans('admin.order.' . $translationKey, $this->user->locale);
        }
        $view->assign('details', $details);
        return $response->write($view->fetch('admin/order/index.tpl'));
    }

    /**
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $order = (new Order())->find($id);

        if ($order === null) {
            return $response->withStatus(301)->withHeader('Location', '/admin/order');
        }

        $order->product_type_text = $order->productType();
        $order->status_text = $order->status();
        $order->create_time = Tools::toDateTime($order->create_time);
        $order->update_time = Tools::toDateTime($order->update_time);
        $order->content = json_decode($order->product_content);

        $invoice = (new Invoice())->where('order_id', $id)->first();
        $invoice->status = $invoice->status();
        $invoice->create_time = Tools::toDateTime($invoice->create_time);
        $invoice->update_time = Tools::toDateTime($invoice->update_time);
        $invoice->pay_time = Tools::toDateTime($invoice->pay_time);
        $invoice->content = json_decode($invoice->content);

        $view = $this->view();
        $view->assign('order', $order)
            ->assign('invoice', $invoice);
        return $response->write($view->fetch('admin/order/view.tpl'));
    }

    public function cancel(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $order_id = $args['id'];
        $order = (new Order())->find($order_id);

        if ($order === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.not_found', $this->user->locale),
            ]);
        }

        if (in_array($order->status, ['activated', 'expired', 'cancelled'])) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.cancel_invalid_status', $this->user->locale, ['status' => $order->status()]),
            ]);
        }

        $invoice = (new Invoice())->where('order_id', $order_id)->first();

        if ($invoice === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.invoice_not_found', $this->user->locale),
            ]);
        }

        if ($invoice->status === 'partially_paid') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.partially_paid', $this->user->locale),
            ]);
        }

        $order->update_time = time();
        $order->status = 'cancelled';
        $order->save();

        if (in_array($invoice->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
            $invoice->refundToBalance();

            return $response->withJson([
                'ret' => 1,
                'msg' => I18n::trans('admin.order.messages.cancelled_refunded', $this->user->locale),
            ]);
        }

        $invoice->update_time = time();
        $invoice->status = 'cancelled';
        $invoice->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.order.messages.cancelled', $this->user->locale),
        ]);
    }

    /**
     * Force activation of a paid order, replacing the current TABP order if needed.
     */
    public function forceActivate(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $order = (new Order())->find($args['id']);

        if ($order === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.not_found', $this->user->locale),
            ]);
        }

        if ($order->status !== 'pending_activation') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.not_pending_activation', $this->user->locale),
            ]);
        }

        if (! Cron::activateOrder($order, true, true)) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.force_activate_failed', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.order.messages.force_activated', $this->user->locale),
        ]);
    }

    public function markPaid(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $order = (new Order())->find($args['id']);

        if ($order === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.not_found', $this->user->locale),
            ]);
        }

        if (! in_array($order->status, ['pending_payment', 'pending_activation'])) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.not_unpaid', $this->user->locale),
            ]);
        }

        $invoice = (new Invoice())->where('order_id', $order->id)->first();
        if ($invoice === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.invoice_not_found', $this->user->locale),
            ]);
        }

        if (in_array($invoice->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.invoice_paid', $this->user->locale),
            ]);
        }

        $now = time();
        $order->status = 'pending_activation';
        $order->update_time = $now;
        $order->save();
        $invoice->status = 'paid_admin';
        $invoice->update_time = $now;
        $invoice->pay_time = $now;
        $invoice->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.order.messages.marked_paid', $this->user->locale),
        ]);
    }

    public function delete(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $order_id = $args['id'];
        $order = (new Order())->find($order_id);

        if ($order === null) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.order.messages.not_found', $this->user->locale),
            ]);
        }

        $invoice = (new Invoice())->where('order_id', $order_id)->first();

        if ($order->delete() && $invoice->delete()) {
            return $response->withJson([
                'ret' => 1,
                'msg' => I18n::trans('admin.order.messages.deleted', $this->user->locale),
            ]);
        }

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.order.messages.delete_failed', $this->user->locale),
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $orders = (new Order())->orderBy('id', 'desc')->get();

        foreach ($orders as $order) {
            $order->op = '<button class="btn btn-red" id="delete-order-' . $order->id . '"
             onclick="deleteOrder(' . $order->id . ')">' . I18n::trans('admin.order.delete', $this->user->locale) . '</button>';

            if (in_array($order->status, ['pending_payment', 'pending_activation'])) {
                $order->op .= '
                <button class="btn btn-orange" id="cancel-order-' . $order->id . '"
                 onclick="cancelOrder(' . $order->id . ')">' . I18n::trans('admin.order.cancel', $this->user->locale) . '</button>';
            }

            if ($order->status === 'pending_payment') {
                $order->op .= '
                <button class="btn btn-green" id="mark-paid-order-' . $order->id . '"
                 onclick="markPaidOrder(' . $order->id . ')">' . I18n::trans('admin.order.mark_paid', $this->user->locale) . '</button>';
            }

            if ($order->status === 'pending_activation') {
                $order->op .= '
                <button class="btn btn-green" id="force-activate-order-' . $order->id . '"
                 onclick="forceActivateOrder(' . $order->id . ')">' . I18n::trans('admin.order.force_activate', $this->user->locale) . '</button>';
            }

            $order->op .= '
            <a class="btn btn-primary" href="/admin/order/' . $order->id . '/view">' . I18n::trans('admin.order.view', $this->user->locale) . '</a>';
            $order->product_type = match ($order->product_type) {
                'tabp' => I18n::trans('admin.product.type_labels.tabp', $this->user->locale),
                'time' => I18n::trans('admin.product.type_labels.time', $this->user->locale),
                'bandwidth' => I18n::trans('admin.product.type_labels.bandwidth', $this->user->locale),
                'topup' => I18n::trans('admin.product.type_labels.topup', $this->user->locale),
                default => I18n::trans('admin.product.type_labels.other', $this->user->locale),
            };
            $order->status = I18n::trans('user_pages.order_status_' . (in_array($order->status, ['pending_payment', 'pending_activation', 'activated', 'expired', 'cancelled'], true) ? $order->status : 'unknown'), $this->user->locale);
            $order->create_time = Tools::toDateTime($order->create_time);
            $order->update_time = Tools::toDateTime($order->update_time);
        }

        return $response->withJson([
            'orders' => $orders,
        ]);
    }
}
