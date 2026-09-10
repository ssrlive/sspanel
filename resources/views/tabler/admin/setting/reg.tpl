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
                                <span class="home-title">{trans key='admin.registration.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.registration.subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="save-setting" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.registration.save'}
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
                                            <a href="#reg" class="nav-link active"
                                                data-bs-toggle="tab">{trans key='admin.registration.tabs.registration'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#default_value" class="nav-link"
                                                data-bs-toggle="tab">{trans key='admin.registration.tabs.defaults'}</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="reg">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.mode'}</label>
                                                    <div class="col">
                                                        <select id="reg_mode" class="col form-select"
                                                            value="{$settings['reg_mode']}">
                                                            <option value="close"
                                                                {if $settings['reg_mode'] === 'close'}selected{/if}>
                                                                {trans key='admin.registration.options.closed'}
                                                            </option>
                                                            <option value="open"
                                                                {if $settings['reg_mode'] === 'open'}selected{/if}>
                                                                {trans key='admin.registration.options.open'}
                                                            </option>
                                                            <option value="invite"
                                                                {if $settings['reg_mode'] === 'invite'}selected{/if}>
                                                                {trans key='admin.registration.options.invite_only'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.email_verification'}</label>
                                                    <div class="col">
                                                        <select id="reg_email_verify" class="col form-select"
                                                            value="{$settings['reg_email_verify']}">
                                                            <option value="0"
                                                                {if ! $settings['reg_email_verify']}selected{/if}>
                                                                {trans key='admin.registration.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['reg_email_verify']}selected{/if}>
                                                                {trans key='admin.registration.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.daily_report'}</label>
                                                    <div class="col">
                                                        <select id="reg_daily_report" class="col form-select"
                                                            value="{$settings['reg_daily_report']}">
                                                            <option value="0"
                                                                {if ! $settings['reg_daily_report']}selected{/if}>
                                                                {trans key='admin.registration.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['reg_daily_report']}selected{/if}>
                                                                {trans key='admin.registration.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="default_value">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.random_group'}</label>
                                                    <div class="col">
                                                        <input id="random_group" type="text" class="form-control"
                                                            value="{$settings['random_group']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.min_port'}</label>
                                                    <div class="col">
                                                        <input id="min_port" type="text" class="form-control"
                                                            value="{$settings['min_port']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.max_port'}</label>
                                                    <div class="col">
                                                        <input id="max_port" type="text" class="form-control"
                                                            value="{$settings['max_port']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.traffic'}</label>
                                                    <div class="col">
                                                        <input id="reg_traffic" type="text" class="form-control"
                                                            value="{$settings['reg_traffic']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.free_reset_day'}</label>
                                                    <div class="col">
                                                        <input id="free_user_reset_day" type="text" class="form-control"
                                                            value="{$settings['free_user_reset_day']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.free_reset_bandwidth'}</label>
                                                    <div class="col">
                                                        <input id="free_user_reset_bandwidth" type="text"
                                                            class="form-control"
                                                            value="{$settings['free_user_reset_bandwidth']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.class'}</label>
                                                    <div class="col">
                                                        <input id="reg_class" type="text" class="form-control"
                                                            value="{$settings['reg_class']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.class_time'}</label>
                                                    <div class="col">
                                                        <input id="reg_class_time" type="text" class="form-control"
                                                            value="{$settings['reg_class_time']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.method'}</label>
                                                    <div class="col">
                                                        <input id="reg_method" type="text" class="form-control"
                                                            value="{$settings['reg_method']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.ip_limit'}</label>
                                                    <div class="col">
                                                        <input id="reg_ip_limit" type="text" class="form-control"
                                                            value="{$settings['reg_ip_limit']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.registration.fields.speed_limit'}</label>
                                                    <div class="col">
                                                        <input id="reg_speed_limit" type="text" class="form-control"
                                                            value="{$settings['reg_speed_limit']}">
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
                            url: '/admin/setting/reg',
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