<!doctype html>
<html lang="{$user->locale}"
    data-bs-theme="{$user->is_dark_mode === 1 ? 'dark' : ($user->is_dark_mode === 2 ? 'auto' : 'light')}">

{include file='user/header.tpl'}

<body {if $user->is_dark_mode === 1}data-bs-theme="dark" {elseif $user->is_dark_mode === 2}data-bs-theme="auto" {/if}>
    <div class="page">
        {include file='user/body-prefix.tpl'}

        <div class="page-wrapper">
            <div class="container-xl">
                <div class="page-header d-print-none text-white">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">
                                <span class="home-title my-3">{trans key='shop.invoice_title' id=$invoice->id}</span>
                            </h2>
                            <div class="page-pretitle">
                                <span class="home-subtitle">{trans key='shop.invoice_details_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-cards">
                        <div
                            class="col-md-12 {if $invoice->status === 'unpaid' || $invoice->status === 'partially_paid'}col-md-6 col-lg-9{/if}">

                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">{trans key='shop.basic_information'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="datagrid">
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.order_id'}</div>
                                            <div class="datagrid-content">{$invoice->order_id}</div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.order_amount'}</div>
                                            <div class="datagrid-content">{$invoice->price}</div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.invoice_status'}</div>
                                            <div class="datagrid-content">{$invoice->status_text}</div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.created_at'}</div>
                                            <div class="datagrid-content">{$invoice->create_time}</div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.updated_at'}</div>
                                            <div class="datagrid-content">{$invoice->update_time}</div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.payment_time'}</div>
                                            <div class="datagrid-content">{$invoice->pay_time}</div>
                                        </div>
                                        {if $invoice->status === 'paid_gateway'}
                                            <div class="datagrid-item">
                                                <div class="datagrid-title">{trans key='shop.payment_gateway_number'}</div>
                                                <div class="datagrid-content">{$paylist->tradeno}</div>
                                            </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                            <div class="card my-3">
                                <div class="card-header">
                                    <h3 class="card-title">{trans key='shop.invoice_details_subtitle'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table id="invoice_content_table" class="table table-vcenter card-table">
                                            <thead>
                                                <tr>
                                                    <th>{trans key='shop.name'}</th>
                                                    <th>{trans key='shop.price'}</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach $invoice_content as $invoice_content_detail}
                                                    <tr>
                                                        <td>{$invoice_content_detail->name}</td>
                                                        <td>{$invoice_content_detail->price}</td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {if $invoice->status === 'unpaid' || $invoice->status === 'partially_paid'}
                            <div class="col-sm-12 col-md-6 col-lg-3">
                                <div class="card">
                                    <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs">
                                        {if $invoice->type !== 'topup'}
                                            <li class="nav-item">
                                                <a href="#balance" class="nav-link active" data-bs-toggle="tab">
                                                    <i class="ti ti-coins icon"></i>
                                                    &nbsp;{trans key='shop.balance_payment'}
                                                </a>
                                            </li>
                                        {/if}
                                        {if count($payments) > 0}
                                            <li class="nav-item">
                                                <a href="#gateway" class="nav-link" data-bs-toggle="tab">
                                                    <i class="ti ti-coin icon"></i>
                                                    &nbsp;{trans key='shop.gateway_payment'}
                                                </a>
                                            </li>
                                        {/if}
                                    </ul>
                                    <div class="card-body">
                                        <div class="tab-content">
                                            {if $invoice->type !== 'topup'}
                                                <div class="tab-pane active show" id="balance">
                                                    <div class="mb-3">
                                                        {trans key='shop.available_balance' balance=$user->money}
                                                    </div>
                                                    <div class="d-flex">
                                                        <button class="btn btn-primary" type="button"
                                                            hx-post="/user/invoice/pay_balance" hx-swap="none" hx-vals='js:{
                                                    invoice_id: {$invoice->id},
                                                }'>
                                                            {trans key='shop.pay'}
                                                        </button>
                                                    </div>
                                                </div>
                                            {/if}
                                            {if count($payments) > 0}
                                                <div class="tab-pane show" id="gateway">
                                                    {foreach from=$payments item=payment}
                                                        <div class="mb-3">
                                                            {$payment_name = $payment::_name()}
                                                            {include file="../../gateway/$payment_name.tpl"}
                                                        </div>
                                                    {/foreach}
                                                </div>
                                            {/if}
                                            {if $invoice->type === 'topup' && count($payments) === 0}
                                                {trans key='shop.no_payment_methods'}
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>

            {include file='user/footer.tpl'}
        </div>
    </div>

    {include file="user/footer-scripts.tpl"}

    {include file='live_chat.tpl'}

</body>

</html>