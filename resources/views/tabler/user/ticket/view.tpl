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
                                <span class="home-title">{trans key='shop.ticket_history'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='shop.ticket_view_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div class="btn-list">
                                {if $ticket->raw_status !== 'closed'}
                                    <button class="btn btn-danger" hx-post="/user/ticket/{$ticket->id}/close" hx-swap="none"
                                        onclick="return confirm('{trans key='shop.close_ticket_confirm' js=true}');">
                                        {trans key='shop.close'}
                                    </button>
                                {/if}
                                <a href="#" class="btn btn-primary ms-2" data-bs-toggle="modal"
                                    data-bs-target="#add-reply">
                                    <i class="icon ti ti-plus"></i>
                                    {trans key='shop.add_reply'}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-cards">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="h1 my-2 mb-3">#{$ticket->id} {$ticket->title}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row row-deck my-3">
                        <div class="col-4">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="subheader">{trans key='shop.ticket_status'}</div>
                                    </div>
                                    <div class="h1 mb-3">{$ticket->status_text}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="subheader">{trans key='shop.ticket_type'}</div>
                                    </div>
                                    <div class="h1 mb-3">{$ticket->type_text}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="card">
                                <div class="card-body">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center">
                                            <div class="subheader">{trans key='shop.ticket_opened_at'}</div>
                                        </div>
                                        <div class="h1 mb-3">{$ticket->datetime}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row justify-content-center my-3">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="divide-y">
                                        {foreach $comments as $comment}
                                            <div>
                                                <div class="row">
                                                    <div class="col">
                                                        <div>
                                                            {$comment->comment}
                                                        </div>
                                                        <div class="text-secondary my-1">{$comment->commenter_name}
                                                            {trans key='shop.replied_at'} {$comment->datetime}</div>
                                                    </div>
                                                    <div class="col-auto">
                                                        <div>
                                                            # {$comment->comment_id + 1}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        {/foreach}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal modal-blur fade" id="add-reply" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='shop.add_reply'}</h5>
                            <button class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <textarea id="reply-comment" class="form-control" rows="15"
                                    placeholder="{trans key='shop.reply_content_placeholder'}"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='shop.cancel'}</button>
                            <button id="reply" class="btn btn-primary" data-bs-dismiss="modal"
                                hx-post="/user/ticket/{$ticket->id}" hx-swap="none"
                                hx-vals='js:{ comment: document.getElementById("reply-comment").value }'>
                                {trans key='shop.reply'}
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