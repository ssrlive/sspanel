<?php

declare(strict_types=1);

namespace App\Controllers\Admin;

use App\Controllers\BaseController;
use App\Models\Invoice;
use App\Models\Order;
use App\Models\Paylist;
use App\Services\I18n;
use App\Utils\Tools;
use Exception;
use Psr\Http\Message\ResponseInterface;
use Slim\Http\Response;
use Slim\Http\ServerRequest;
use function in_array;
use function json_decode;
use function time;

final class InvoiceController extends BaseController
{
    private static array $details = [
        'field' => [
            'op' => 'admin.invoice.operation',
            'id' => 'admin.invoice.invoice_id',
            'user_id' => 'admin.invoice.submitting_user',
            'order_id' => 'admin.invoice.related_order_id',
            'price' => 'admin.invoice.amount',
            'status' => 'admin.invoice.status',
            'create_time' => 'admin.invoice.created_at',
            'update_time' => 'admin.invoice.updated_at',
            'pay_time' => 'admin.invoice.paid_at',
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
        return $response->write($view->fetch('admin/invoice/index.tpl'));
    }

    /**
     * @throws Exception
     */
    public function detail(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $id = $args['id'];
        $invoice = (new Invoice())->find($id);
        $paylist = [];

        if ($invoice->status === 'paid_gateway') {
            $paylist = (new Paylist())->where('invoice_id', $invoice->id)->where('status', 1)->first();
        }

        $invoice->status_text = $this->translateStatus($invoice->status);
        $invoice->create_time = Tools::toDateTime($invoice->create_time);
        $invoice->update_time = Tools::toDateTime($invoice->update_time);
        $invoice->pay_time = $invoice->pay_time === 0 ? I18n::trans('admin.invoice.unpaid', $this->user->locale) : Tools::toDateTime($invoice->pay_time);
        $invoice_content = json_decode($invoice->content);

        $view = $this->view();
        $view->assign('invoice', $invoice)
            ->assign('invoice_content', $invoice_content)
            ->assign('paylist', $paylist);
        return $response->write($view->fetch('admin/invoice/view.tpl'));
    }

    public function markPaid(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $invoice_id = $args['id'];
        $invoice = (new Invoice())->find($invoice_id);

        if (in_array($invoice->status, ['paid_gateway', 'paid_balance', 'paid_admin'])) {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.invoice.messages.already_paid', $this->user->locale),
            ]);
        }

        $order = (new Order())->find($invoice->order_id);

        if ($order->status === 'cancelled') {
            return $response->withJson([
                'ret' => 0,
                'msg' => I18n::trans('admin.invoice.messages.order_cancelled', $this->user->locale),
            ]);
        }

        $order->update_time = time();
        $order->status = 'pending_activation';
        $order->save();

        $invoice->update_time = time();
        $invoice->pay_time = time();
        $invoice->status = 'paid_admin';
        $invoice->save();

        return $response->withJson([
            'ret' => 1,
            'msg' => I18n::trans('admin.invoice.messages.marked_paid', $this->user->locale),
        ]);
    }

    public function ajax(ServerRequest $request, Response $response, array $args): ResponseInterface
    {
        $invoices = (new Invoice())->orderBy('id', 'desc')->get();

        foreach ($invoices as $invoice) {
            $invoice->op = '<a class="btn btn-primary" href="/admin/invoice/' . $invoice->id . '/view">'
                . I18n::trans('admin.invoice.view', $this->user->locale) . '</a>';
            $invoice->status = $this->translateStatus($invoice->status);
            $invoice->create_time = Tools::toDateTime($invoice->create_time);
            $invoice->update_time = Tools::toDateTime($invoice->update_time);
            $invoice->pay_time = $invoice->pay_time === 0 ? I18n::trans('admin.invoice.unpaid', $this->user->locale) : Tools::toDateTime($invoice->pay_time);
        }

        return $response->withJson([
            'invoices' => $invoices,
        ]);
    }

    private function translateStatus(string $status): string
    {
        return I18n::trans('admin.invoice.statuses.' . $status, $this->user->locale);
    }
}
