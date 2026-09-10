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
                                <span class="home-title">{trans key='admin.subscription.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.subscription.subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="save-setting" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.subscription.save'}
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
                                            <a href="#sub" class="nav-link active" data-bs-toggle="tab">{trans key='admin.subscription.tabs.general'}</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="sub">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.shadowsocks'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_ss_sub" class="form-check-input" type="checkbox"
                                                                {if $settings['enable_ss_sub']}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.vmess'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_v2_sub" class="form-check-input" type="checkbox"
                                                                {if $settings['enable_v2_sub']}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.trojan'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_trojan_sub" class="form-check-input" type="checkbox"
                                                                {if $settings['enable_trojan_sub']}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.json'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_json_sub" class="form-check-input"
                                                                type="checkbox"
                                                                {if $settings.enable_json_sub|default:1}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.clash'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_clash_sub" class="form-check-input"
                                                                type="checkbox"
                                                                {if $settings.enable_clash_sub|default:1}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.singbox'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_singbox_sub" class="form-check-input"
                                                                type="checkbox"
                                                                {if $settings.enable_singbox_sub|default:1}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.v2ray_json'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_v2rayjson_sub" class="form-check-input"
                                                                type="checkbox"
                                                                {if $settings.enable_v2rayjson_sub|default:1}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.overtls'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_overtls_sub" class="form-check-input"
                                                                type="checkbox"
                                                                {if $settings.enable_overtls_sub|default:0}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.anytls'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_anytls_sub" class="form-check-input"
                                                                type="checkbox"
                                                                {if $settings.enable_anytls_sub|default:0}checked{/if}>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        {trans key='admin.subscription.fields.reset_on_password_change'}
                                                    </label>
                                                    <div class="col-auto">
                                                        <label class="form-check form-check-single form-switch">
                                                            <input id="enable_forced_replacement"
                                                                class="form-check-input" type="checkbox"
                                                                {if $settings['enable_forced_replacement']}checked{/if}>
                                                        </label>
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
                            url: '/admin/setting/sub',
                            type: 'POST',
                            dataType: "json",
                            data: {
                                {foreach $update_field as $key}
                                    {$key}: ($('#{$key}').is(':checkbox') ? ($('#{$key}').prop('checked') ? 1 : 0) : $('#{$key}').val()),
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