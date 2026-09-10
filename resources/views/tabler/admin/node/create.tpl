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
                                <span class="home-title">{trans key='admin.node.form.create_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.node.form.create_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a id="create-node" href="#" class="btn btn-primary">
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
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.name'}</label>
                                        <div class="col">
                                            <input id="name" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.server'}</label>
                                        <div class="col">
                                            <input id="server" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.traffic_rate'}</label>
                                        <div class="col">
                                            <input id="traffic_rate" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.type'}</label>
                                        <div class="col">
                                            <select id="sort" class="col form-select">
                                                <option value="14">Trojan</option>
                                                <option value="11">Vmess</option>
                                                <option value="2">TUIC</option>
                                                <option value="4">OverTLS</option>
                                                <option value="5">AnyTLS</option>
                                                <option value="1">Shadowsocks2022</option>
                                                <option value="0">Shadowsocks</option>
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
                                                <input id="type" class="form-check-input" type="checkbox" checked="">
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
                                                    checked="">
                                            </label>
                                        </span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.dynamic_rate_type'}</label>
                                        <div class="col">
                                            <select id="dynamic_rate_type" class="col form-select">
                                                <option value="0">Logistic</option>
                                                <option value="1">Linear</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.max_rate'}</label>
                                        <div class="col">
                                            <input id="max_rate" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.max_rate_time'}</label>
                                        <div class="col">
                                            <input id="max_rate_time" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.min_rate'}</label>
                                        <div class="col">
                                            <input id="min_rate" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.node.form.min_rate_time'}</label>
                                        <div class="col">
                                            <input id="min_rate_time" type="text" class="form-control" value="">
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
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.class'}</label>
                                        <div class="col">
                                            <input id="node_class" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.group'}</label>
                                        <div class="col">
                                            <input id="node_group" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="hr-text">
                                        <span>{trans key='admin.node.form.traffic_section'}</span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.bandwidth_limit'}</label>
                                        <div class="col">
                                            <input id="node_bandwidth_limit" type="text" class="form-control" value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.reset_day'}</label>
                                        <div class="col">
                                            <input id="bandwidthlimit_resetday" type="text" class="form-control"
                                                value="">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label required">{trans key='admin.node.form.speed_limit'}</label>
                                        <div class="col">
                                            <input id="node_speedlimit" type="text" class="form-control" value="">
                                        </div>
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

            $("#create-node").click(function() {
                $.ajax({
                    url: '/admin/node',
                    type: 'POST',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                            {$key}: $('#{$key}').val(),
                        {/foreach}
                        type: $("#type").is(":checked"),
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
    </div>

    {include file='admin/footer-scripts.tpl'}
</body>

</html>