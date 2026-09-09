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
                                <span class="home-title my-3">{trans key='shop.tickets_title'}</span>
                            </h2>
                            <div class="page-pretitle">
                                <span class="home-subtitle">{trans key='shop.tickets_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div class="btn-list">
                                <button href="#" class="btn btn-primary" data-bs-toggle="modal"
                                    data-bs-target="#create-ticket">
                                    <i class="icon ti ti-plus"></i>
                                    {trans key='shop.create_ticket'}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-12">
                            <div class="row row-cards row-deck">
                                {if $tickets !== 0}
                                    {foreach $tickets as $ticket}
                                        <div class="col-md-4 col-sm-12">
                                            <div class="card">
                                                <div class="card-body">
                                                    <div class="card-stamp">
                                                        {if $ticket->status !== 'closed'}
                                                            <div class="card-stamp-icon bg-yellow">
                                                                <i class="ti ti-clock"></i>
                                                            </div>
                                                        {else}
                                                            <div class="card-stamp-icon bg-green">
                                                                <i class="ti ti-check"></i>
                                                            </div>
                                                        {/if}
                                                    </div>
                                                    <h3 class="card-title" style="font-size: 20px;">
                                                        #{$ticket->id}
                                                    </h3>
                                                    <p class="text-secondary text-truncate" style="height: 100px;">
                                                        {$ticket->title}
                                                    </p>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="d-flex align-items-center">
                                                        <span class="status status-grey">{$ticket->status_text}</span>
                                                        <span class="status status-grey ms-2">{$ticket->type_text}</span>
                                                        <div class="ms-auto">
                                                            {if $ticket->raw_status !== 'closed'}
                                                                <button class="btn btn-danger btn-sm me-2"
                                                                    hx-post="/user/ticket/{$ticket->id}/close" hx-swap="none"
                                                                    onclick="return confirm('{trans key='shop.close_ticket_confirm' js=true}');">
                                                                    {trans key='shop.close'}
                                                                </button>
                                                            {/if}
                                                            <a href="/user/ticket/{$ticket->id}/view"
                                                                class="btn btn-primary btn-sm">
                                                                {trans key='shop.view'}
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    {/foreach}
                                {else}
                                    <div class="card">
                                        <div class="card-header">
                                            <h3 class="card-title">{trans key='shop.no_tickets'}</h3>
                                        </div>
                                        <div class="card-body">{trans key='shop.no_tickets_help'}</div>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal modal-blur fade" id="create-ticket" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='shop.create_ticket'}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <select id="ticket-type" class="form-select">
                                    <option value="0">{trans key='shop.ticket_type_placeholder'}</option>
                                    <option value="howto">{trans key='shop.ticket_type_howto'}</option>
                                    <option value="billing">{trans key='shop.ticket_type_billing'}</option>
                                    <option value="account">{trans key='shop.ticket_type_account'}</option>
                                    <option value="other">{trans key='shop.ticket_type_other'}</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <input id="ticket-title" type="text" class="form-control"
                                    placeholder="{trans key='shop.ticket_title_placeholder'}">
                            </div>
                            <div class="mb-3">
                                <textarea id="ticket-comment" class="form-control" rows="12"
                                    placeholder="{trans key='shop.ticket_content_placeholder'}"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='shop.cancel'}</button>
                            <button id="create-ticket-button" class="btn btn-primary" data-bs-dismiss="modal"
                                hx-post="/user/ticket" hx-swap="none" hx-vals='js:{
                            title: document.getElementById("ticket-title").value,
                            comment: document.getElementById("ticket-comment").value,
                            type: document.getElementById("ticket-type").value }'>
                                {trans key='shop.create'}
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