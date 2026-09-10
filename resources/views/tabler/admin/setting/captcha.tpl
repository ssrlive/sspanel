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
                                <span class="home-title">{trans key='admin.captcha.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.captcha.subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="save-setting" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.captcha.save'}
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
                                            <a href="#captcha" class="nav-link active"
                                                data-bs-toggle="tab">{trans key='admin.captcha.tabs.general'}</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#turnstile" class="nav-link" data-bs-toggle="tab">Turnstile</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#geetest" class="nav-link" data-bs-toggle="tab">Geetest</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#hcaptcha" class="nav-link" data-bs-toggle="tab">hCaptcha</a>
                                        </li>
                                        <li class="nav-item">
                                            <a href="#recaptcha_enterprise" class="nav-link" data-bs-toggle="tab">
                                                reCAPTCHA Enterprise
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="captcha">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.captcha.fields.provider'}</label>
                                                    <div class="col">
                                                        <select id="captcha_provider" class="col form-select"
                                                            value="{$settings['captcha_provider']}">
                                                            <option value="turnstile"
                                                                {if $settings['captcha_provider'] === "turnstile"}selected{/if}>
                                                                Turnstile
                                                            </option>
                                                            <option value="geetest"
                                                                {if $settings['captcha_provider'] === "geetest"}selected{/if}>
                                                                Geetest
                                                            </option>
                                                            <option value="hcaptcha"
                                                                {if $settings['captcha_provider'] === "hcaptcha"}selected{/if}>
                                                                hCaptcha
                                                            </option>
                                                            <option value="recaptcha_enterprise"
                                                                {if $settings['captcha_provider'] === "recaptcha_enterprise"}selected{/if}>
                                                                reCAPTCHA Enterprise
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.captcha.fields.registration'}</label>
                                                    <div class="col">
                                                        <select id="enable_reg_captcha" class="col form-select"
                                                            value="{$settings['enable_reg_captcha']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_reg_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_reg_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.captcha.fields.login'}</label>
                                                    <div class="col">
                                                        <select id="enable_login_captcha" class="col form-select"
                                                            value="{$settings['enable_login_captcha']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_login_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_login_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.captcha.fields.checkin'}</label>
                                                    <div class="col">
                                                        <select id="enable_checkin_captcha" class="col form-select"
                                                            value="{$settings['enable_checkin_captcha']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_checkin_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_checkin_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label
                                                        class="form-label col-3 col-form-label">{trans key='admin.captcha.fields.reset_password'}</label>
                                                    <div class="col">
                                                        <select id="enable_reset_password_captcha"
                                                            class="col form-select"
                                                            value="{$settings['enable_reset_password_captcha']}">
                                                            <option value="0"
                                                                {if ! $settings['enable_reset_password_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.disabled'}
                                                            </option>
                                                            <option value="1"
                                                                {if $settings['enable_reset_password_captcha']}selected{/if}>
                                                                {trans key='admin.captcha.options.enabled'}
                                                            </option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="turnstile">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">Site Key</label>
                                                    <div class="col">
                                                        <input id="turnstile_sitekey" type="text" class="form-control"
                                                            value="{$settings['turnstile_sitekey']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">Secret</label>
                                                    <div class="col">
                                                        <input id="turnstile_secret" type="text" class="form-control"
                                                            value="{$settings['turnstile_secret']}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="geetest">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">ID</label>
                                                    <div class="col">
                                                        <input id="geetest_id" type="text" class="form-control"
                                                            value="{$settings['geetest_id']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">Key</label>
                                                    <div class="col">
                                                        <input id="geetest_key" type="text" class="form-control"
                                                            value="{$settings['geetest_key']}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="hcaptcha">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">Site Key</label>
                                                    <div class="col">
                                                        <input id="hcaptcha_sitekey" type="text" class="form-control"
                                                            value="{$settings['hcaptcha_sitekey']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">Secret</label>
                                                    <div class="col">
                                                        <input id="hcaptcha_secret" type="text" class="form-control"
                                                            value="{$settings['hcaptcha_secret']}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="recaptcha_enterprise">
                                            <div class="card-body">
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        Key
                                                    </label>
                                                    <div class="col">
                                                        <input id="recaptcha_enterprise_key_id" type="text"
                                                            class="form-control"
                                                            value="{$settings['recaptcha_enterprise_key_id']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        Project ID
                                                    </label>
                                                    <div class="col">
                                                        <input id="recaptcha_enterprise_project_id" type="text"
                                                            class="form-control"
                                                            value="{$settings['recaptcha_enterprise_project_id']}">
                                                    </div>
                                                </div>
                                                <div class="form-group mb-3 row">
                                                    <label class="form-label col-3 col-form-label">
                                                        API Key
                                                    </label>
                                                    <div class="col">
                                                        <input id="recaptcha_enterprise_api_key" type="text"
                                                            class="form-control"
                                                            value="{$settings['recaptcha_enterprise_api_key']}">
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
                            url: '/admin/setting/captcha',
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