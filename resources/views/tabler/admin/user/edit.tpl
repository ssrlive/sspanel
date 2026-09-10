<!doctype html>
<html lang="{$user->locale}"
    data-bs-theme="{$user->is_dark_mode === 1 ? 'dark' : ($user->is_dark_mode === 2 ? 'auto' : 'light')}">

{include file="admin/header.tpl"}

<body {if $user->is_dark_mode === 1}data-bs-theme="dark" {elseif $user->is_dark_mode === 2}data-bs-theme="auto" {/if}>
    <div class="page">
        {include file='admin/body-prefix.tpl'}

        <div class="page-wrapper">
            <div class="container-xl">
                <div class="page-header d-print-none text-white">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">
                                <span class="home-title">{trans key='admin.user.user_number' id=$edit_user->id}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.user.edit_title'}</span>
                            </div>
                        </div>
                        <div class="col-auto">
                            <div class="btn-list">
                                <a id="save_changes" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.user.save'}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-deck row-cards">
                        <div class="col-md-5 col-sm-12">
                            <div class="card">
                                <div class="card-header card-header-light">
                                    <h3 class="card-title">{trans key='admin.user.account_info'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.email'}</label>
                                        <div class="col">
                                            <input id="email" type="email" class="form-control"
                                                value="{$edit_user->email}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.username'}</label>
                                        <div class="col">
                                            <input id="user_name" type="text" class="form-control"
                                                value="{$edit_user->user_name}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.user_identifier'}</label>
                                        <div class="col">
                                            <div class="input-group">
                                                <input id="user_uuid" type="text" class="form-control"
                                                    value="{$edit_user->uuid}" disabled />
                                                <button class="btn btn-outline-secondary copy" type="button"
                                                    data-clipboard-text="{$edit_user->uuid}"
                                                    aria-label="{trans key='admin.user.copy_uuid'}">
                                                    <i class="ti ti-copy"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.password'}</label>
                                        <div class="col">
                                            <input id="pass" type="text" class="form-control"
                                                placeholder="{trans key='admin.user.placeholders.reset_password'}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.balance'}</label>
                                        <div class="col">
                                            <input id="money" type="number" step="1" class="form-control"
                                                value="{$edit_user->money}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.referrer'}</label>
                                        <div class="col">
                                            <input id="ref_by" type="text" class="form-control"
                                                value="{$edit_user->ref_by}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.ss_port'}</label>
                                        <div class="col">
                                            <input id="port" type="text" class="form-control"
                                                value="{$edit_user->port}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.ss_method'}</label>
                                        <div class="col">
                                            <select id="method" class="col form-select" value="{$edit_user->method}">
                                                {foreach $ss_methods as $method}
                                                    <option value="{$method}"
                                                        {if $edit_user->method === $method}selected{/if}>
                                                        {$method}
                                                    </option>
                                                {/foreach}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.register_ip'}</label>
                                        <div class="col">
                                            <input type="text" class="form-control" value="{$edit_user->reg_ip}"
                                                disabled />
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.registered_at'}</label>
                                        <div class="col">
                                            <input type="text" class="form-control" value="{$edit_user->reg_date}"
                                                disabled />
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.last_used_at'}</label>
                                        <div class="col">
                                            <input type="text" class="form-control" value="{$edit_user->last_use_time}"
                                                disabled />
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.last_checkin_at'}</label>
                                        <div class="col">
                                            <input type="text" class="form-control"
                                                value="{$edit_user->last_check_in_time}" disabled />
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.last_login_at'}</label>
                                        <div class="col">
                                            <input type="text" class="form-control"
                                                value="{$edit_user->last_login_time}" disabled />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-12">
                            <div class="card">
                                <div class="card-header card-header-light">
                                    <h3 class="card-title">{trans key='admin.user.usage_limits'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.traffic_limit'}</label>
                                        <div class="col">
                                            <input id="transfer_enable" type="text" class="form-control"
                                                value="{$edit_user->enableTraffic()}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.current_usage'}</label>
                                        <div class="col">
                                            <input type="text" class="form-control" value="{$edit_user->usedTraffic()}"
                                                disabled />
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.total_usage'}</label>
                                        <div class="col">
                                            <input type="text" class="form-control" value="{$edit_user->totalTraffic()}"
                                                disabled />
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.node_group'}</label>
                                        <div class="col">
                                            <input id="node_group" type="text" class="form-control"
                                                value="{$edit_user->node_group}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.class'}</label>
                                        <div class="col">
                                            <input id="class" type="text" class="form-control"
                                                value="{$edit_user->class}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.class_expires'}</label>
                                        <div class="col">
                                            <input id="class_expire" type="text" class="form-control"
                                                value="{$edit_user->class_expire}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.free_reset_day'}</label>
                                        <div class="col">
                                            <input id="auto_reset_day" type="text" class="form-control"
                                                value="{$edit_user->auto_reset_day}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.free_reset_bandwidth'}</label>
                                        <div class="col">
                                            <input id="auto_reset_bandwidth" type="text" class="form-control"
                                                value="{$edit_user->auto_reset_bandwidth}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.speed_limit_mbps'}</label>
                                        <div class="col">
                                            <input id="node_speedlimit" type="text" class="form-control"
                                                value="{$edit_user->node_speedlimit}">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-4 col-form-label">{trans key='admin.user.fields.concurrent_ip_limit'}</label>
                                        <div class="col">
                                            <input id="node_iplimit" type="text" class="form-control"
                                                value="{$edit_user->node_iplimit}">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-12">
                            <div class="card">
                                <div class="card-header card-header-light">
                                    <h3 class="card-title">{trans key='admin.user.other_settings'}</h3>
                                </div>
                                <div class="card-body">
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.user.fields.language'}</label>
                                        <div class="col">
                                            <select id="locale" class="col form-select" value="{$edit_user->locale}">
                                                {foreach $locales as $locale}
                                                    <option value="{$locale}"
                                                        {if $edit_user->locale === $locale}selected{/if}>
                                                        {$locale}
                                                    </option>
                                                {/foreach}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <span class="col">{trans key='admin.user.fields.administrator'}</span>
                                        <span class="col-auto">
                                            <label class="form-check form-check-single form-switch">
                                                <input id="is_admin" class="form-check-input" type="checkbox"
                                                    {if $edit_user->is_admin}checked="" {/if}>
                                            </label>
                                        </span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <span class="col">{trans key='admin.user.fields.two_factor'}</span>
                                        <span class="col-auto">
                                            <label class="form-check form-check-single form-switch">
                                                <input id="ga_enable" class="form-check-input" type="checkbox"
                                                    {if $edit_user->ga_enable}checked="" {/if}>
                                            </label>
                                        </span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <span class="col">{trans key='admin.user.fields.shadow_banned'}</span>
                                        <span class="col-auto form-check-single form-switch">
                                            <input id="is_shadow_banned" class="form-check-input" type="checkbox"
                                                {if $edit_user->is_shadow_banned}checked="" {/if}>
                                        </span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <span class="col">{trans key='admin.user.fields.banned'}</span>
                                        <span class="col-auto">
                                            <label class="form-check form-check-single form-switch">
                                                <input id="is_banned" class="form-check-input" type="checkbox"
                                                    {if $edit_user->is_banned}checked="" {/if}>
                                            </label>
                                        </span>
                                    </div>
                                    <div class="form-group mb-3 col-12">
                                        <span
                                            class="form-label col-12 col-form-label">{trans key='admin.user.fields.ban_reason'}</span>
                                        <span class="col-auto">
                                            <textarea id="banned_reason" class="form-control"
                                                placeholder="{trans key='admin.user.placeholders.ban_reason'}">{$edit_user->banned_reason}</textarea>
                                        </span>
                                    </div>
                                    <div class="form-group mb-3 col-12">
                                        <label
                                            class="form-label col-12 col-form-label">{trans key='admin.user.fields.remark'}</label>
                                        <div class="col">
                                            <textarea id="remark" class="form-control" value="{$edit_user->remark}"
                                                placeholder="{trans key='admin.user.placeholders.remark'}"></textarea>
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
            $("#save_changes").click(function() {
                $.ajax({
                    url: '/admin/user/{$edit_user->id}',
                    type: 'PUT',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                            {$key}: $('#{$key}').val(),
                        {/foreach}
                        is_admin: $("#is_admin").is(":checked"),
                        ga_enable: $("#ga_enable").is(":checked"),
                        is_shadow_banned: $("#is_shadow_banned").is(":checked"),
                        is_banned: $("#is_banned").is(":checked"),
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