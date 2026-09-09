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
                                <span class="home-title">{trans key='invite.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='invite.subtitle'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-12">
                            <div class="row row-deck row-cards">
                                <div class="col-sm-12 col-lg-6">
                                    <div class="card">
                                        <div class="card-body">
                                            <h3 class="card-title">{trans key='invite.rules'}</h3>
                                            <ul>
                                                <li>{trans key='invite.rule_one' rate="<code>{$invite_reward_rate}%</code>"}</li>
                                                <li>{trans key='invite.rule_two'}</li>
                                            </ul>
                                            <p>{trans key='invite.total_rebate' amount="<code>{$paybacks_sum}</code>"}</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-12 col-lg-6">
                                    <div class="card">
                                        <div class="card-body">
                                            <h3 class="card-title">{trans key='invite.link'}</h3>
                                            <input class="form-control" id="invite-url" value="{$invite_url}" disabled>
                                        </div>
                                        <div class="card-footer">
                                            <div class="d-flex">
                                                <button class="btn text-red btn-link" hx-post="/user/invite/reset"
                                                    hx-swap="none">
                                                    {trans key='invite.reset'}
                                                </button>
                                                <button id="invite-copy" data-clipboard-text="{$invite_url}"
                                                    class="copy btn btn-primary ms-auto">{trans key='invite.copy'}</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 my-3">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">{trans key='invite.records'}</h3>
                                </div>
                                <div class="table-responsive">
                                    <table class="table card-table table-vcenter text-nowrap datatable">
                                        <thead>
                                            <tr>
                                                <th>{trans key='invite.record_id'}</th>
                                                <th>{trans key='invite.invited_user_id'}</th>
                                                <th>{trans key='invite.invited_username'}</th>
                                                <th>{trans key='invite.rebate_amount'}</th>
                                                <th>{trans key='invite.rebate_time'}</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach $paybacks as $payback}
                                                <tr>
                                                    <td>{$payback->id}</td>
                                                    <td>{$payback->userid}</td>
                                                    <td>{$payback->user_name}</td>
                                                    <td>{$payback->ref_get} {trans key='invite.currency'}</td>
                                                    <td>{$payback->datetime}</td>
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

            {include file='user/footer.tpl'}

            {include file='copy-to-clipboard.tpl'}
        </div>
    </div>

    {include file="user/footer-scripts.tpl"}

    <script>
        htmx.on("htmx:afterRequest", function(evt) {
            if (evt.detail.xhr.getResponseHeader('HX-Refresh') === 'true' ||
                evt.detail.xhr.getResponseHeader('HX-Redirect') ||
                evt.detail.xhr.getResponseHeader('HX-Trigger')) {
                return;
            }

            let res;
            try {
                res = JSON.parse(evt.detail.xhr.response);
            } catch (e) {
                return;
            }

            if (typeof res.data !== 'undefined' && typeof res.data['invite-url'] !== 'undefined') {
                const inviteUrlValue = res.data['invite-url'];
                const inviteCopyButton = document.getElementById('invite-copy');
                if (inviteCopyButton) {
                    inviteCopyButton.setAttribute('data-clipboard-text', inviteUrlValue);
                }

                const inviteUrlInput = document.getElementById('invite-url');
                if (inviteUrlInput) {
                    inviteUrlInput.value = inviteUrlValue;
                }
            }
        });
    </script>

    {include file='live_chat.tpl'}

</body>

</html>