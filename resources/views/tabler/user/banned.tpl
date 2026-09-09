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
                                <span class="home-title">{trans key='user_pages.banned_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='user_pages.banned_subtitle'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-sm-12 col-lg-12">
                            <div class="card">
                                <div class="empty">
                                    <div class="empty-img">
                                        <i class="ti ti-circle-x icon mb-2 text-danger icon-lg"
                                            style="font-size:3.5rem;"></i>
                                    </div>
                                    {if $banned_reason === 'DetectBan'}
                                        <p class="empty-title">{trans key='user_pages.audit_ban'}</p>
                                        <p class="empty-subtitle text-secondary">{trans key='user_pages.audit_ban_reason'}
                                        </p>
                                    {else}
                                        <p class="empty-title">{trans key='user_pages.ban_reason'}</p>
                                        <p class="empty-subtitle text-secondary">{$banned_reason}</p>
                                    {/if}
                                </div>
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