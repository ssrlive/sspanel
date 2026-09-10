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
                                <span class="home-title">{trans key='admin.support.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.support.subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="save-setting" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.support.save'}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-header">
                                    <ul class="nav nav-tabs card-header-tabs" data-bs-toggle="tabs">
                                        <li class="nav-item">
                                            <a href="#support" class="nav-link active"
                                                data-bs-toggle="tab">{trans key='admin.support.tabs.live_chat'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#ticket" class="nav-link"
                                                data-bs-toggle="tab">{trans key='admin.support.tabs.ticket'}</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="support">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.support.fields.provider'}</label>
                                                    <div class="col">
                                                        <select id="live_chat" class="col form-select"
                                                            value="{$settings['live_chat']}">
                                                            <option value="none"
                                                                {if $settings['live_chat'] === "none"}selected{/if}>None
                                                            </option>
                                                            <option value="crisp"
                                                                {if $settings['live_chat'] === "crisp"}selected{/if}>
                                                                Crisp
                                                            </option>
                                                            <option value="livechat"
                                                                {if $settings['live_chat'] === "livechat"}selected{/if}>
                                                                LiveChat
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">Crisp ID</label>
                                                    <div class="col">
                                                        <input id="crisp_id" type="text" class="form-control"
                                                            value="{$settings['crisp_id']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">LiveChat
                                                        License</label>
                                                    <div class="col">
                                                        <input id="livechat_license" type="text" class="form-control"
                                                            value="{$settings['livechat_license']}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="ticket">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.support.fields.ticket_enabled'}</label>
                                                    <div class="col">
                                                        <select id="enable_ticket" class="col form-select"
                                                            value="{$settings['enable_ticket']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_ticket']}selected{/if}>
                                                                {trans key='admin.support.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_ticket']}selected{/if}>
                                                                {trans key='admin.support.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.support.fields.ticket_mail'}</label>
                                                    <div class="col">
                                                        <select id="mail_ticket" class="col form-select"
                                                            value="{$settings['mail_ticket']}">
                                                            <option value="0"
                                                                {if ! $settings['mail_ticket']}selected{/if}>
                                                                {trans key='admin.support.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['mail_ticket']}selected{/if}>
                                                                {trans key='admin.support.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.support.fields.ticket_limit'}</label>
                                                    <div class="col">
                                                        <input id="ticket_limit" type="text" class="form-control"
                                                            value="{$settings['ticket_limit']}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    $("#save-setting").click(function() {
                        $.ajax({
                            url: '/admin/setting/support',
                            type: 'POST',
                            dataType: "json",
                            data: {
                                {foreach $update_field as $key}
                                    {$key}: $('#{$key}').val(),
                                {/foreach}
                            },
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
    </div>

    {include file='admin/footer-scripts.tpl'}
</body>

</html>