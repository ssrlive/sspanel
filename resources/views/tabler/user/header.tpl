<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <meta name="referrer" content="never">
    <title>{$config['appName']}</title>
    <!-- Auto dark mode -->
    <script>
        ;
        (function() {
            const htmlElement = document.querySelector("html")
            const theme = htmlElement.getAttribute("data-bs-theme");

            if (theme === 'dark-auto' || theme === 'auto') {
                function updateTheme() {
                    htmlElement.setAttribute("data-bs-theme",
                        window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light")
                }
                window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateTheme)
                updateTheme()
            }
        })()
    </script>
    <!-- CSS files -->
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/css/tabler.min.css" rel="stylesheet" />
    <link href="//{$config['jsdelivr_url']}/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet" />
    <!-- JS files -->
    <script src="/assets/js/fuck.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/qrcode_js@latest/qrcode.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/clipboard@latest/dist/clipboard.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/htmx.org@v2/dist/htmx.min.js"></script>
    <script src="//{$config['jsdelivr_url']}/npm/jquery/dist/jquery.min.js"></script>
    <style>
        .home-subtitle {
            font-size: 14px;
        }

        .home-title {
            font-size: 36px;
        }

        .spoiler {
            background-color: gray;
            color: transparent;
            transition: 0.3s;
        }

        .spoiler:hover {
            background-color: inherit;
            color: inherit;
        }
    </style>
</head>