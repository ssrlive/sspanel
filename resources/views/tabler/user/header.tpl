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
    <link href="https://{$config['jsdelivr_url']}/npm/@tabler/core@latest/dist/css/tabler.min.css" rel="stylesheet" />
    <link href="https://{$config['jsdelivr_url']}/npm/@tabler/icons-webfont@latest/tabler-icons.min.css"
        rel="stylesheet" />
    <!-- JS files -->
    <script src="/assets/js/fuck.js"></script>
    <script src="https://{$config['jsdelivr_url']}/npm/qrcode_js@latest/qrcode.min.js"></script>
    <script src="https://{$config['jsdelivr_url']}/npm/clipboard@latest/dist/clipboard.min.js"></script>
    <script src="https://{$config['jsdelivr_url']}/npm/htmx.org@v2/dist/htmx.min.js"></script>
    <script src="https://{$config['jsdelivr_url']}/npm/jquery/dist/jquery.min.js"></script>
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

        .navbar-toggler-line {
            display: block;
            width: 1.5em;
            height: 2px;
            margin: 0.2em 0;
            background-color: #fff;
            transition: transform 0.15s ease, opacity 0.15s ease;
        }

        .navbar-toggler {
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .navbar-toggler[aria-expanded="true"] .navbar-toggler-line:first-child {
            transform: translateY(0.4em) rotate(45deg);
        }

        .navbar-toggler[aria-expanded="true"] .navbar-toggler-line:nth-child(2) {
            opacity: 0;
        }

        .navbar-toggler[aria-expanded="true"] .navbar-toggler-line:last-child {
            transform: translateY(-0.4em) rotate(-45deg);
        }

        /* iOS 15 Safari ignores light-dark(), which Tabler uses for the navbar
           background, leaving the header and mobile menu blank; set it explicitly. */
        @supports not (background: light-dark(black, white)) {
            header.navbar {
                background-color: #1a2234;
            }

            /* iOS 15 Safari ignores color-mix(), which Tabler uses for .text-white,
               leaving page titles and icon badges invisible on the dark header. */
            .text-white {
                color: #fff !important;
            }

            /* iOS 15 Safari ignores color-mix(), which Tabler uses for the dropdown
               background/hover colors, leaving the account menu blank. */
            header[data-bs-theme="dark"] .dropdown-menu {
                background-color: #1a2234;
                color: #fff;
            }

            header[data-bs-theme="dark"] .dropdown-menu .dropdown-item {
                color: #fff;
            }

            header[data-bs-theme="dark"] .dropdown-menu .dropdown-item:hover,
            header[data-bs-theme="dark"] .dropdown-menu .dropdown-item:focus {
                background-color: rgba(255, 255, 255, 0.08);
                color: #fff;
            }
        }
    </style>
</head>