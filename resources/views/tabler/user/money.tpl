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
                                <span class="home-title">{trans key='shop.balance_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='shop.balance_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div class="btn-list">
                                <a href="#" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#topup">
                                    <i class="icon ti ti-plus"></i>
                                    {trans key='shop.top_up'}
                                </a>
                                <a href="#" class="btn btn-primary" data-bs-toggle="modal"
                                    data-bs-target="#apply-giftcard-dialog">
                                    <i class="icon ti ti-cash-banknote"></i>
                                    {trans key='shop.gift_card'}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-sm-12 col-lg-12">
                            <div class="card">
                                <div class="table-responsive">
                                    <table class="table card-table table-vcenter text-nowrap datatable">
                                        <thead>
                                            <tr>
                                                <th>{trans key='shop.event_id'}</th>
                                                <th>{trans key='shop.balance_before'}</th>
                                                <th>{trans key='shop.balance_after'}</th>
                                                <th>{trans key='shop.amount_changed'}</th>
                                                <th>{trans key='shop.remark'}</th>
                                                <th>{trans key='shop.changed_at'}</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach $moneylogs as $moneylog}
                                                <tr>
                                                    <td>{$moneylog->id}</td>
                                                    <td>{$moneylog->before}</td>
                                                    <td>{$moneylog->after}</td>
                                                    <td>{$moneylog->amount}</td>
                                                    <td>{$moneylog->remark}</td>
                                                    <td>{$moneylog->create_time}</td>
                                                </tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal modal-blur fade" id="apply-giftcard-dialog" tabindex="-1" role="dialog"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='shop.gift_card'}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group mb-3 row">
                                <div class="col">
                                    <input id="giftcard" type="text" class="form-control"
                                        placeholder="{trans key='shop.gift_card_placeholder'}">
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='shop.cancel'}</button>
                            <button id="apply-giftcard" class="btn btn-primary" data-bs-dismiss="modal"
                                hx-post="/user/giftcard" hx-swap="none"
                                hx-vals='js:{ giftcard: document.getElementById("giftcard").value }'>
                                {trans key='shop.redeem'}
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal modal-blur fade" id="topup" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='shop.top_up'}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group mb-3 row">
                                <div class="col">
                                    <input id="topup_amount" type="number" step="10" class="form-control"
                                        placeholder="{trans key='shop.top_up_amount'}">
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='shop.cancel'}</button>
                            <button id="apply-topup" class="btn btn-primary" data-bs-dismiss="modal"
                                hx-post="/user/order/create" hx-swap="none" hx-vals='js:{
                                amount: document.getElementById("topup_amount").value,
                                type: "topup"
                            }'>
                                {trans key='shop.top_up_action'}
                            </button>
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