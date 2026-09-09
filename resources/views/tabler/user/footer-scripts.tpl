<!-- js -->
<script src="//{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/js/tabler.min.js"></script>
<script>
    let successDialog = new bootstrap.Modal(document.getElementById('success-dialog'));
    let failDialog = new bootstrap.Modal(document.getElementById('fail-dialog'));

    htmx.on("htmx:afterRequest", function(evt) {
        if (evt.detail.xhr.getResponseHeader('HX-Refresh') === 'true' ||
            evt.detail.xhr.getResponseHeader('HX-Redirect') ||
            evt.detail.xhr.getResponseHeader('HX-Trigger')) {
            return;
        }

        let res = JSON.parse(evt.detail.xhr.response);

        if (typeof res.data !== 'undefined') {
            for (let key in res.data) {
                if (res.data.hasOwnProperty(key)) {
                    if (key === "ga-url") {
                        qrcode.clear();
                        qrcode.makeCode(res.data[key]);
                    }

                    if (key === "last-checkin-time") {
                        document.getElementById("check-in").innerHTML = "{trans key='user_pages.checked_in'}"
                        document.getElementById("check-in").disabled = true;
                    }

                    let element = document.getElementById(key);

                    if (element) {
                        if (element.tagName === "INPUT" || element.tagName === "TEXTAREA") {
                            element.value = res.data[key];
                        } else {
                            element.innerHTML = res.data[key];
                        }
                    }
                }
            }
        }

        if (res.ret === 1) {
            document.getElementById("success-message").innerHTML = res.msg;
            successDialog.show();
        } else {
            document.getElementById("fail-message").innerHTML = res.msg;
            failDialog.show();
        }
    });
</script>
<script>
    console.table([["{trans key='user_pages.database_queries'}", "{trans key='user_pages.execution_time'}"], ['{count($queryLog)}', '{$optTime} ms']])
</script>