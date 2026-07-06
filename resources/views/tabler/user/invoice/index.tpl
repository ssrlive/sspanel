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
                                <span class="home-title my-3">账单列表</span>
                            </h2>
                            <div class="page-pretitle">
                                <span class="home-subtitle">在这里查看账单列表</span>
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
                    url: '/user/invoice/ajax',
                    type: 'POST',
                    dataSrc: 'invoices'
                };
                tableConfig.order = [
                    [1, 'desc']
                ];
                tableConfig.columnDefs = [{
                    targets: [0],
                    orderable: false
                }];

                let table = new DataTable('#data-table', tableConfig);

                function loadTable() {
                    table;
                }

                function reloadTableAjax() {
                    table.ajax.reload(null, false);
                }

                loadTable();
            </script>

            {include file='user/footer.tpl'}
        </div>
    </div>

    {include file="user/footer-scripts.tpl"}

    {include file='live_chat.tpl'}

</body>

</html>