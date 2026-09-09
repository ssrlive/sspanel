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
                                <span class="home-title">{trans key='shop.products_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='shop.products_subtitle'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-cards">
                        <div class="col-12">
                            <div class="card">
                                <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs">
                                    <li class="nav-item">
                                        <a href="#tabp" class="nav-link active" data-bs-toggle="tab">
                                            <i class="ti ti-rotate-360 icon"></i>
                                            &nbsp;{trans key='shop.time_traffic'}
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#bandwidth" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-arrows-down-up icon"></i>
                                            &nbsp;{trans key='shop.traffic'}
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#time" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-clock icon"></i>
                                            &nbsp;{trans key='shop.time'}
                                        </a>
                                    </li>
                                </ul>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="tabp">
                                            <div class="row">
                                                {foreach $tabps as $tabp}
                                                    <div class="col-md-3 col-sm-12 my-3">
                                                        <div class="card card-md">
                                                            <div class="card-body text-center">
                                                                <div id="product-{$tabp->id}-name"
                                                                    class="text-uppercase text-secondary font-weight-medium">
                                                                    {$tabp->name}</div>
                                                                <div id="product-{$tabp->id}-price" class="display-6 my-3">
                                                                    <p class="fw-bold">{$tabp->price}</p>
                                                                    <i class="ti ti-currency-yuan"></i>
                                                                </div>
                                                                <div class="list-group list-group-flush">
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                <div class="text-reset d-block">
                                                                                    Lv. {$tabp->content->class}</div>
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.level'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                <div class="text-reset d-block">
                                                                                    {$tabp->content->class_time}
                                                                                    {trans key='shop.days'}
                                                                                </div>
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.level_duration'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                <div class="text-reset d-block">
                                                                                    {$tabp->content->bandwidth}
                                                                                    GB
                                                                                </div>
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.available_traffic'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                {if $tabp->content->speed_limit === '0'}
                                                                                    <div class="text-reset d-block">
                                                                                        {trans key='shop.unlimited'}</div>
                                                                                {else}
                                                                                    <div class="text-reset d-block">
                                                                                        {$tabp->content->speed_limit}
                                                                                        Mbps
                                                                                    </div>
                                                                                {/if}
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.connection_speed'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                {if $tabp->content->ip_limit === '0'}
                                                                                    <div class="text-reset d-block">
                                                                                        {trans key='shop.unlimited'}</div>
                                                                                {else}
                                                                                    <div class="text-reset d-block">
                                                                                        {$tabp->content->ip_limit}</div>
                                                                                {/if}
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.connection_ips'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row g-2">
                                                                    {if $tabp->stock !== 0}
                                                                        <div class="col">
                                                                            <a href="/user/order/create?product_id={$tabp->id}"
                                                                                class="btn btn-primary w-100 my-3">{trans key='shop.buy'}</a>
                                                                        </div>
                                                                    {else}
                                                                        <div class="col">
                                                                            <a href="" class="btn btn-primary w-100 my-3"
                                                                                disabled>{trans key='shop.sold_out'}</a>
                                                                        </div>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                {/foreach}
                                            </div>
                                        </div>
                                        <div class="tab-pane show" id="bandwidth">
                                            <div class="row">
                                                {foreach $bandwidths as $bandwidth}
                                                    <div class="col-md-3 col-sm-12 my-3">
                                                        <div class="card card-md">
                                                            <div class="card-body text-center">
                                                                <div id="product-{$bandwidth->id}-name"
                                                                    class="text-uppercase text-secondary font-weight-medium">
                                                                    {$bandwidth->name}</div>
                                                                <div id="product-{$bandwidth->id}-price"
                                                                    class="display-6 my-3">
                                                                    <p class="fw-bold">{$bandwidth->price}</p>
                                                                    <i class="ti ti-currency-yuan"></i>
                                                                </div>
                                                                <div class="list-group list-group-flush">
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                <div class="text-reset d-block">
                                                                                    {$bandwidth->content->bandwidth}
                                                                                    GB
                                                                                </div>
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.available_traffic'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row g-2">
                                                                    {if $bandwidth->stock !== 0}
                                                                        <div class="col">
                                                                            <a href="/user/order/create?product_id={$bandwidth->id}"
                                                                                class="btn btn-primary w-100 my-3">{trans key='shop.buy'}</a>
                                                                        </div>
                                                                    {else}
                                                                        <div class="col">
                                                                            <a href="" class="btn btn-primary w-100 my-3"
                                                                                disabled>{trans key='shop.sold_out'}</a>
                                                                        </div>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                {/foreach}
                                            </div>
                                        </div>
                                        <div class="tab-pane show" id="time">
                                            <div class="row">
                                                {foreach $times as $time}
                                                    <div class="col-md-3 col-sm-12 my-3">
                                                        <div class="card card-md">
                                                            <div class="card-body text-center">
                                                                <div id="product-{$time->id}-name"
                                                                    class="text-uppercase text-secondary font-weight-medium">
                                                                    {$time->name}
                                                                </div>
                                                                <div id="product-{$time->id}-price" class="display-6 my-3">
                                                                    <p class="fw-bold">{$time->price}</p>
                                                                    <i class="ti ti-currency-yuan"></i>
                                                                </div>
                                                                <div class="list-group list-group-flush">
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                <div class="text-reset d-block">
                                                                                    Lv. {$time->content->class}</div>
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.level'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                <div class="text-reset d-block">
                                                                                    {$time->content->class_time}
                                                                                    {trans key='shop.days'}
                                                                                </div>
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.level_duration'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                {if $time->content->speed_limit === '0'}
                                                                                    <div class="text-reset d-block">
                                                                                        {trans key='shop.unlimited'}</div>
                                                                                {else}
                                                                                    <div class="text-reset d-block">
                                                                                        {$time->content->speed_limit}
                                                                                        Mbps
                                                                                    </div>
                                                                                {/if}
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.connection_speed'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="list-group-item">
                                                                        <div class="row align-items-center">
                                                                            <div class="col text-truncate">
                                                                                {if $time->content->ip_limit === '0'}
                                                                                    <div class="text-reset d-block">
                                                                                        {trans key='shop.unlimited'}</div>
                                                                                {else}
                                                                                    <div class="text-reset d-block">
                                                                                        {$time->content->ip_limit}</div>
                                                                                {/if}
                                                                                <div
                                                                                    class="d-block text-secondary text-truncate mt-n1">
                                                                                    {trans key='shop.connection_ips'}
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row g-2">
                                                                    {if $time->stock !== 0}
                                                                        <div class="col">
                                                                            <a href="/user/order/create?product_id={$time->id}"
                                                                                class="btn btn-primary w-100 my-3">{trans key='shop.buy'}</a>
                                                                        </div>
                                                                    {else}
                                                                        <div class="col">
                                                                            <a href="" class="btn btn-primary w-100 my-3"
                                                                                disabled>{trans key='shop.sold_out'}</a>
                                                                        </div>
                                                                    {/if}
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                {/foreach}
                                            </div>
                                        </div>
                                    </div>
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