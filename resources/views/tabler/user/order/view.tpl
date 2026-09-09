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
                                <span class="home-title">{trans key='shop.order_details_title' id=$order->id}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='shop.order_details_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div class="btn-list">
                                <a href="/user/invoice/{$invoice->id}/view" targer="_blank" class="btn btn-primary">
                                    <i class="icon ti ti-file-dollar"></i>
                                    {trans key='shop.view_invoice'}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">{trans key='shop.basic_information'}</h3>
                        </div>
                        <div class="card-body">
                            <div class="datagrid">
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.product_type'}</div>
                                    <div class="datagrid-content">{$order->product_type_text}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.product_name'}</div>
                                    <div class="datagrid-content">{$order->product_name}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.order_coupon'}</div>
                                    <div class="datagrid-content">{$order->coupon}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.order_amount'}</div>
                                    <div class="datagrid-content">{$order->price}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.status'}</div>
                                    <div class="datagrid-content">{$order->status}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.created_at'}</div>
                                    <div class="datagrid-content">{$order->create_time}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.updated_at'}</div>
                                    <div class="datagrid-content">{$order->update_time}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {if $order->type === 'topup'}
                        <div class="card my-3">
                            <div class="card-header">
                                <h3 class="card-title">{trans key='shop.product_contents'}</h3>
                            </div>
                            <div class="card-body">
                                <div class="datagrid">
                                    {if $order->product_type === 'tabp' || $order->product_type === 'time'}
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.product_duration_days'}</div>
                                            <div class="datagrid-content">{$order->content->time}</div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.level_duration_days'}</div>
                                            <div class="datagrid-content">{$order->content->class_time}</div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.level'}</div>
                                            <div class="datagrid-content">{$order->content->class}</div>
                                        </div>
                                    {/if}
                                    {if $order->product_type === 'tabp' || $order->product_type === 'bandwidth'}
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.traffic_gb'}</div>
                                            <div class="datagrid-content">{$order->content->bandwidth}</div>
                                        </div>
                                    {/if}
                                    {if $order->product_type === 'tabp' || $order->product_type === 'time'}
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.speed_limit_mbps'}</div>
                                            <div class="datagrid-content">
                                                {if $order->content->ip_limit === '0'}
                                                    {trans key='shop.unlimited'}
                                                {else}
                                                    {$order->content->speed_limit}
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="datagrid-item">
                                            <div class="datagrid-title">{trans key='shop.connection_ips'}</div>
                                            <div class="datagrid-content">
                                                {if $order->content->ip_limit === '0'}
                                                    {trans key='shop.unlimited'}
                                                {else}
                                                    {$order->content->ip_limit}
                                                {/if}
                                            </div>
                                        </div>
                                    {/if}
                                </div>
                            </div>
                        </div>
                    {/if}
                    <div class="card my-3">
                        <div class="card-header">
                            <h3 class="card-title">{trans key='shop.related_invoice'}</h3>
                        </div>
                        <div class="card-body">
                            <div class="datagrid">
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.invoice_contents'}</div>
                                    <div class="datagrid-content">
                                        <div class="table-responsive">
                                            <table id="invoice_content_table" class="table table-vcenter card-table">
                                                <thead>
                                                    <tr>
                                                        <th>{trans key='shop.name'}</th>
                                                        <th>{trans key='shop.price'}</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    {foreach $invoice->content as $invoice_content}
                                                        <tr>
                                                            <td>{$invoice_content->name}</td>
                                                            <td>{$invoice_content->price}</td>
                                                        </tr>
                                                    {/foreach}
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.invoice_amount'}</div>
                                    <div class="datagrid-content">{$invoice->price}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='shop.invoice_status'}</div>
                                    <div class="datagrid-content">{$invoice->status}</div>
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
                            </div>
                        </div>
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