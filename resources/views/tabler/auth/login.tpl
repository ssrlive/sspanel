<!doctype html>
<html lang="{$config['locale']}" data-bs-theme="auto">

{include file='header.tpl'}

<body class="border-top-wide border-primary d-flex flex-column">
    <div class="page page-center">
        <div class="container-tight my-auto">
            <div class="text-center mb-4">
                <a href="#" class="navbar-brand navbar-brand-autodark">
                    <img src="/images/next-logo.svg" height="64" alt="Next Panel Logo">
                </a>
            </div>
            <div class="card card-md">
                <div class="card-body">
                    <h2 class="card-title text-center mb-4">{trans key='auth.login_title'}</h2>
                    <div class="mb-3">
                        <label class="form-label">{trans key='auth.email'}</label>
                        <input id="email" type="email" class="form-control">
                    </div>
                    <div class="mb-2">
                        <label class="form-label">
                            {trans key='auth.password'}
                            <span class="form-label-description">
                                <a href="/password/reset">{trans key='auth.forgot_password'}</a>
                            </span>
                        </label>
                        <div class="input-group input-group-flat">
                            <input id="password" type="password" class="form-control" autocomplete="off">
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">{trans key='auth.mfa'}</label>
                        <input id="mfa_code" type="email" class="form-control" placeholder="{trans key='auth.mfa_placeholder'}">
                    </div>
                    <div class="mb-2">
                        <label class="form-check">
                            <input id="remember_me" type="checkbox" class="form-check-input" />
                            <span class="form-check-label">{trans key='auth.remember_device'}</span>
                        </label>
                    </div>
                    <div class="mb-3">
                        <div class="input-group mb-3">
                            {if $public_setting['enable_login_captcha']}
                                {include file='captcha/div.tpl'}
                            {/if}
                        </div>
                    </div>
                    <div class="form-footer">
                        <button class="btn btn-primary w-100" hx-post="/auth/login" hx-swap="none" hx-vals='js:{
                                {if $public_setting['enable_login_captcha']}
                                    {include file='captcha/ajax.tpl'}
                                {/if}
                                email: document.getElementById("email").value,
                                password: document.getElementById("password").value,
                                mfa_code: document.getElementById("mfa_code").value,
                                remember_me: document.getElementById("remember_me").checked,
                             }'>
                            {trans key='auth.login'}
                        </button>
                    </div>
                </div>
            </div>
            <div class="text-center text-secondary mt-3">
                {trans key='auth.no_account'} <a href="/auth/register" tabindex="-1">{trans key='auth.register_link'}</a>
            </div>
        </div>
    </div>

    {if $public_setting['enable_login_captcha']}
        {include file='captcha/js.tpl'}
    {/if}

    {include file='footer.tpl'}
</body>

</html>