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
                                <span class="home-title">{trans key='user_pages.home_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='user_pages.home_subtitle'}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-12">
                            <div class="row row-cards">
                                <div class="col-sm-6 col-lg-3">
                                    <div class="card card-sm">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-auto">
                                                    <span class="bg-blue text-white avatar">
                                                        <i class="ti ti-vip icon"></i>
                                                    </span>
                                                </div>
                                                <div class="col">
                                                    <div class="font-weight-medium">
                                                        {trans key='user_pages.account_level'}
                                                    </div>
                                                    <div class="text-secondary">
                                                        {if $user->class === 0}
                                                            {trans key='user_pages.free'}
                                                        {else}
                                                            Lv. {$user->class}
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-lg-3">
                                    <div class="card card-sm">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-auto">
                                                    <span class="bg-green text-white avatar">
                                                        <i class="ti ti-coin icon"></i>
                                                    </span>
                                                </div>
                                                <div class="col">
                                                    <div class="font-weight-medium">
                                                        {trans key='user_pages.account_balance'}
                                                    </div>
                                                    <div class="text-secondary">
                                                        {$user->money}
                                                    </div>
                                                </div>
                                                <div class="col-auto">
                                                    <a href="/user/money" class="btn btn-primary btn-icon">
                                                        <i class="ti ti-plus icon"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-lg-3">
                                    <div class="card card-sm">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-auto">
                                                    <span class="bg-azure text-white avatar">
                                                        <i class="ti ti-devices-pc icon"></i>
                                                    </span>
                                                </div>
                                                <div class="col">
                                                    <div class="font-weight-medium">
                                                        {trans key='user_pages.connection_ip_limit'}
                                                    </div>
                                                    <div class="text-secondary">
                                                        {if $user->node_iplimit !== 0}
                                                            {$user->node_iplimit}
                                                        {else}
                                                            {trans key='shop.unlimited'}
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-lg-3">
                                    <div class="card card-sm">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-auto">
                                                    <span class="bg-indigo text-white avatar">
                                                        <i class="ti ti-rocket icon"></i>
                                                    </span>
                                                </div>
                                                <div class="col">
                                                    <div class="font-weight-medium">
                                                        {trans key='user_pages.speed_limit'}
                                                    </div>
                                                    <div class="text-secondary">
                                                        {if $user->node_speedlimit !== 0}
                                                            <code>{$user->node_speedlimit}</code>
                                                            Mbps
                                                        {else}
                                                            {trans key='shop.unlimited'}
                                                        {/if}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6 col-sm-12">
                            <div class="card">
                                <ul class="nav nav-tabs nav-fill" data-bs-toggle="tabs">
                                    <li class="nav-item">
                                        <a href="#sub" class="nav-link active" data-bs-toggle="tab">
                                            <i class="ti ti-rss icon"></i>
                                            &nbsp;{trans key='user_pages.general_subscription'}
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#client-sub" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-rss icon"></i>
                                            &nbsp;{trans key='user_pages.client_subscription'}
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#windows" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-windows icon"></i>
                                            &nbsp;Windows
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#macos" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-finder icon"></i>
                                            &nbsp;MacOS
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#android" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-android icon"></i>
                                            &nbsp;Android
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#ios" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-apple icon"></i>
                                            &nbsp;iOS
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#linux" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-brand-redhat icon"></i>
                                            &nbsp;Linux
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="#config" class="nav-link" data-bs-toggle="tab">
                                            <i class="ti ti-file-text icon"></i>
                                            &nbsp;Config
                                        </a>
                                    </li>
                                </ul>
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active show" id="sub">
                                            <div>
                                                {if $public_setting.enable_json_sub|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='Json'}:<code
                                                            class="spoiler">{$UniversalSub}/json</code>
                                                    </p>
                                                {/if}
                                                {if $public_setting.enable_clash_sub|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='Clash'}:<code
                                                            class="spoiler">{$UniversalSub}/clash</code>
                                                    </p>
                                                {/if}
                                                {if $public_setting.enable_singbox_sub|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='SingBox'}:<code
                                                            class="spoiler">{$UniversalSub}/singbox</code>
                                                    </p>
                                                {/if}
                                                {if $public_setting.enable_v2rayjson_sub|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='V2Ray Json'}:<code
                                                            class="spoiler">{$UniversalSub}/v2rayjson</code>
                                                    </p>
                                                {/if}
                                                {if $public_setting.enable_ss_sub}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='SIP008'}:<code
                                                            class="spoiler">{$UniversalSub}/sip008</code>
                                                    </p>
                                                {/if}
                                                <div class="btn-list justify-content-start">
                                                    {if $public_setting.enable_json_sub|default:1}
                                                        <a data-clipboard-text="{$UniversalSub}/json"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_subscription' protocol='Json'}
                                                        </a>
                                                    {/if}
                                                    {if $public_setting.enable_clash_sub|default:1}
                                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_subscription' protocol='Clash'}
                                                        </a>
                                                    {/if}
                                                    {if $public_setting.enable_singbox_sub|default:1}
                                                        <a data-clipboard-text="{$UniversalSub}/singbox"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_subscription' protocol='SingBox'}
                                                        </a>
                                                    {/if}
                                                    {if $public_setting.enable_v2rayjson_sub|default:1}
                                                        <a data-clipboard-text="{$UniversalSub}/v2rayjson"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_subscription' protocol='V2Ray Json'}
                                                        </a>
                                                    {/if}
                                                    {if $public_setting.enable_ss_sub}
                                                        <a data-clipboard-text="{$UniversalSub}/sip008"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_subscription' protocol='SIP008'}
                                                        </a>
                                                    {/if}
                                                </div>
                                                {if $public_setting.enable_overtls_sub|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='OverTLS'}:<code
                                                            class="spoiler">{$UniversalSub}/overtls</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a data-clipboard-text="{$UniversalSub}/overtls"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_subscription' protocol='OverTLS'}
                                                        </a>
                                                    </div>
                                                {/if}
                                                {if $public_setting.enable_anytls_sub|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='AnyTLS'}:<code
                                                            class="spoiler">{$UniversalSub}/anytls</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a data-clipboard-text="{$UniversalSub}/anytls"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_subscription' protocol='AnyTLS'}
                                                        </a>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="client-sub">
                                            <div>
                                                {if $public_setting['enable_ss_sub']}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='Shadowsocks'}:<code
                                                            class="spoiler">{$UniversalSub}/ss</code>
                                                    </p>
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='SIP002'}:<code
                                                            class="spoiler">{$UniversalSub}/sip002</code>
                                                    </p>
                                                {/if}
                                                {if $public_setting['enable_v2_sub']}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='V2Ray'}:<code
                                                            class="spoiler">{$UniversalSub}/v2ray</code>
                                                    </p>
                                                {/if}
                                                {if $public_setting['enable_trojan_sub']}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='Trojan'}:<code
                                                            class="spoiler">{$UniversalSub}/trojan</code>
                                                    </p>
                                                {/if}
                                                <div class="btn-list justify-content-start">
                                                    {if $public_setting['enable_ss_sub']}
                                                        <a data-clipboard-text="{$UniversalSub}/ss"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_client_subscription' protocol='Shadowsocks'}
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/sip002"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_client_subscription' protocol='SIP002'}
                                                        </a>
                                                    {/if}
                                                    {if $public_setting['enable_v2_sub']}
                                                        <a data-clipboard-text="{$UniversalSub}/v2ray"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_client_subscription' protocol='V2Ray'}
                                                        </a>
                                                    {/if}
                                                    {if $public_setting['enable_trojan_sub']}
                                                        <a data-clipboard-text="{$UniversalSub}/trojan"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_client_subscription' protocol='Trojan'}
                                                        </a>
                                                    {/if}
                                                </div>
                                                {if $public_setting['enable_overtls_sub']|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='OverTLS'}:<code
                                                            class="spoiler">{$UniversalSub}/overtls</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a data-clipboard-text="{$UniversalSub}/overtls"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_client_subscription' protocol='OverTLS'}
                                                        </a>
                                                    </div>
                                                {/if}
                                                {if $public_setting['enable_anytls_sub']|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='AnyTLS'}:<code
                                                            class="spoiler">{$UniversalSub}/anytls</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a data-clipboard-text="{$UniversalSub}/anytls"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_client_subscription' protocol='AnyTLS'}
                                                        </a>
                                                    </div>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="windows">
                                            <div>
                                                {if $public_setting.enable_clash_sub|default:1}
                                                    <div class="mb-3">
                                                        <p>
                                                            {trans key='user_pages.for_protocol' protocol='Clash'}:<code
                                                                class="spoiler">{$UniversalSub}/clash</code>
                                                        </p>
                                                        <div class="btn-list justify-content-start">
                                                            <a {if $config['enable_r2_client_download']}
                                                                href="/user/clients/Clash.Nyanpasu.exe" {else}
                                                                href="/clients/Clash.Nyanpasu.exe" {/if}
                                                                class="btn btn-azure">
                                                                {trans key='user_pages.download'} Clash Nyanpasu
                                                            </a>
                                                            <a data-clipboard-text="{$UniversalSub}/clash"
                                                                class="copy btn btn-primary">
                                                                {trans key='user_pages.copy_link' protocol='Clash'}
                                                            </a>
                                                            <a href="clash-nyanpasu://subscribe-remote-profile?url={$UniversalSub}&name={$config['appName']}"
                                                                class="btn btn-indigo">
                                                                {trans key='user_pages.import' client='Clash Nyanpasu'}
                                                            </a>
                                                        </div>
                                                    </div>
                                                {/if}
                                                {if $public_setting.enable_singbox_sub|default:1}
                                                    <div class="mb-3">
                                                        <p>
                                                            {trans key='user_pages.for_protocol' protocol='SingBox'}:<code
                                                                class="spoiler">{$UniversalSub}/singbox</code>
                                                        </p>
                                                        <div class="btn-list justify-content-start">
                                                            <a {if $config['enable_r2_client_download']}
                                                                href="/user/clients/Hiddify.exe" {else}
                                                                href="/clients/Hiddify.exe" {/if} class="btn btn-azure">
                                                                {trans key='user_pages.download'} Hiddify
                                                            </a>
                                                            <a data-clipboard-text="{$UniversalSub}/singbox"
                                                                class="copy btn btn-primary">
                                                                {trans key='user_pages.copy_link' protocol='SingBox'}
                                                            </a>
                                                            <a href="hiddify://import/{$UniversalSub}#{$config['appName']}"
                                                                class="btn btn-indigo">
                                                                {trans key='user_pages.import' client='Hiddify'}
                                                            </a>
                                                        </div>
                                                    </div>
                                                {/if}
                                                {if $public_setting['enable_overtls_sub']|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='OverTLS'} <code
                                                            class="spoiler">{$UniversalSub}/overtls</code>
                                                    </p>
                                                    <a data-clipboard-text="{$UniversalSub}/overtls"
                                                        class="copy btn btn-primary">
                                                        {trans key='user_pages.copy_client_subscription' protocol='OverTLS'}
                                                    </a>
                                                {/if}
                                                {if $public_setting['enable_anytls_sub']|default:1}
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='AnyTLS'} <code
                                                            class="spoiler">{$UniversalSub}/anytls</code>
                                                    </p>
                                                    <a data-clipboard-text="{$UniversalSub}/anytls"
                                                        class="copy btn btn-primary">
                                                        {trans key='user_pages.copy_client_subscription' protocol='AnyTLS'}
                                                    </a>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="tab-pane" id="macos">
                                            {if $public_setting.enable_clash_sub|default:1}
                                                <div class="mb-3">
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='Clash'}:<code
                                                            class="spoiler">{$UniversalSub}/clash</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Nyanpasu_aarch64.dmg" {else}
                                                            href="/clients/Clash.Nyanpasu_aarch64.dmg" {/if}
                                                            class="btn btn-azure">
                                                            {trans key='user_pages.download'} Clash Nyanpasu (aarch64)
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='Clash'}
                                                        </a>
                                                        <a href="clash-nyanpasu://subscribe-remote-profile?url={$UniversalSub}&name={$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='Clash Nyanpasu'}
                                                        </a>
                                                    </div>
                                                </div>
                                            {/if}
                                            {if $public_setting.enable_singbox_sub|default:1}
                                                <div class="mb-3">
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='SingBox'}:<code
                                                            class="spoiler">{$UniversalSub}/singbox</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/SFM.zip" {else} href="/clients/SFM.zip"
                                                            {/if} class="btn btn-azure">
                                                            {trans key='user_pages.download'} SFM
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/singbox"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='SingBox'}
                                                        </a>
                                                        <a href="sing-box://import-remote-profile?url={$UniversalSub}/singbox#{$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='SFM'}
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Hiddify.dmg" {else}
                                                            href="/clients/Hiddify.dmg" {/if} class="btn btn-azure">
                                                            {trans key='user_pages.download'} Hiddify
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/singbox"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='SingBox'}
                                                        </a>
                                                        <a href="hiddify://import/{$UniversalSub}#{$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='Hiddify'}
                                                        </a>
                                                    </div>
                                                </div>
                                            {/if}
                                            {if $public_setting['enable_overtls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='OverTLS'} <code
                                                        class="spoiler">{$UniversalSub}/overtls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/overtls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='OverTLS'}
                                                </a>
                                            {/if}
                                            {if $public_setting['enable_anytls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='AnyTLS'} <code
                                                        class="spoiler">{$UniversalSub}/anytls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/anytls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='AnyTLS'}
                                                </a>
                                            {/if}
                                        </div>
                                        <div class="tab-pane" id="android">
                                            {if $public_setting.enable_clash_sub|default:1}
                                                <div class="mb-3">
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='Clash'}:<code
                                                            class="spoiler">{$UniversalSub}/clash</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/CMFA.apk" {else} href="/clients/CMFA.apk"
                                                            {/if} class="btn btn-azure">
                                                            {trans key='user_pages.download'} Clash.Meta For Android
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='Clash'}
                                                        </a>
                                                        <a href="clash://install-config?url={$UniversalSub}/clash&name={$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='Clash'}
                                                        </a>
                                                    </div>
                                                </div>
                                            {/if}
                                            {if $public_setting.enable_singbox_sub|default:1}
                                                <div class="mb-3">
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='SingBox'}:<code
                                                            class="spoiler">{$UniversalSub}/singbox</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/SFA.apk" {else} href="/clients/SFA.apk"
                                                            {/if} class="btn btn-azure">
                                                            {trans key='user_pages.download'} SFA
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/singbox"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='SingBox'}
                                                        </a>
                                                        <a href="sing-box://import-remote-profile?url={$UniversalSub}/singbox#{$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='SFA'}
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Hiddify.apk" {else}
                                                            href="/clients/Hiddify.apk" {/if} class="btn btn-azure">
                                                            {trans key='user_pages.download'} Hiddify
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/singbox"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='SingBox'}
                                                        </a>
                                                        <a href="hiddify://import/{$UniversalSub}#{$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='Hiddify'}
                                                        </a>
                                                    </div>
                                                </div>
                                            {/if}
                                            {if $public_setting['enable_overtls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='OverTLS'} <code
                                                        class="spoiler">{$UniversalSub}/overtls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/overtls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='OverTLS'}
                                                </a>
                                            {/if}
                                            {if $public_setting['enable_anytls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='AnyTLS'} <code
                                                        class="spoiler">{$UniversalSub}/anytls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/anytls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='AnyTLS'}
                                                </a>
                                            {/if}
                                        </div>
                                        <div class="tab-pane" id="ios">
                                            {if $public_setting.enable_singbox_sub|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='SingBox'}:<code
                                                        class="spoiler">{$UniversalSub}/singbox</code>
                                                </p>
                                                <div class="btn-list justify-content-start">
                                                    <a href="https://apps.apple.com/app/sing-box/id6451272673"
                                                        target="_blank" class="btn btn-azure">
                                                        {trans key='user_pages.install' client='SFI'}
                                                    </a>
                                                    <a data-clipboard-text="{$UniversalSub}/singbox"
                                                        class="copy btn btn-primary">
                                                        {trans key='user_pages.copy_link' protocol='SingBox'}
                                                    </a>
                                                    <a href="sing-box://import-remote-profile?url={$UniversalSub}/singbox#{$config['appName']}"
                                                        class="btn btn-indigo">
                                                        {trans key='user_pages.import' client='SFI'}
                                                    </a>
                                                </div>
                                            {/if}
                                            {if $public_setting['enable_overtls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='OverTLS'} <code
                                                        class="spoiler">{$UniversalSub}/overtls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/overtls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='OverTLS'}
                                                </a>
                                            {/if}
                                            {if $public_setting['enable_anytls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='AnyTLS'} <code
                                                        class="spoiler">{$UniversalSub}/anytls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/anytls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='AnyTLS'}
                                                </a>
                                            {/if}
                                        </div>
                                        <div class="tab-pane" id="linux">
                                            {if $public_setting.enable_clash_sub|default:1}
                                                <div class="mb-3">
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='Clash'}:<code
                                                            class="spoiler">{$UniversalSub}/clash</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Clash.Nyanpasu.AppImage" {else}
                                                            href="/clients/Clash.Nyanpasu.AppImage" {/if}
                                                            class="btn btn-azure">
                                                            {trans key='user_pages.download'} Clash Nyanpasu
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/clash"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='Clash'}
                                                        </a>
                                                        <a href="clash-nyanpasu://subscribe-remote-profile?url={$UniversalSub}&name={$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='Clash Nyanpasu'}
                                                        </a>
                                                    </div>
                                                </div>
                                            {/if}
                                            {if $public_setting.enable_singbox_sub|default:1}
                                                <div class="mb-3">
                                                    <p>
                                                        {trans key='user_pages.for_protocol' protocol='SingBox'}:<code
                                                            class="spoiler">{$UniversalSub}/singbox</code>
                                                    </p>
                                                    <div class="btn-list justify-content-start">
                                                        <a {if $config['enable_r2_client_download']}
                                                            href="/user/clients/Hiddify.AppImage" {else}
                                                            href="/clients/Hiddify.AppImage" {/if} class="btn btn-azure">
                                                            {trans key='user_pages.download'} Hiddify
                                                        </a>
                                                        <a data-clipboard-text="{$UniversalSub}/singbox"
                                                            class="copy btn btn-primary">
                                                            {trans key='user_pages.copy_link' protocol='SingBox'}
                                                        </a>
                                                        <a href="hiddify://import/{$UniversalSub}#{$config['appName']}"
                                                            class="btn btn-indigo">
                                                            {trans key='user_pages.import' client='Hiddify'}
                                                        </a>
                                                    </div>
                                                </div>
                                            {/if}
                                            {if $public_setting['enable_overtls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='OverTLS'} <code
                                                        class="spoiler">{$UniversalSub}/overtls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/overtls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='OverTLS'}
                                                </a>
                                            {/if}
                                            {if $public_setting['enable_anytls_sub']|default:1}
                                                <p>
                                                    {trans key='user_pages.for_protocol' protocol='AnyTLS'} <code
                                                        class="spoiler">{$UniversalSub}/anytls</code>
                                                </p>
                                                <a data-clipboard-text="{$UniversalSub}/anytls"
                                                    class="copy btn btn-primary">
                                                    {trans key='user_pages.copy_client_subscription' protocol='AnyTLS'}
                                                </a>
                                            {/if}
                                        </div>
                                        <div class="tab-pane" id="config">
                                            <p>{trans key='user_pages.connection_information'}:</p>
                                            <div class="table-responsive">
                                                <table class="table table-vcenter card-table">
                                                    <tbody>
                                                        <tr>
                                                            <td><strong>{trans key='user_pages.port'}</strong></td>
                                                            <td>{$user->port}</td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>{trans key='user_pages.connection_password'}</strong>
                                                            </td>
                                                            <td><span class="spoiler">{$user->passwd}</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>UUID</strong></td>
                                                            <td><span class="spoiler">{$user->uuid}</span></td>
                                                        </tr>
                                                        <tr>
                                                            <td><strong>{trans key='user_pages.custom_encryption'}</strong>
                                                            </td>
                                                            <td>{$user->method}</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6 col-sm-12">
                            <div class="vstack">
                                <div class="card">
                                    <div class="card-body">
                                        <h3 class="card-title">{trans key='user_pages.traffic_usage'}</h3>
                                        <div class="progress progress-separated mb-3">
                                            {if $user->LastusedTrafficPercent() < '1'}
                                                <div class="progress-bar bg-primary" role="progressbar" style="width: 1%">
                                                </div>
                                            {else}
                                                <div class="progress-bar bg-primary" role="progressbar"
                                                    style="width: {$user->LastusedTrafficPercent()}%">
                                                </div>
                                            {/if}
                                            {if $user->TodayusedTrafficPercent() < '1'}
                                                <div class="progress-bar bg-success" role="progressbar" style="width: 1%">
                                                </div>
                                            {else}
                                                <div class="progress-bar bg-success" role="progressbar"
                                                    style="width: {$user->TodayusedTrafficPercent()}%"></div>
                                            {/if}
                                        </div>
                                        <div class="row">
                                            <div class="col-auto d-flex align-items-center pe-2">
                                                <span class="legend me-2 bg-primary"></span>
                                                <span>{trans key='user_pages.past_usage'}
                                                    {$user->LastusedTraffic()}</span>
                                            </div>
                                            <div class="col-auto d-flex align-items-center px-2">
                                                <span class="legend me-2 bg-success"></span>
                                                <span>{trans key='user_pages.today_usage'}
                                                    {$user->TodayusedTraffic()}</span>
                                            </div>
                                            <div class="col-auto d-flex align-items-center ps-2">
                                                <span class="legend me-2"></span>
                                                <span>{trans key='user_pages.remaining_traffic'}
                                                    {$user->unusedTraffic()}</span>
                                            </div>
                                        </div>
                                        <p class="my-3">
                                            {if $user->class === 0}
                                                {trans key='user_pages.go_to'}
                                                <a href="/user/product">{trans key='user_pages.store'}</a>
                                                {trans key='user_pages.purchase_plan'}
                                            {else}
                                                {trans key='user_pages.account_expiry' class=$user->class days=$class_expire_days date=$user->class_expire}
                                            {/if}
                                        </p>
                                    </div>
                                </div>
                                {if $public_setting['traffic_log']}
                                    <div class="card my-3 mb-0">
                                        <div class="card-body">
                                            <h3 class="card-title">{trans key='user_pages.hourly_usage'}</h3>
                                            <div id="traffic-log"></div>
                                        </div>
                                    </div>
                                {/if}
                                <div class="card mt-3 mb-0">
                                    <div class="card-body">
                                        <h3 class="card-title">{trans key='settings.language'}</h3>
                                        <div class="d-flex align-items-center gap-2">
                                            <select id="user-locale" class="form-select flex-grow-1 w-auto">
                                                {foreach $locale_options as $locale_option}
                                                    <option value="{$locale_option['code']}"
                                                        {if $user->locale === $locale_option['code']}selected{/if}>
                                                        {$locale_option['name']}
                                                    </option>
                                                {/foreach}
                                            </select>
                                            <button class="btn btn-primary flex-shrink-0"
                                                hx-post="/user/edit/locale" hx-swap="none"
                                                hx-vals='js:{ locale: document.getElementById("user-locale").value }'>
                                                {trans key='settings.update'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {if $public_setting['enable_checkin']}
                            <div class="col-lg-6 col-sm-12">
                                <div class="card">
                                    <div class="card-stamp">
                                        <div class="card-stamp-icon bg-green">
                                            <i class="ti ti-check"></i>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <h3 class="card-title">{trans key='user_pages.daily_checkin'}</h3>
                                        <p>
                                            {trans key='user_pages.checkin_reward_range'}
                                            {if $public_setting['checkin_min'] !== $public_setting['checkin_max']}
                                                &nbsp;
                                                <code>{$public_setting['checkin_min']} MB</code>
                                                {trans key='user_pages.to'}
                                                <code>{$public_setting['checkin_max']} MB</code>
                                                {trans key='user_pages.traffic'}
                                            {else}
                                                <code>{$public_setting['checkin_min']} MB</code>
                                            {/if}
                                        </p>
                                        <p>
                                            {trans key='user_pages.last_checkin'} <code
                                                id="last-checkin-time">{$user->lastCheckInTime()}</code>
                                        </p>
                                    </div>
                                    <div class="card-footer">
                                        <div class="d-flex">
                                            {if ! $user->isAbleToCheckin()}
                                                <button id="check-in" class="btn btn-primary ms-auto"
                                                    disabled>{trans key='user_pages.checked_in'}</button>
                                            {else}
                                                {if $public_setting['enable_checkin_captcha']}
                                                    {include file='captcha/div.tpl'}
                                                {/if}
                                                <button id="check-in" class="btn btn-primary ms-auto" hx-post="/user/checkin"
                                                    hx-swap="none" hx-vals='js:{
                                    {if $public_setting['enable_checkin_captcha']}
                                    {include file='captcha/ajax.tpl'}
                                    {/if}
                                    }'>
                                                    {trans key='user_pages.checkin'}
                                                </button>
                                            {/if}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        {/if}
                        <div class="col-lg-6 col-sm-12">
                            <div class="card">
                                <div class="ribbon ribbon-top bg-yellow">
                                    <i class="ti ti-bell-ringing icon"></i>
                                </div>
                                <div class="card-body">
                                    <h3 class="card-title">
                                        {trans key='user_pages.pinned_announcement'}
                                        {if $ann !== null}
                                            <span class="card-subtitle">{$ann->date}</span>
                                        {/if}
                                    </h3>
                                    <p class="text-secondary">
                                        {if $ann !== null}
                                            {$ann->content}
                                        {else}
                                            {trans key='user_pages.no_announcements'}
                                        {/if}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {if $public_setting['enable_checkin_captcha'] && $user->isAbleToCheckin()}
                {include file='captcha/js.tpl'}
            {/if}

            {if $public_setting['traffic_log']}
                <script>
                    document.addEventListener("DOMContentLoaded", function() {
                        let chart = window.ApexCharts && new ApexCharts(document.getElementById('traffic-log'), {
                            chart: {
                                type: "line",
                                fontFamily: "inherit",
                                height: '100%',
                                parentHeightOffset: 0,
                                toolbar: {
                                    show: false
                                },
                                animations: {
                                    enabled: false
                                }
                            },
                            stroke: {
                                curve: "smooth"
                            },
                            fill: {
                                opacity: 1
                            },
                            series: [{
                                name: "{trans key='user_pages.traffic_mb'}",
                                data: {$traffic_logs}
                            }],
                            tooltip: {
                                theme: "dark"
                            },
                            grid: {
                                padding: {
                                    top: -20,
                                    right: 0,
                                    left: 0,
                                    bottom: 0
                                },
                                strokeDashArray: 4
                            },
                            xaxis: {
                                title: {
                                    text: "{trans key='user_pages.hour_unit'}"
                                },
                                labels: {
                                    padding: 0
                                },
                                tooltip: {
                                    enabled: false
                                },
                                axisBorder: {
                                    show: false
                                },
                                categories: [
                                    "00",
                                    "01",
                                    "02",
                                    "03",
                                    "04",
                                    "05",
                                    "06",
                                    "07",
                                    "08",
                                    "09",
                                    "10",
                                    "11",
                                    "12",
                                    "13",
                                    "14",
                                    "15",
                                    "16",
                                    "17",
                                    "18",
                                    "19",
                                    "20",
                                    "21",
                                    "22",
                                    "23"
                                ]
                            },
                            yaxis: {
                                title: {
                                    text: "{trans key='user_pages.traffic_mb'}",
                                    rotate: -90
                                },
                                labels: {
                                    padding: 14
                                }
                            },
                            colors: [tabler.getColor("azure")],
                            legend: {
                                show: false
                            }
                        });
                        chart.render();
                    });
                </script>

                <script
                    src="https://{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/libs/apexcharts/dist/apexcharts.min.js">
                </script>
            {/if}

            {include file='user/footer.tpl'}

            {include file='copy-to-clipboard.tpl'}
        </div>
    </div>

    {include file="user/footer-scripts.tpl"}

    {include file='live_chat.tpl'}

</body>

</html>