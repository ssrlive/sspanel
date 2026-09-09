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
                                <span class="home-title">{trans key='profile.title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='profile.subtitle'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-sm-6 col-lg-3">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="subheader">{trans key='profile.email'}</div>
                                    </div>
                                    <div class="h1 mb-3">{$user->email}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="subheader">{trans key='profile.username'}</div>
                                    </div>
                                    <div class="h1 mb-3">{$user->user_name}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="subheader">{trans key='profile.registered_at'}</div>
                                    </div>
                                    <div class="h1 mb-3">{$user->reg_date}</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-6 col-lg-3">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="subheader">{trans key='profile.total_traffic'}</div>
                                    </div>
                                    <div class="h1 mb-3">{$user->totalTraffic()}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    {if $public_setting['subscribe_log']}
                        <div class="row row-deck my-3">
                            <div class="col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">{trans key='profile.recent_subscriptions'}</h3>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-vcenter text-nowrap card-table">
                                            <thead>
                                                <tr>
                                                    <th>{trans key='profile.type'}</th>
                                                    <th>{trans key='profile.user_agent'}</th>
                                                    <th>IP</th>
                                                    <th>{trans key='profile.location'}</th>
                                                    <th>{trans key='profile.time'}</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach $subs as $sub}
                                                    <tr>
                                                        <td>{$sub->type}</td>
                                                        <td>{$sub->request_user_agent}</td>
                                                        <td>{$sub->request_ip}</td>
                                                        <td>{$sub->location}</td>
                                                        <td>{$sub->request_time}</td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/if}
                    <div class="row row-deck my-3">
                        {if $public_setting['login_log']}
                            <div class="col-md-6 col-sm-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h3 class="card-title">{trans key='profile.recent_logins'}</h3>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-vcenter text-nowrap card-table">
                                            <thead>
                                                <tr>
                                                    <th>IP</th>
                                                    <th>{trans key='profile.location'}</th>
                                                    <th>{trans key='profile.time'}</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {foreach $logins as $login}
                                                    <tr>
                                                        <td>{$login->ip}</td>
                                                        <td>{$login->location}</td>
                                                        <td>{$login->datetime}</td>
                                                    </tr>
                                                {/foreach}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        {/if}
                        <div class="col-md-6 col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">{trans key='profile.online_ips'}</h3>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-vcenter text-nowrap card-table">
                                        <thead>
                                            <tr>
                                                <th>IP</th>
                                                <th>{trans key='profile.location'}</th>
                                                <th>{trans key='profile.node_name'}</th>
                                                <th>{trans key='profile.last_online'}</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            {foreach $ips as $ip}
                                                <tr>
                                                    <td>{$ip->ip}</td>
                                                    <td>{$ip->location}</td>
                                                    <td>{$ip->node_name}</td>
                                                    <td>{$ip->last_time}</td>
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