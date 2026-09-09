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
                    <h2 class="card-title text-center mb-4">{trans key='password_reset.new_password'}</h2>
                    <div class="mb-3">
                        <label class="form-label">{trans key='password_reset.new_password'}</label>
                        <input id="password" type="password" class="form-control" placeholder="{trans key='password_reset.new_password_placeholder'}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">{trans key='password_reset.confirm_new_password'}</label>
                        <input id="confirm_password" type="password" class="form-control" placeholder="{trans key='password_reset.confirm_new_password_placeholder'}">
                    </div>
                    <div class="form-footer">
                        <button class="btn btn-primary w-100" hx-post="/password/token" hx-swap="none" hx-vals='js:{
                            token: location.pathname.split("/").pop(),
                            password: document.getElementById("password").value,
                            confirm_password: document.getElementById("confirm_password").value, }'>
                            <i class="ti ti-key icon"></i>
                            {trans key='password_reset.reset'}
                        </button>
                    </div>
                </div>
            </div>
            <div class="text-center text-secondary mt-3">
                {trans key='auth.has_account'} <a href="/auth/login" tabindex="-1">{trans key='auth.login_link'}</a>
            </div>
        </div>
    </div>

    {include file='footer.tpl'}
</body>

</html>