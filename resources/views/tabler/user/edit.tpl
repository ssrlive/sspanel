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
                                <span class="home-title">{trans key='settings.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='settings.subtitle'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-12">
                            <div class="card">
                                <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <a href="#personal_information" class="nav-link active" data-bs-toggle="tab"
                                            aria-selected="true" role="tab">
                                            <i class="ti ti-chart-candle icon"></i>&nbsp;
                                            {trans key='settings.personal'}
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#login_security" class="nav-link" data-bs-toggle="tab"
                                            aria-selected="true" role="tab">
                                            <i class="ti ti-shield-lock icon"></i>&nbsp;
                                            {trans key='settings.security'}
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#use_safety" class="nav-link" data-bs-toggle="tab"
                                            aria-selected="false" tabindex="-1" role="tab">
                                            <i class="ti ti-brand-telegram icon"></i>&nbsp;
                                            {trans key='settings.usage'}
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a href="#other_settings" class="nav-link" data-bs-toggle="tab"
                                            aria-selected="false" tabindex="-1" role="tab">
                                            <i class="ti ti-settings icon"></i>&nbsp;
                                            {trans key='settings.other'}
                                        </a>
                                    </li>
                                </ul>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="personal_information" role="tabpanel">
                                            <div class="row row-deck row-cards">
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.login_email'}</h3>
                                                            <p>{trans key='settings.current_email'} <code id="email">{$user->email}</code></p>
                                                            <div class="mb-3">
                                                                <input id="new-email" type="email" class="form-control"
                                                                    placeholder="{trans key='settings.new_email'}"
                                                                    {if ! $config['enable_change_email']}disabled=""
                                                                    {/if}>
                                                            </div>
                                                            {if $public_setting['reg_email_verify'] && $config['enable_change_email']}
                                                                <div class="mb-3">
                                                                    <input id="email-code" type="text" class="form-control"
                                                                        placeholder="{trans key='settings.verification_code'}">
                                                                </div>
                                                            {/if}
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                {if $public_setting['reg_email_verify'] && $config['enable_change_email']}
                                                                    <button class="btn btn-link" hx-post="/user/edit/send"
                                                                        hx-swap="none"
                                                                        hx-vals='js:{ email: document.getElementById("newemail").value }'>
                                                                        {trans key='settings.get_code'}
                                                                    </button>
                                                                    <button class="btn btn-primary ms-auto"
                                                                        hx-post="/user/edit/email" hx-swap="none" hx-vals='js:{
                                                                    newemail: document.getElementById("new-email").value,
                                                                    emailcode: document.getElementById("email-code").value
                                                                }'>
                                                                        {trans key='settings.update'}
                                                                    </button>
                                                                {elseif $config['enable_change_email']}
                                                                    <button class="btn btn-primary ms-auto"
                                                                        hx-post="/user/edit/email" hx-swap="none"
                                                                        hx-vals='js:{ newemail: document.getElementById("new-email").value }'>
                                                                        {trans key='settings.update'}
                                                                    </button>
                                                                {else}
                                                                    <button class="btn btn-primary ms-auto" disabled>{trans key='settings.change_disabled'}
                                                                    </button>
                                                                {/if}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.username'}</h3>
                                                            <p>{trans key='settings.current_username'} <code id="username">{$user->user_name}</code></p>
                                                            <div class="mb-3">
                                                                <input id="new-username" type="text"
                                                                    class="form-control" placeholder="{trans key='settings.new_username'}"
                                                                    autocomplete="off">
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/username" hx-swap="none"
                                                                    hx-vals='js:{ newusername: document.getElementById("new-username").value }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.im_bind'}</h3>
                                                            <div class="mb-3">
                                                                <select id="imtype" class="form-select"
                                                                    {if $user->im_type !== 0 && $user->im_value !== ''}disabled=""
                                                                    {/if}>
                                                                    <option value="0"
                                                                        {if $user->im_type === 0}selected{/if}>
                                                                        {trans key='settings.unbound'}
                                                                    </option>
                                                                    <option value="1"
                                                                        {if $user->im_type === 1}selected{/if}>
                                                                        Slack
                                                                    </option>
                                                                    <option value="2"
                                                                        {if $user->im_type === 2}selected{/if}>
                                                                        Discord
                                                                    </option>
                                                                    <option value="4"
                                                                        {if $user->im_type === 4}selected{/if}>
                                                                        Telegram
                                                                    </option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <input id="imvalue" type="text" class="form-control"
                                                                    value="{$user->im_value}" disabled>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex btn-list justify-content-end"
                                                                id="oauth-provider"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.unbind_im'}</h3>
                                                            {if $user->im_type === 0}
                                                                <p>{trans key='settings.no_im'}</p>
                                                            {else}
                                                                <p>
                                                                    {trans key='settings.current_im'}{$user->imType()}
                                                                    <br>
                                                                    {trans key='settings.account_id'} <code>{$user->im_value}</code>
                                                                </p>
                                                            {/if}
                                                        </div>
                                                        {if $user->im_type !== 0}
                                                            <div class="card-footer">
                                                                <div class="d-flex">
                                                                    <button class="btn btn-red ms-auto"
                                                                        hx-post="/user/edit/unbind_im" hx-swap="none">
                                                                        {trans key='settings.unbind'}
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="login_security" role="tabpanel">
                                            <div class="row row-deck row-cards">
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.mfa'}</h3>
                                                            <div class="col-md-12">
                                                                <div class="col-sm-6 col-md-6">
                                                                    <i class="ti ti-brand-apple"></i>
                                                                    <a target="view_window"
                                                                        href="https://apps.apple.com/us/app/google-authenticator/id388497605">iOS
                                                                        {trans key='settings.client'}
                                                                    </a>
                                                                    &nbsp;&nbsp;&nbsp;
                                                                    <i class="ti ti-brand-android"></i>
                                                                    <a target="view_window"
                                                                        href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2">Android
                                                                        {trans key='settings.client'}
                                                                    </a>
                                                                </div>
                                                            </div>
                                                            <br>
                                                            <div class="row">
                                                                <div class="col-md-3">
                                                                    <p id="qrcode"></p>
                                                                </div>
                                                                <div class="col-md-9">
                                                                    <div class="mb-3">
                                                                        <label class="form-check form-switch">
                                                                            <input id="ga-enable"
                                                                                class="form-check-input" type="checkbox"
                                                                                value="1"
                                                                                {if $user->ga_enable === '1'}checked{/if}>
                                                                            <span
                                                                                class="form-check-label">{trans key='settings.enable_mfa'}</span>
                                                                        </label>
                                                                    </div>
                                                                    <div class="mb-3">
                                                                        <input id="ga-test-code" type="text"
                                                                            class="form-control"
                                                                            placeholder="{trans key='settings.test_code'}">
                                                                    </div>
                                                                    <div class="col-md-12">
                                                                        <p>{trans key='settings.secret'}
                                                                            <code id="ga-token" class="spoiler">
                                                                                {$user->ga_token}
                                                                            </code>
                                                                        </p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-link" hx-post="/user/ga_reset"
                                                                    hx-swap="none">
                                                                    {trans key='settings.reset'}
                                                                </button>
                                                                <button class="btn btn-link" hx-post="/user/ga_check"
                                                                    hx-swap="none"
                                                                    hx-vals='js:{ code: document.getElementById("ga-test-code").value }'>
                                                                    {trans key='settings.test'}
                                                                </button>
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/ga_set" hx-swap="none"
                                                                    hx-vals='js:{ enable: document.getElementById("ga-enable").checked ? 1 : 0 }'>
                                                                    {trans key='settings.set'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.change_password'}</h3>
                                                            <div class="form-group mb-3 row">
                                                                <label
                                                                    class="form-label col-3 col-form-label">{trans key='settings.current_password'}</label>
                                                                <div class="col">
                                                                    <input id="password" type="password"
                                                                        class="form-control" placeholder="{trans key='settings.enter_current_password'}"
                                                                        autocomplete="off">
                                                                </div>
                                                            </div>
                                                            <div class="form-group mb-3 row">
                                                                <label
                                                                    class="form-label col-3 col-form-label">{trans key='settings.new_password'}</label>
                                                                <div class="col">
                                                                    <input id="new_password" type="password"
                                                                        class="form-control" placeholder="{trans key='settings.enter_new_password'}"
                                                                        autocomplete="off">
                                                                </div>
                                                            </div>
                                                            <div class="form-group mb-3 row">
                                                                <label
                                                                    class="form-label col-3 col-form-label">{trans key='settings.confirm_password'}</label>
                                                                <div class="col">
                                                                    <input id="confirm_new_password" type="password"
                                                                        class="form-control" placeholder="{trans key='settings.enter_password_again'}"
                                                                        autocomplete="off">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/password" hx-swap="none"
                                                                    hx-vals='js:{
                                                                    new_password: document.getElementById("new_password").value,
                                                                    confirm_new_password: document.getElementById("confirm_new_password").value,
                                                                    password: document.getElementById("password").value
                                                                }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="use_safety" role="tabpanel">
                                            <div class="row row-deck row-cards">
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.change_method'}</h3>
                                                            <p>
                                                                {trans key='settings.method_help'}</p>
                                                            <div class="mb-3">
                                                                <select id="user-method" class="form-select">
                                                                    {foreach $methods as $method}
                                                                        <option value="{$method}"
                                                                            {if $user->method === $method}selected{/if}>
                                                                            {$method}
                                                                        </option>
                                                                    {/foreach}
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/method" hx-swap="none"
                                                                    hx-vals='js:{ method: document.getElementById("user-method").value }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.reset_subscription'}</h3>
                                                            <p>{trans key='settings.reset_subscription_help'}</p>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto bg-red"
                                                                    hx-post="/user/edit/url_reset" hx-swap="none">
                                                                    {trans key='settings.reset'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.reset_connection'}</h3>
                                                            <p>{trans key='settings.reset_connection_help'}</p>
                                                            <p>{trans key='settings.current_password_value'} <code id="passwd"
                                                                    class="spoiler">{$user->passwd}</code>
                                                            </p>
                                                            <p>{trans key='settings.current_uuid'} <code id="uuid"
                                                                    class="spoiler">{$user->uuid}</code>
                                                                <button class="btn btn-outline-secondary copy"
                                                                    type="button" data-clipboard-text="{$user->uuid}"
                                                                    aria-label="{trans key='settings.copy_uuid'}">
                                                                    <i class="ti ti-copy"></i>
                                                                </button>
                                                            </p>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto bg-red"
                                                                    hx-post="/user/edit/passwd_reset" hx-swap="none">
                                                                    {trans key='settings.reset'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="other_settings" role="tabpanel">
                                            <div class="row row-deck row-cards">
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.daily_report'}</h3>
                                                            <div class="mb-3">
                                                                <select id="daily-mail" class="form-select">
                                                                    <option value="0"
                                                                        {if $user->daily_mail_enable === 0}selected{/if}>
                                                                        {trans key='settings.no_receive'}
                                                                    </option>
                                                                    <option value="1"
                                                                        {if $user->daily_mail_enable === 1}selected{/if}>
                                                                        {trans key='settings.email_receive'}
                                                                    </option>
                                                                    <option value="2"
                                                                        {if $user->daily_mail_enable === 2}selected{/if}>
                                                                        {trans key='settings.im_receive'}
                                                                    </option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/daily_mail" hx-swap="none"
                                                                    hx-vals='js:{ mail: document.getElementById("daily-mail").value }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.preferred_contact'}</h3>
                                                            <p>{trans key='settings.contact_help'}</p>
                                                            <div class="mb-3">
                                                                <select id="contact-method" class="form-select">
                                                                    <option value="1"
                                                                        {if $user->contact_method === 1}selected{/if}>
                                                                        {trans key='settings.email'}
                                                                    </option>
                                                                    <option value="2"
                                                                        {if $user->contact_method === 2}selected{/if}>
                                                                        IM
                                                                    </option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/contact_method" hx-swap="none"
                                                                    hx-vals='js:{ contact: document.getElementById("contact-method").value }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.theme'}</h3>
                                                            <div class="mb-3">
                                                                <select id="user-theme" class="form-select">
                                                                    {foreach $themes as $theme}
                                                                        <option value="{$theme}"
                                                                            {if $user->theme === $theme}selected{/if}>
                                                                            {$theme}
                                                                        </option>
                                                                    {/foreach}
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/theme" hx-swap="none"
                                                                    hx-vals='js:{ theme: document.getElementById("user-theme").value }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.theme_mode'}</h3>
                                                            <div class="mb-3">
                                                                <select id="theme-mode" class="form-select">
                                                                    <option value="2"
                                                                        {if $user->is_dark_mode === 2}selected{/if}>
                                                                        {trans key='settings.automatic'}
                                                                    </option>
                                                                    <option value="0"
                                                                        {if $user->is_dark_mode === 0}selected{/if}>
                                                                        {trans key='settings.light'}
                                                                    </option>
                                                                    <option value="1"
                                                                        {if $user->is_dark_mode === 1}selected{/if}>
                                                                        {trans key='settings.dark'}
                                                                    </option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/theme_mode" hx-swap="none"
                                                                    hx-vals='js:{ theme_mode: document.getElementById("theme-mode").value }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-12 col-md-6">
                                                    <div class="card">
                                                        <div class="card-body">
                                                            <h3 class="card-title">{trans key='settings.language'}</h3>
                                                            <div class="mb-3">
                                                                <select id="user-locale" class="form-select">
                                                                    {foreach $locale_options as $locale_option}
                                                                        <option value="{$locale_option['code']}"
                                                                            {if $user->locale === $locale_option['code']}selected{/if}>
                                                                            {$locale_option['name']}
                                                                        </option>
                                                                    {/foreach}
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="d-flex">
                                                                <button class="btn btn-primary ms-auto"
                                                                    hx-post="/user/edit/locale" hx-swap="none"
                                                                    hx-vals='js:{ locale: document.getElementById("user-locale").value }'>
                                                                    {trans key='settings.update'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                {if $config['enable_kill']}
                                                    <div class="col-sm-12 col-md-6">
                                                        <div class="card">
                                                            <div class="card-stamp">
                                                                <div class="card-stamp-icon bg-red">
                                                                    <i class="ti ti-circle-x"></i>
                                                                </div>
                                                            </div>
                                                            <div class="card-body">
                                                                <h3 class="card-title">{trans key='settings.delete_data'}</h3>
                                                            </div>
                                                            <div class="card-footer">
                                                                <button class="btn btn-red" data-bs-toggle="modal"
                                                                    data-bs-target="#destroy-account">
                                                                    <i class="ti ti-trash icon"></i>
                                                                    {trans key='settings.confirm_delete'}
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {if $config['enable_kill']}
                <div class="modal modal-blur fade" id="destroy-account" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <button class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            <div class="modal-status bg-danger"></div>
                            <div class="modal-body text-center py-4">
                                <i class="ti ti-alert-circle icon mb-2 text-danger icon-lg" style="font-size:3.5rem;"></i>
                                <h3>{trans key='settings.delete_title'}</h3>
                                <div class="text-secondary">
                                    {trans key='settings.delete_help'}
                                </div>
                                <div class="py-3">
                                    <form>
                                        <input id="confirm_kill_password" type="password" class="form-control"
                                            placeholder="{trans key='settings.enter_login_password'}" autocomplete="off">
                                    </form>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <div class="w-100">
                                    <div class="row">
                                        <div class="col">
                                            <button class="btn w-100" data-bs-dismiss="modal">
                                                {trans key='settings.cancel'}
                                            </button>
                                        </div>
                                        <div class="col">
                                            <button href="#" class="btn btn-danger w-100" data-bs-dismiss="modal"
                                                hx-post="/user/edit/kill" hx-swap="none"
                                                hx-vals='js:{ password: document.getElementById("confirm_kill_password").value }'>
                                                {trans key='settings.confirm'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            {/if}

            <script>
                let qrcode = new QRCode('qrcode', {
                    text: "{$ga_url}",
                    width: 128,
                    height: 128,
                    colorDark: '#000000',
                    colorLight: '#ffffff',
                    correctLevel: QRCode.CorrectLevel.H
                });

                {if $user->im_type === 0 && $user->im_value === ''}
                    let oauthProvider = $('#oauth-provider');

                    $("#imtype").on('change', function() {
                        if ($(this).val() === '0') {
                            oauthProvider.empty();
                        } else if ($(this).val() === '1') {
                            oauthProvider.empty();
                            oauthProvider.append(
                                "<a id='bind-slack' class='btn btn-azure ms-auto'>{trans key='settings.bind_slack'}</a>"
                            );
                        } else if ($(this).val() === '2') {
                            oauthProvider.empty();
                            oauthProvider.append(
                                "<a id='bind-discord' class='btn btn-indigo ms-auto'>{trans key='settings.bind_discord'}</a>"
                            );
                        } else if ($(this).val() === '4') {
                            oauthProvider.empty();
                            oauthProvider.append(
                                '<script async src=\"https://telegram.org/js/telegram-widget.js?22\"' +
                                ' data-telegram-login=\"' + "{$public_setting['telegram_bot']}" +
                                '\" data-size=\"large" data-onauth=\"onTelegramAuth(user)\"' +
                                ' data-request-access=\"write\"><\/script>'
                            );
                        }
                    });

                    oauthProvider.on('click', '#bind-slack', function() {
                        $.ajax({
                            type: "POST",
                            url: "/oauth/slack",
                            dataType: "json",
                            success: function(data) {
                                handleOauthResult(data, 'slack')
                            }
                        })
                    });

                    oauthProvider.on('click', '#bind-discord', function() {
                        $.ajax({
                            type: "POST",
                            url: "/oauth/discord",
                            dataType: "json",
                            success: function(data) {
                                handleOauthResult(data, 'discord')
                            }
                        })
                    });

                    function onTelegramAuth(user) {
                        $.ajax({
                            type: "POST",
                            url: "/oauth/telegram",
                            dataType: "json",
                            data: {
                                user: JSON.stringify(user),
                            },
                            success: function(data) {
                                handleOauthResult(data, 'telegram')
                            }
                        })
                    }

                    function handleOauthResult(data, type = 'telegram') {
                        if (data.ret === 1) {
                            if (type === 'telegram') {
                                $('#success-message').text(data.msg);
                                $('#success-dialog').modal('show');
                            } else {
                                window.location.replace(data.redir);
                            }
                        } else {
                            $('#error-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                {/if}
            </script>

            {include file='user/footer.tpl'}
            {include file='copy-to-clipboard.tpl'}
        </div>
    </div>

    {include file="user/footer-scripts.tpl"}

    {include file='live_chat.tpl'}

    <script>
        htmx.on("htmx:afterRequest", function(evt) {
            if (!evt.detail || !evt.detail.xhr) {
                return;
            }

            var url = evt.detail.xhr.responseURL || '';
            if (url.indexOf('/user/edit/passwd_reset') !== -1) {
                try {
                    var res = JSON.parse(evt.detail.xhr.response);
                    if (res && res.ret === 1 && res.data && typeof res.data.passwd !== 'undefined') {
                        var passwdElement = document.getElementById('passwd');
                        if (passwdElement) {
                            passwdElement.innerHTML = res.data.passwd;
                        }
                    }
                } catch (e) {
                    // ignore invalid JSON
                }
                return;
            }

            if (url.indexOf('/user/ga_reset') !== -1) {
                try {
                    var res = JSON.parse(evt.detail.xhr.response);
                    if (res && res.ret === 1 && res.data) {
                        var gaTokenElement = document.getElementById('ga-token');
                        if (gaTokenElement && typeof res.data['ga-token'] !== 'undefined') {
                            gaTokenElement.innerHTML = res.data['ga-token'];
                        }
                    }
                } catch (e) {
                    // ignore invalid JSON
                }
                return;
            }
        });
    </script>
</body>

</html>