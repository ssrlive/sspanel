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
                                <span class="home-title">{trans key='admin.cron.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.cron.subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="save-setting" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.cron.save'}
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
                                            <a href="#daily_job" class="nav-link active"
                                                data-bs-toggle="tab">{trans key='admin.cron.tabs.daily_job'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#finance_mail" class="nav-link"
                                                data-bs-toggle="tab">{trans key='admin.cron.tabs.finance_mail'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#detect" class="nav-link"
                                                data-bs-toggle="tab">{trans key='admin.cron.tabs.detect'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#inactive" class="nav-link"
                                                data-bs-toggle="tab">{trans key='admin.cron.tabs.inactive'}</a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="daily_job">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.daily_hour'}</label>
                                                    <div class="col">
                                                        <input id="daily_job_hour" type="text" class="form-control"
                                                            value="{$settings['daily_job_hour']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.daily_minute'}</label>
                                                    <div class="col">
                                                        <input id="daily_job_minute" type="text" class="form-control"
                                                            value="{$settings['daily_job_minute']}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane show" id="finance_mail">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.daily_finance'}</label>
                                                    <div class="col">
                                                        <select id="enable_daily_finance_mail" class="col form-select"
                                                            value="{$settings['enable_daily_finance_mail']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_daily_finance_mail']}selected{/if}>
                                                                {trans key='admin.cron.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_daily_finance_mail']}selected{/if}>
                                                                {trans key='admin.cron.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.weekly_finance'}</label>
                                                    <div class="col">
                                                        <select id="enable_weekly_finance_mail" class="col form-select"
                                                            value="{$settings['enable_weekly_finance_mail']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_weekly_finance_mail']}selected{/if}>
                                                                {trans key='admin.cron.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_weekly_finance_mail']}selected{/if}>
                                                                {trans key='admin.cron.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.monthly_finance'}</label>
                                                    <div class="col">
                                                        <select id="enable_monthly_finance_mail" class="col form-select"
                                                            value="{$settings['enable_monthly_finance_mail']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_monthly_finance_mail']}selected{/if}>
                                                                {trans key='admin.cron.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_monthly_finance_mail']}selected{/if}>
                                                                {trans key='admin.cron.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane show" id="detect">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.detect_gfw'}</label>
                                                    <div class="col">
                                                        <select id="enable_detect_gfw" class="col form-select"
                                                            value="{$settings['enable_detect_gfw']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_detect_gfw']}selected{/if}>
                                                                {trans key='admin.cron.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_detect_gfw']}selected{/if}>
                                                                {trans key='admin.cron.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.detect_ban'}</label>
                                                    <div class="col">
                                                        <select id="enable_detect_ban" class="col form-select"
                                                            value="{$settings['enable_detect_ban']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_detect_ban']}selected{/if}>
                                                                {trans key='admin.cron.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_detect_ban']}selected{/if}>
                                                                {trans key='admin.cron.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane show" id="inactive">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.detect_inactive'}</label>
                                                    <div class="col">
                                                        <select id="enable_detect_inactive_user" class="col form-select"
                                                            value="{$settings['enable_detect_inactive_user']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_detect_inactive_user']}selected{/if}>
                                                                {trans key='admin.cron.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_detect_inactive_user']}selected{/if}>
                                                                {trans key='admin.cron.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.inactive_checkin_days'}</label>
                                                    <div class="col">
                                                        <input id="detect_inactive_user_checkin_days" type="text"
                                                            class="form-control"
                                                            value="{$settings['detect_inactive_user_checkin_days']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.inactive_login_days'}</label>
                                                    <div class="col">
                                                        <input id="detect_inactive_user_login_days" type="text"
                                                            class="form-control"
                                                            value="{$settings['detect_inactive_user_login_days']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.inactive_use_days'}</label>
                                                    <div class="col">
                                                        <input id="detect_inactive_user_use_days" type="text"
                                                            class="form-control"
                                                            value="{$settings['detect_inactive_user_use_days']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.cron.fields.remove_inactive_data'}</label>
                                                    <div class="col">
                                                        <select id="remove_inactive_user_link_and_invite"
                                                            class="col form-select"
                                                            value="{$settings['remove_inactive_user_link_and_invite']}">
                                                            <option value="0"
                                                                {if ! $settings['remove_inactive_user_link_and_invite']}selected{/if}>
                                                                {trans key='admin.cron.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['remove_inactive_user_link_and_invite']}selected{/if}>
                                                                {trans key='admin.cron.options.enabled'}
                                                            </option>
                                                        </select>
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
                            url: '/admin/setting/cron',
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