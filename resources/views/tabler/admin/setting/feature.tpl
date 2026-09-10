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
                                <span class="home-title">{trans key='admin.feature.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.feature.subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="save-setting" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.feature.save'}
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
                                            <a href="#display" class="nav-link active"
                                                data-bs-toggle="tab">{trans key='admin.feature.tabs.display'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#log" class="nav-link"
                                                data-bs-toggle="tab">{trans key='admin.feature.tabs.log'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#checkin" class="nav-link"
                                                data-bs-toggle="tab">{trans key='admin.feature.tabs.checkin'}</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="display">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.display_detect_log'}</label>
                                                    <div class="col">
                                                        <select id="display_detect_log" class="col form-select"
                                                            value="{$settings['display_detect_log']}">
                                                            <option value="0"
                                                                {if ! $settings['display_detect_log']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['display_detect_log']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.display_docs'}</label>
                                                    <div class="col">
                                                        <select id="display_docs" class="col form-select"
                                                            value="{$settings['display_docs']}">
                                                            <option value="0"
                                                                {if ! $settings['display_docs']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['display_docs']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.docs_paid_only'}</label>
                                                    <div class="col">
                                                        <select id="display_docs_only_for_paid_user"
                                                            class="col form-select"
                                                            value="{$settings['display_docs_only_for_paid_user']}">
                                                            <option value="0"
                                                                {if ! $settings['display_docs_only_for_paid_user']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['display_docs_only_for_paid_user']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="log">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.traffic_log'}</label>
                                                    <div class="col">
                                                        <select id="traffic_log" class="col form-select"
                                                            value="{$settings['traffic_log']}">
                                                            <option value="0"
                                                                {if ! $settings['traffic_log']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['traffic_log']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.traffic_retention'}</label>
                                                    <div class="col">
                                                        <input id="traffic_log_retention_days" type="text"
                                                            class="form-control"
                                                            value="{$settings['traffic_log_retention_days']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.subscribe_log'}</label>
                                                    <div class="col">
                                                        <select id="subscribe_log" class="col form-select"
                                                            value="{$settings['subscribe_log']}">
                                                            <option value="0"
                                                                {if ! $settings['subscribe_log']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['subscribe_log']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.subscribe_retention'}</label>
                                                    <div class="col">
                                                        <input id="subscribe_log_retention_days" type="text"
                                                            class="form-control"
                                                            value="{$settings['subscribe_log_retention_days']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.notify_new_subscribe'}</label>
                                                    <div class="col">
                                                        <select id="notify_new_subscribe" class="col form-select"
                                                            value="{$settings['notify_new_subscribe']}">
                                                            <option value="0"
                                                                {if ! $settings['notify_new_subscribe']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['notify_new_subscribe']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.login_log'}</label>
                                                    <div class="col">
                                                        <select id="login_log" class="col form-select"
                                                            value="{$settings['login_log']}">
                                                            <option value="0"
                                                                {if ! $settings['login_log']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1" {if $settings['login_log']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.notify_new_login'}</label>
                                                    <div class="col">
                                                        <select id="notify_new_login" class="col form-select"
                                                            value="{$settings['notify_new_login']}">
                                                            <option value="0"
                                                                {if ! $settings['notify_new_login']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['notify_new_login']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="checkin">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.enable_checkin'}</label>
                                                    <div class="col">
                                                        <select id="enable_checkin" class="col form-select"
                                                            value="{$settings['enable_checkin']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_checkin']}selected{/if}>
                                                                {trans key='admin.feature.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_checkin']}selected{/if}>
                                                                {trans key='admin.feature.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.checkin_min'}</label>
                                                    <div class="col">
                                                        <input id="checkin_min" type="text" class="form-control"
                                                            value="{$settings['checkin_min']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.feature.fields.checkin_max'}</label>
                                                    <div class="col">
                                                        <input id="checkin_max" type="text" class="form-control"
                                                            value="{$settings['checkin_max']}">
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
                            url: '/admin/setting/feature',
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