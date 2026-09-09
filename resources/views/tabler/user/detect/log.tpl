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
                                <span class="home-title">{trans key='user_pages.audit_logs_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='user_pages.audit_logs_subtitle'}</span>
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
                                <div class="table-responsive">
                                    <table class="table table-vcenter card-table">
                                        <thead>
                                            <tr>
                                                <th>{trans key='shop.event_id'}</th>
                                                <th>{trans key='user_pages.node_id'}</th>
                                                <th>{trans key='user_pages.node_name'}</th>
                                                <th>{trans key='user_pages.rule_id'}</th>
                                                <th>{trans key='shop.name'}</th>
                                                <th>{trans key='user_pages.description'}</th>
                                                <th>{trans key='user_pages.regex'}</th>
                                                <th>{trans key='user_pages.match_type'}</th>
                                                <th>{trans key='user_pages.time'}</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach $logs as $log}
                                                <tr>
                                                    <td>#{$log->id}</td>
                                                    <td>{$log->node_id}</td>
                                                    <td>{$log->node_name}</td>
                                                    <td>{$log->list_id}</td>
                                                    <td>{$log->rule->name}</td>
                                                    <td>{$log->rule->text}</td>
                                                    <td>{$log->rule->regex}</td>
                                                    <td>{$log->rule->type}</td>
                                                    <td>{$log->datetime}</td>
                                                </tr>
                                            {/foreach}
                                        </tbody>
                                    </table>
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