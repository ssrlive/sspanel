<script>
    if (typeof ClipboardJS !== 'undefined') {
        let clipboard = new ClipboardJS('.copy');
        clipboard.on('success', function() {
            $('#success-message').text('已复制到 剪切板');
            $('#success-dialog').modal('show');
        });
    }
</script>