<!doctype html>
<html lang="{$user->locale}"
    data-bs-theme="{$user->is_dark_mode === 1 ? 'dark' : ($user->is_dark_mode === 2 ? 'auto' : 'light')}">

{include file="admin/header.tpl"}

<body {if $user->is_dark_mode === 1}data-bs-theme="dark" {elseif $user->is_dark_mode === 2}data-bs-theme="auto" {/if}>
    <div class="page">
        {include file='admin/body-prefix.tpl'}

        <div class="page-wrapper">
            <div class="container-xl">
                <div class="page-header d-print-none text-white">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">
                                <span class="home-title">{trans key='admin.order.order_number' id=$order->id}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.order.detail_title'}</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div class="btn-list">
                                <a href="/admin/user/{$order->user_id}/edit" targer="_blank" class="btn btn-primary">
                                    <i class="icon ti ti-user"></i>
                                    {trans key='admin.order.view_user'}
                                </a>
                                <a href="/admin/invoice/{$invoice->id}/view" targer="_blank" class="btn btn-primary">
                                    <i class="icon ti ti-file-dollar"></i>
                                    {trans key='admin.order.view_invoice'}
                                </a>
                                {if $order->status === 'pending_payment'}
                                    <button href="#" class="btn btn-red" data-bs-toggle="modal"
                                        data-bs-target="#cancel_order_confirm_dialog">
                                        <i class="icon ti ti-x"></i>
                                        {trans key='admin.order.cancel'}
                                    </button>
                                {/if}
                                {if $order->status === 'pending_activation'}
                                    <button href="#" class="btn btn-green" data-bs-toggle="modal"
                                        data-bs-target="#force_activate_order_confirm_dialog">
                                        <i class="icon ti ti-player-play"></i>
                                        {trans key='admin.order.force_activate'}
                                    </button>
                                {/if}
                                {if $order->status === 'pending_payment'}
                                    <button href="#" class="btn btn-green" data-bs-toggle="modal"
                                        data-bs-target="#mark_paid_order_confirm_dialog">
                                        <i class="icon ti ti-check"></i>
                                        {trans key='admin.order.mark_paid'}
                                    </button>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">{trans key='admin.order.basic_info'}</h3>
                        </div>
                        <div class="card-body">
                            <div class="datagrid">
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.submitting_user'}</div>
                                    <div class="datagrid-content">{$order->user_id}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.product_id'}</div>
                                    <div class="datagrid-content">{$order->product_id}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.product_type'}</div>
                                    <div class="datagrid-content">{$order->product_type_text}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.product_name'}</div>
                                    <div class="datagrid-content">{$order->product_name}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.coupon'}</div>
                                    <div class="datagrid-content">{$order->coupon}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.amount'}</div>
                                    <div class="datagrid-content">{$order->price}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.status'}</div>
                                    <div class="datagrid-content">{$order->status_text}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.created_at'}</div>
                                    <div class="datagrid-content">{$order->create_time}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.updated_at'}</div>
                                    <div class="datagrid-content">{$order->update_time}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card my-3">
                        <div class="card-header">
                            <h3 class="card-title">{trans key='admin.order.product_content'}</h3>
                        </div>
                        <div class="card-body">
                            <div class="datagrid">
                                {if $order->product_type === 'tabp' || $order->product_type === 'time'}
                                    <div class="datagrid-item">
                                        <div class="datagrid-title">{trans key='admin.order.product_duration_days'}</div>
                                        <div class="datagrid-content">{$order->content->time}</div>
                                    </div>
                                    <div class="datagrid-item">
                                        <div class="datagrid-title">{trans key='admin.order.class_duration_days'}</div>
                                        <div class="datagrid-content">{$order->content->class_time}</div>
                                    </div>
                                    <div class="datagrid-item">
                                        <div class="datagrid-title">{trans key='admin.order.class'}</div>
                                        <div class="datagrid-content">{$order->content->class}</div>
                                    </div>
                                {/if}
                                {if $order->product_type === 'tabp' || $order->product_type === 'bandwidth'}
                                    <div class="datagrid-item">
                                        <div class="datagrid-title">{trans key='admin.order.bandwidth_gb'}</div>
                                        <div class="datagrid-content">{$order->content->bandwidth}</div>
                                    </div>
                                {/if}
                                {if $order->product_type === 'tabp' || $order->product_type === 'time'}
                                    <div class="datagrid-item">
                                        <div class="datagrid-title">{trans key='admin.order.node_group'}</div>
                                        <div class="datagrid-content">{$order->content->node_group}</div>
                                    </div>
                                    <div class="datagrid-item">
                                        <div class="datagrid-title">{trans key='admin.order.speed_limit_mbps'}</div>
                                        <div class="datagrid-content">
                                            {if $order->content->ip_limit === '0'}
                                                {trans key='admin.order.unlimited'}
                                            {else}
                                                {$order->content->speed_limit}
                                            {/if}
                                        </div>
                                    </div>
                                    <div class="datagrid-item">
                                        <div class="datagrid-title">{trans key='admin.order.concurrent_ip_limit'}</div>
                                        <div class="datagrid-content">
                                            {if $order->content->ip_limit === '0'}
                                                {trans key='admin.order.unlimited'}
                                            {else}
                                                {$order->content->ip_limit}
                                            {/if}
                                        </div>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                    <div class="card my-3">
                        <div class="card-header">
                            <h3 class="card-title">{trans key='admin.order.related_invoice'}</h3>
                        </div>
                        <div class="card-body">
                            <div class="datagrid">
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.invoice_content'}</div>
                                    <div class="datagrid-content">
                                        <div class="table-responsive">
                                            <table id="invoice_content_table" class="table table-vcenter card-table">
                                                <thead>
                                                    <tr>
                                                        <th>{trans key='admin.order.name'}</th>
                                                        <th>{trans key='admin.order.price'}</th>
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
                                    <div class="datagrid-title">{trans key='admin.order.invoice_amount'}</div>
                                    <div class="datagrid-content">{$invoice->price}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.invoice_status'}</div>
                                    <div class="datagrid-content">{$invoice->status}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.created_at'}</div>
                                    <div class="datagrid-content">{$invoice->create_time}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.updated_at'}</div>
                                    <div class="datagrid-content">{$invoice->update_time}</div>
                                </div>
                                <div class="datagrid-item">
                                    <div class="datagrid-title">{trans key='admin.order.paid_at'}</div>
                                    <div class="datagrid-content">{$invoice->pay_time}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal modal-blur fade" id="cancel_order_confirm_dialog" tabindex="-1" role="dialog"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='admin.order.cancel'}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <p>
                                    {trans key='admin.order.confirm_cancel'}
                                <p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='admin.dialog.cancel'}</button>
                            <button id="confirm_cancel" type="button" class="btn btn-primary"
                                data-bs-dismiss="modal">{trans key='admin.dialog.confirm'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal modal-blur fade" id="force_activate_order_confirm_dialog" tabindex="-1" role="dialog"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='admin.order.force_activate_order'}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>{trans key='admin.order.confirm_activate'}</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='admin.dialog.cancel'}</button>
                            <button id="confirm_force_activate" type="button" class="btn btn-primary"
                                data-bs-dismiss="modal">{trans key='admin.dialog.confirm'}</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal modal-blur fade" id="mark_paid_order_confirm_dialog" tabindex="-1" role="dialog"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='admin.order.mark_paid_order'}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>{trans key='admin.order.confirm_mark_paid_detail'}</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='admin.dialog.cancel'}</button>
                            <button id="confirm_mark_paid" type="button" class="btn btn-primary"
                                data-bs-dismiss="modal">{trans key='admin.dialog.confirm'}</button>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                $("#confirm_cancel").click(function() {
                    $.ajax({
                        url: "/admin/order/{$order->id}/cancel",
                        type: 'POST',
                        dataType: "json",
                        success: function(data) {
                            if (data.ret === 1) {
                                $('#success-message').text(data.msg);
                                $('#success-dialog').modal('show');
                            } else {
                                $('#fail-message').text(data.msg);
                                $('#fail-dialog').modal('show');
                            }
                        }
                    })
                });

                $("#confirm_force_activate").click(function() {
                    $.ajax({
                        url: "/admin/order/{$order->id}/force_activate",
                        type: 'POST',
                        dataType: "json",
                        success: function(data) {
                            if (data.ret === 1) {
                                $('#success-message').text(data.msg);
                                $('#success-dialog').modal('show');
                            } else {
                                $('#fail-message').text(data.msg);
                                $('#fail-dialog').modal('show');
                            }
                        }
                    })
                });

                $("#confirm_mark_paid").click(function() {
                    $.ajax({
                        url: "/admin/order/{$order->id}/mark_paid",
                        type: 'POST',
                        dataType: "json",
                        success: function(data) {
                            if (data.ret === 1) {
                                $('#success-message').text(data.msg);
                                $('#success-dialog').modal('show');
                            } else {
                                $('#fail-message').text(data.msg);
                                $('#fail-dialog').modal('show');
                            }
                        }
                    })
                });
            </script>

            {include file='admin/footer.tpl'}
        </div>
    </div>

    {include file='admin/footer-scripts.tpl'}
</body>

</html>