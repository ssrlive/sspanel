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
                                <span class="home-title">{trans key='shop.create_order_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='shop.create_order_subtitle'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-cards">
                        <div class="col-sm-12 col-md-6 col-lg-9">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">{trans key='shop.order_content'}</h3>
                                </div>
                                <div class="card-body">
                                    <table class="table table-transparent table-responsive">
                                        <tr hidden>
                                            <td>{trans key='shop.product_id'}</td>
                                            <td id="product-id" class="text-end">{$product->id}</td>
                                        </tr>
                                        <tr>
                                            <td>{trans key='shop.product_name'}</td>
                                            <td class="text-end">{$product->name}</td>
                                        </tr>
                                        <tr>
                                            <td>{trans key='shop.product_type'}</td>
                                            <td class="text-end">{$product->type_text}</td>
                                        </tr>
                                        {if $product->type === 'tabp' || $product->type === 'time'}
                                            <tr>
                                                <td>{trans key='shop.product_duration'}</td>
                                                <td class="text-end">{$product->content->time} {trans key='shop.days'}</td>
                                            </tr>
                                            <tr>
                                                <td>{trans key='shop.level_duration'}</td>
                                                <td class="text-end">{$product->content->class_time} {trans key='shop.days'}
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>{trans key='shop.level'}</td>
                                                <td class="text-end">Lv. {$product->content->class}</td>
                                            </tr>
                                        {/if}
                                        {if $product->type === 'tabp' || $product->type === 'bandwidth'}
                                            <tr>
                                                <td>{trans key='shop.available_traffic'}</td>
                                                <td class="text-end">{$product->content->bandwidth} GB</td>
                                            </tr>
                                        {/if}
                                        {if $product->type === 'tabp' || $product->type === 'time'}
                                            <tr>
                                                <td>{trans key='shop.connection_speed'}</td>
                                                {if $product->content->speed_limit === '0'}
                                                    <td class="text-end">{trans key='shop.unlimited'}</td>
                                                {else}
                                                    <td class="text-end">{$product->content->speed_limit} Mbps</td>
                                                {/if}
                                            </tr>
                                            <tr>
                                                <td>{trans key='shop.connection_ips'}</td>
                                                {if $product->content->ip_limit === '0'}
                                                    <td class="text-end">{trans key='shop.unlimited'}</td>
                                                {else}
                                                    <td class="text-end">{$product->content->ip_limit}</td>
                                                {/if}
                                            </tr>
                                        {/if}
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-12 col-md-6 col-lg-3">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">{trans key='shop.price_details'}</h3>
                                </div>
                                <div class="card-body">
                                    <table class="table table-transparent table-responsive">
                                        <tr>
                                            <td>{trans key='shop.product_price'}</td>
                                            <td class="text-end">{$product->price}</td>
                                        </tr>
                                        <tr>
                                            <td>{trans key='shop.coupon'}</td>
                                            <td class="text-end" id="coupon-code"></td>
                                        </tr>
                                        <tr>
                                            <td>{trans key='shop.discount'}</td>
                                            <td class="text-end" id="product-buy-discount"></td>
                                        </tr>
                                        <tr>
                                            <td>{trans key='shop.amount_paid'}</td>
                                            <td class="text-end" id="product-buy-total">{$product->price}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="card my-3">
                                <div class="card-header">
                                    <h3 class="card-title">{trans key='shop.coupon'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <div class="input-group mb-2">
                                            <input id="coupon" type="text" class="form-control"
                                                placeholder="{trans key='shop.coupon_placeholder'}">
                                            <button class="btn" type="button" hx-post="/user/coupon" hx-swap="none"
                                                hx-vals='js:{
                                                coupon: document.getElementById("coupon").value,
                                                product_id: {$product->id},
                                            }'>
                                                {trans key='shop.apply'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="card my-3">
                                <div class="card-body">
                                    <button class="btn btn-primary w-100 my-3" hx-post="/user/order/create"
                                        hx-swap="none" hx-vals='js:{
                                        type: "product",
                                        coupon: document.getElementById("coupon").value,
                                        product_id: {$product->id},
                                    }'>
                                        {trans key='shop.create_order'}
                                    </button>
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