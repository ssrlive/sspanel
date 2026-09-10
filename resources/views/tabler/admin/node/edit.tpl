<!doctype html>
<html lang="{$user->locale}"
    data-bs-theme="{$user->is_dark_mode === 1 ? 'dark' : ($user->is_dark_mode === 2 ? 'auto' : 'light')}">

{include file="admin/header.tpl"}

<body {if $user->is_dark_mode === 1}data-bs-theme="dark" {elseif $user->is_dark_mode === 2}data-bs-theme="auto" {/if}>
    <div class="page">
        {include file='admin/body-prefix.tpl'}

        <script src="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.js"></script>
        <link href="//{$config['jsdelivr_url']}/npm/jsoneditor@latest/dist/jsoneditor.min.css" rel="stylesheet"
            type="text/css">

        <div class="page-wrapper">
            <div class="container-xl">
                <div class="page-header d-print-none text-white">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">
                                <span class="home-title">{trans key='admin.node.form.edit_title'} #{$node->id}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.node.form.edit_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="save-node" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.node.form.save'}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-md-6 col-sm-12">
                            <div class="card">
                                <div class="card-header card-header-light">
                                    <h3 class="card-title">{trans key='admin.node.form.basic_info'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.name'}</label>
                                        <div class="col">
                                            <input id="name" type="text" class="form-control" value="{$node->name}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.server'}</label>
                                        <div class="col">
                                            <input id="server" type="text" class="form-control" value="{$node->server}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.traffic_rate'}</label>
                                        <div class="col">
                                            <input id="traffic_rate" type="text" class="form-control"
                                                value="{$node->traffic_rate}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.type'}</label>
                                        <div class="col">
                                            <select id="sort" class="col form-select" value="{$node->sort}">
                                                <option value="14" {if $node->sort === 14}selected{/if}>Trojan</option>
                                                <option value="11" {if $node->sort === 11}selected{/if}>Vmess</option>
                                                <option value="2" {if $node->sort === 2}selected{/if}>TUIC</option>
                                                <option value="4" {if $node->sort === 4}selected{/if}>OverTLS</option>
                                                <option value="5" {if $node->sort === 5}selected{/if}>AnyTLS</option>
                                                <option value="1" {if $node->sort === 1}selected{/if}>Shadowsocks2022
                                                </option>
                                                <option value="0" {if $node->sort === 0}selected{/if}>Shadowsocks
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.custom_config'}</label>
                                        <div id="custom_config"></div>
                                        <label class="form-label col-form-label">
                                            {trans key='admin.node.form.custom_config_help_before'}
                                            <a href="//wiki.sspanel.org/#/custom-config" target="_blank">
                                                wiki.sspanel.org/#/custom-config
                                            </a>
                                            {trans key='admin.node.form.custom_config_help_after'}
                                        </label>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <span class="col">{trans key='admin.node.form.visible'}</span>
                                        <span class="col-auto">
                                            <label class="form-check form-check-single form-switch">
                                                <input id="type" class="form-check-input" type="checkbox"
                                                    {if $node->type}checked="" {/if}>
                                            </label>
                                        </span>
                                    </div>
                                    <div class="hr-text">
                                        <span>{trans key='admin.node.form.dynamic_rate_section'}</span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <span class="col">{trans key='admin.node.form.enable_dynamic_rate'}</span>
                                        <span class="col-auto">
                                            <label class="form-check form-check-single form-switch">
                                                <input id="is_dynamic_rate" class="form-check-input" type="checkbox"
                                                    {if $node->is_dynamic_rate}checked="" {/if}>
                                            </label>
                                        </span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.dynamic_rate_type'}</label>
                                        <div class="col">
                                            <select id="dynamic_rate_type" class="col form-select"
                                                value="{$node->dynamic_rate_type}">
                                                <option value="0" {if $node->dynamic_rate_type === 0}selected{/if}>
                                                    Logistic
                                                </option>
                                                <option value="1" {if $node->dynamic_rate_type === 1}selected{/if}>
                                                    Linear
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.max_rate'}</label>
                                        <div class="col">
                                            <input id="max_rate" type="text" class="form-control"
                                                value="{$node->max_rate}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.max_rate_time'}</label>
                                        <div class="col">
                                            <input id="max_rate_time" type="text" class="form-control"
                                                value="{$node->max_rate_time}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.min_rate'}</label>
                                        <div class="col">
                                            <input id="min_rate" type="text" class="form-control"
                                                value="{$node->min_rate}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.min_rate_time'}</label>
                                        <div class="col">
                                            <input id="min_rate_time" type="text" class="form-control"
                                                value="{$node->min_rate_time}">
                                        </div>
                                        <label class="form-label col-form-label">
                                            {trans key='admin.node.form.rate_time_help'}
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-sm-12">
                            <div class="card">
                                <div class="card-header card-header-light">
                                    <h3 class="card-title">{trans key='admin.node.form.other_info'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.class'}</label>
                                        <div class="col">
                                            <input id="node_class" type="text" class="form-control"
                                                value="{$node->node_class}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.group'}</label>
                                        <div class="col">
                                            <input id="node_group" type="text" class="form-control"
                                                value="{$node->node_group}">
                                        </div>
                                    </div>
                                    <div class="hr-text">
                                        <span>{trans key='admin.node.form.traffic_section'}</span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.bandwidth_used'}</label>
                                        <div class="col">
                                            <input id="node_bandwidth" type="text" class="form-control"
                                                value="{$node->node_bandwidth}" disabled="">
                                        </div>
                                        <div class="col-auto">
                                            <button id="reset-bandwidth"
                                                class="btn btn-red">{trans key='admin.node.form.reset'}</button>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.bandwidth_limit'}</label>
                                        <div class="col">
                                            <input id="node_bandwidth_limit" type="text" class="form-control"
                                                value="{$node->node_bandwidth_limit}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.reset_day'}</label>
                                        <div class="col">
                                            <input id="bandwidthlimit_resetday" type="text" class="form-control"
                                                value="{$node->bandwidthlimit_resetday}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.speed_limit'}</label>
                                        <div class="col">
                                            <input id="node_speedlimit" type="text" class="form-control"
                                                value="{$node->node_speedlimit}">
                                        </div>
                                    </div>
                                    <div class="hr-text">
                                        <span>{trans key='admin.node.form.advanced_options'}</span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.password'}</label>
                                        <input type="text" class="form-control" id="password" value="{$node->password}"
                                            disabled="">
                                        <div class="row my-3">
                                            <div class="col">
                                                <button id="reset-password"
                                                    class="btn btn-red">{trans key='admin.node.form.reset'}</button>
                                                <button id="copy-password" class="copy btn btn-primary"
                                                    data-clipboard-text="{$node->password}">
                                                    {trans key='admin.node.form.copy'}
                                                </button>
                                            </div>
                                        </div>
                                        <label class="form-label col-form-label">
                                            {trans key='admin.node.form.password_help'}
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            const container = document.getElementById('custom_config');
            let options = {
                modes: ['code', 'tree'],
            };
            const editor = new JSONEditor(container, options);
            editor.set({$node->custom_config})

            $("#reset-bandwidth").click(function() {
                $.ajax({
                    url: '/admin/node/{$node->id}/reset_bandwidth',
                    type: 'POST',
                    dataType: "json",
                    success: function(data) {
                        if (data.ret === 1) {
                            if (data.data && typeof data.data.node_bandwidth !== 'undefined') {
                                $('#node_bandwidth').val(data.data.node_bandwidth);
                            }
                            $('#success-message').text(data.msg);
                            $('#success-dialog').modal('show');
                        } else {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                })
            });

            $("#reset-password").click(function() {
                $.ajax({
                    url: '/admin/node/{$node->id}/reset_password',
                    type: 'POST',
                    dataType: "json",
                    success: function(data) {
                        if (data.ret === 1) {
                            if (data.data && typeof data.data.password !== 'undefined') {
                                $('#password').val(data.data.password);
                                $('#copy-password').attr('data-clipboard-text', data.data.password);
                            }
                            $('#success-message').text(data.msg);
                            $('#success-dialog').modal('show');
                        } else {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                })
            });

            $("#save-node").click(function() {
                $.ajax({
                    url: '/admin/node/{$node->id}',
                    type: 'PUT',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                            {$key}: $('#{$key}').val(),
                        {/foreach}
                        type: $("#type").is(":checked"),
                        is_dynamic_rate: $("#is_dynamic_rate").is(":checked"),
                        custom_config: JSON.stringify(editor.get()),
                    },
                    success: function(data) {
                        if (data.ret === 1) {
                            $('#success-message').text(data.msg);
                            $('#success-dialog').modal('show');
                            window.setTimeout("location.href=top.document.referrer", {$config['jump_delay']});
                        } else {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                })
            });
        </script>

        {include file='admin/footer.tpl'}

        {include file='copy-to-clipboard.tpl'}
    </div>

    {include file='admin/footer-scripts.tpl'}
</body>

</html>