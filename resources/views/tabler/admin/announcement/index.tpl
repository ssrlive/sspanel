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
                                <span class="home-title">{trans key='admin.announcement.list_title'}</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">{trans key='admin.announcement.list_subtitle'}</span>
                            </div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a href="/admin/announcement/create" class="btn btn-primary">
                                    <i class="icon ti ti-plus"></i>
                                    {trans key='admin.announcement.create'}
                                </a>
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
                                    <table id="data-table" class="table card-table table-vcenter text-nowrap datatable">
                                        <thead>
                                            <tr>
                                                {foreach $details['field'] as $key => $value}
                                                    <th>{$value}</th>
                                                {/foreach}
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {include file='datatable.tpl'}

            <script>
                tableConfig.ajax = {
                    url: '/admin/announcement/ajax',
                    type: 'POST',
                    dataSrc: 'anns'
                };
                tableConfig.order = [
                    [1, 'asc']
                ];
                tableConfig.columnDefs = [{
                    targets: [0],
                    orderable: false
                }];

                let table = new DataTable('#data-table', tableConfig);

                function loadTable() {
                    table;
                }

                function deleteAnn(ann_id) {
                    $('#notice-message').text('{trans key="admin.announcement.confirm_delete"}');
                    $('#notice-dialog').modal('show');
                    $('#notice-confirm').off('click').on('click', function() {
                        $.ajax({
                            url: "/admin/announcement/" + ann_id,
                            type: 'DELETE',
                            dataType: "json",
                            success: function(data) {
                                if (data.ret === 1) {
                                    $('#success-message').text(data.msg);
                                    $('#success-dialog').modal('show');
                                    reloadTableAjax();
                                } else {
                                    $('#fail-message').text(data.msg);
                                    $('#fail-dialog').modal('show');
                                }
                            }
                        })
                    });
                }

                function reloadTableAjax() {
                    table.ajax.reload(null, false);
                }

                loadTable();
            </script>

            {include file='admin/footer.tpl'}
        </div>
    </div>

    {include file='admin/footer-scripts.tpl'}
</body>

</html>