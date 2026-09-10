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
                                <span class="home-title">{trans key='admin.announcement.create_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.announcement.create_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <button id="create" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.announcement.save'}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="page-body">
                <div class="container-xl">
                    <div class="row row-cards">
                        <div class="col-md-9 col-sm-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="mb-3">
                                        <form method="post">
                                            <textarea id="tinymce"></textarea>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-12">
                            <div class="card">
                                <div class="card-body">
                                    <h3 class="card-title">{trans key='admin.announcement.options'}</h3>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.announcement.fields.status'}</label>
                                        <div class="col">
                                            <select id="status" class="col form-select" value="1">
                                                <option value="0">{trans key='admin.announcement.status.0'}</option>
                                                <option value="1">{trans key='admin.announcement.status.1'}</option>
                                                <option value="2">{trans key='admin.announcement.status.2'}</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label class="form-label">{trans key='admin.announcement.fields.sort'}</label>
                                        <div class="col">
                                            <input id="sort" type="text" class="form-control" value="0">
                                        </div>
                                    </div>
                                    <div class="hr-text">
                                        <span>{trans key='admin.announcement.notification'}</span>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label">{trans key='admin.announcement.email_notify_class'}</label>
                                        <div class="col">
                                            <input id="email_notify_class" type="text" class="form-control" value="0">
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <span class="col">{trans key='admin.announcement.email_notify'}</span>
                                        <span class="col-auto">
                                            <label class="form-check form-check-single form-switch">
                                                <input id="email_notify" class="form-check-input" type="checkbox"
                                                    checked="">
                                            </label>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        {include file='tinymce.tpl'}

        <script>
            $("#create").click(function() {
                $.ajax({
                    url: '/admin/announcement',
                    type: 'POST',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                            {$key}: $('#{$key}').val(),
                        {/foreach}
                        email_notify_class: $('#email_notify_class').val(),
                        email_notify: $("#email_notify").is(":checked"),
                        content: tinyMCE.activeEditor.getContent(),
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