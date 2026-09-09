<link href="//cdn.datatables.net/v/bs5/dt-2.0.8/datatables.min.css" rel="stylesheet" />
<script src="//cdn.datatables.net/v/bs5/dt-2.0.8/datatables.min.js"></script>

<script>
    let tableConfig = {
        autoWidth: false,
        iDisplayLength: 10,
        scrollX: true,
        columns: [
            {foreach $details['field'] as $key => $value}
                {
                    data: '{$key}'
                },
            {/foreach}
        ],
        initComplete: function() {
            $('div.dt-length').parent().parent().removeClass('mt-2').addClass('row px-3 py-3')
            $('div.dt-scroll').parent().parent().removeClass('mt-2')
            $('div.dt-info').parent().parent().removeClass('mt-2').addClass('row card-footer')
            $('div.dt-length').parent().removeClass('col-md-auto me-auto').addClass('col-auto')
            $('div.dt-search').parent().removeClass('col-md-auto me-auto ms-auto').addClass('col-auto')
            $('div.dt-info').parent().removeClass('col-md-auto me-auto').addClass('col')
            $('div.dt-paging').parent().removeClass('col-md-auto me-auto ms-auto').addClass('col-auto')
            $('div.dt-scroll-body').css('border-bottom-style', 'none')
        },
        language: {
            "sProcessing": "{trans key='datatable.processing'}",
            "sLengthMenu": "{trans key='datatable.length_menu'}",
            "sZeroRecords": "{trans key='datatable.zero_records'}",
            "sInfo": "{trans key='datatable.info'}",
            "sInfoEmpty": "{trans key='datatable.info_empty'}",
            "sInfoFiltered": "{trans key='datatable.info_filtered'}",
            "sInfoPostFix": "",
            "sSearch": "<i class=\"ti ti-search\"></i> ",
            "sUrl": "",
            "sEmptyTable": "{trans key='datatable.empty_table'}",
            "sLoadingRecords": "{trans key='datatable.loading'}",
            "sInfoThousands": ",",
            "oPaginate": {
                "sFirst": "{trans key='datatable.first'}",
                "sPrevious": "<i class=\"ti ti-arrow-left\"></i>",
                "sNext": "<i class=\"ti ti-arrow-right\"></i>",
                "sLast": "{trans key='datatable.last'}"
            },
            "oAria": {
                "sSortAscending": "{trans key='datatable.sort_ascending'}",
                "sSortDescending": "{trans key='datatable.sort_descending'}"
            }
        }
    };
</script>