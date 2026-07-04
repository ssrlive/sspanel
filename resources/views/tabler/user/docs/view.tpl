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
                                {$doc->title}
                            </h2>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="card card-lg">
                        <div class="card-body ">
                            <div class="row g-4">
                                {$doc->content}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {include file='user/footer.tpl'}
        </div>
    </div>

    {include file="user/footer-scripts.tpl"}

    {include file='live_chat.tpl'}

</body>

</html>