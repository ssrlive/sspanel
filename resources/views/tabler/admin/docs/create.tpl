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
                                <span class="home-title">{trans key='admin.docs.create_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.docs.create_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <button href="#" class="btn btn-primary" data-bs-toggle="modal"
                                    data-bs-target="#generate-docs">
                                    <i class="icon ti ti-robot-face"></i>
                                    {trans key='admin.docs.generate_button'}
                                </button>
                                <button id="create" href="#" class="btn btn-primary">
                                    <i class="icon ti ti-device-floppy"></i>
                                    {trans key='admin.docs.save'}
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
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.docs.fields.title'}</label>
                                        <div class="col">
                                            <input id="title" type="text" class="form-control" value="">
                                        </div>
                                    </div>
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
                                    <h3 class="card-title">{trans key='admin.docs.options'}</h3>
                                    <div class="form-group mb-3 row">
                                        <label
                                            class="form-label col-3 col-form-label">{trans key='admin.docs.fields.status'}</label>
                                        <div class="col">
                                            <select id="status" class="col form-select" value="1">
                                                <option value="0">{trans key='admin.docs.status.0'}</option>
                                                <option value="1">{trans key='admin.docs.status.1'}</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group mb-3 row">
                                        <label class="form-label">{trans key='admin.docs.fields.sort'}</label>
                                        <div class="col">
                                            <input id="sort" type="text" class="form-control" value="0">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal modal-blur fade" id="generate-docs" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">{trans key='admin.docs.generate_title'}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <input id="question" class="form-control" rows="12"
                                    placeholder="{trans key='admin.docs.generate_placeholder'}">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn me-auto"
                                data-bs-dismiss="modal">{trans key='admin.docs.cancel'}</button>
                            <button id="generate" type="button" class="btn btn-primary"
                                data-bs-dismiss="modal">{trans key='admin.docs.generate'}</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        {include file='tinymce.tpl'}

        <script>
            $("#generate").click(function() {
                $.ajax({
                    url: "/admin/docs/generate",
                    type: 'POST',
                    dataType: "json",
                    data: {
                        question: $("#question").val(),
                    },
                    success: function(data) {
                        if (data.ret === 1) {
                            $('#success-message').text(data.msg);
                            $('#success-dialog').modal('show');
                            tinyMCE.activeEditor.setContent(data.content);
                        } else {
                            $('#fail-message').text(data.msg);
                            $('#fail-dialog').modal('show');
                        }
                    }
                })
            });

            $("#create").click(function() {
                $.ajax({
                    url: '/admin/docs',
                    type: 'POST',
                    dataType: "json",
                    data: {
                        {foreach $update_field as $key}
                            {$key}: $('#{$key}').val(),
                        {/foreach}
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