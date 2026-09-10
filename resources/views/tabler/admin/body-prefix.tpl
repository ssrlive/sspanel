<header class="navbar navbar-expand-md navbar-overlap d-print-none" data-bs-theme="dark">
    <div class="container-xl" style="background-image: none;">
        <button class="navbar-toggler" type="button" aria-label="Toggle navigation"
            data-bs-toggle="collapse" data-bs-target="#navbar-menu">
            <span class="navbar-toggler-line"></span>
            <span class="navbar-toggler-line"></span>
            <span class="navbar-toggler-line"></span>
        </button>
        <h1 class="navbar-brand navbar-brand-autodark d-none-navbar-horizontal pe-0 pe-md-3">
            <img src="/images/next-logo.svg" height="32" alt="Next Panel Logo" class="navbar-brand-image"
                style="filter: none;">
        </h1>
        <div class="navbar-nav flex-row order-md-last">
            <div class="nav-item dropdown">
                <a href="#" class="nav-link d-flex lh-1 text-reset p-0" data-bs-toggle="dropdown">
                    <span class="avatar avatar-sm" style="background-image: url({$user->dice_bear})"></span>
                </a>
                <div class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                    <a href="/user/logout" class="dropdown-item">{trans key='admin.nav.logout'}</a>
                </div>
            </div>
        </div>
        <div class="collapse navbar-collapse" id="navbar-menu">
            <div class="d-flex flex-column flex-md-row flex-fill align-items-stretch align-items-md-center">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="/admin">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-home icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='admin.nav.overview'}
                            </span>
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-base" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-settings icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='admin.nav.management'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <div class="dropdown-menu-columns">
                                <div class="dropdown-menu-column">
                                    <div class="dropend">
                                        <a class="dropdown-item dropdown-toggle" href="#" data-bs-toggle="dropdown"
                                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                                            <i class="ti ti-settings"></i>&nbsp;
                                            {trans key='admin.nav.settings'}
                                        </a>
                                        <div class="dropdown-menu">
                                            <a href="/admin/setting/billing" class="dropdown-item">
                                                {trans key='admin.nav.billing'}
                                            </a>
                                            <a href="/admin/setting/email" class="dropdown-item">
                                                {trans key='admin.nav.email'}
                                            </a>
                                            <a href="/admin/setting/support" class="dropdown-item">
                                                {trans key='admin.nav.support'}
                                            </a>
                                            <a href="/admin/setting/captcha" class="dropdown-item">
                                                {trans key='admin.nav.captcha'}
                                            </a>
                                            <a href="/admin/setting/reg" class="dropdown-item">
                                                {trans key='admin.nav.registration'}
                                            </a>
                                            <a href="/admin/setting/ref" class="dropdown-item">
                                                {trans key='admin.nav.referral'}
                                            </a>
                                            <a href="/admin/setting/im" class="dropdown-item">
                                                IM
                                            </a>
                                            <a href="/admin/setting/sub" class="dropdown-item">
                                                {trans key='admin.nav.subscription'}
                                            </a>
                                            <a href="/admin/setting/cron" class="dropdown-item">
                                                {trans key='admin.nav.cron'}
                                            </a>
                                            <a href="/admin/setting/llm" class="dropdown-item">
                                                LLM
                                            </a>
                                            <a href="/admin/setting/feature" class="dropdown-item">
                                                {trans key='admin.nav.other_settings'}
                                            </a>
                                        </div>
                                    </div>
                                    <a class="dropdown-item" href="/admin/user">
                                        <i class="ti ti-users"></i>&nbsp;
                                        {trans key='admin.nav.users'}
                                    </a>
                                    <a class="dropdown-item" href="/admin/node">
                                        <i class="ti ti-server-2"></i>&nbsp;
                                        {trans key='admin.nav.nodes'}
                                    </a>
                                    <a class="dropdown-item" href="/admin/system">
                                        <i class="ti ti-tool"></i>&nbsp;
                                        {trans key='admin.nav.system'}
                                    </a>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-brand-hipchat icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='admin.nav.operations'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="/admin/announcement">
                                <i class="ti ti-speakerphone"></i>&nbsp;
                                {trans key='admin.nav.announcements'}
                            </a>
                            <a class="dropdown-item" href="/admin/ticket">
                                <i class="ti ti-messages"></i>&nbsp;
                                {trans key='admin.nav.tickets'}
                            </a>
                            <a class="dropdown-item" href="/admin/docs">
                                <i class="ti ti-notes"></i>&nbsp;
                                {trans key='admin.nav.docs'}
                            </a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-address-book icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='admin.nav.logs'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="/admin/login">
                                <i class="ti ti-login"></i>&nbsp;
                                {trans key='admin.nav.login'}
                            </a>
                            <a class="dropdown-item" href="/admin/subscribe">
                                <i class="ti ti-rss"></i>&nbsp;
                                {trans key='admin.nav.subscription'}
                            </a>
                            <a class="dropdown-item" href="/admin/payback">
                                <i class="ti ti-friends"></i>&nbsp;
                                {trans key='admin.nav.payback'}
                            </a>
                            <a class="dropdown-item" href="/admin/money">
                                <i class="ti ti-coin"></i>&nbsp;
                                {trans key='admin.nav.balance'}
                            </a>
                            <a class="dropdown-item" href="/admin/gateway">
                                <i class="ti ti-torii"></i>&nbsp;
                                {trans key='admin.nav.payment_gateway'}
                            </a>
                            <a class="dropdown-item" href="/admin/online">
                                <i class="ti ti-router"></i>&nbsp;
                                {trans key='admin.nav.online_ip'}
                            </a>
                            <a class="dropdown-item" href="/admin/syslog">
                                <i class="ti ti-settings"></i>&nbsp;
                                {trans key='admin.nav.system_logs'}
                            </a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-shield-check icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='admin.nav.audit'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="/admin/detect">
                                <i class="ti ti-barrier-block"></i>&nbsp;
                                {trans key='admin.nav.rules'}
                            </a>
                            <a class="dropdown-item" href="/admin/detect/log">
                                <i class="ti ti-notes"></i>&nbsp;
                                {trans key='admin.nav.collision_logs'}
                            </a>
                            <a class="dropdown-item" href="/admin/detect/ban">
                                <i class="ti ti-notes"></i>&nbsp;
                                {trans key='admin.nav.ban_logs'}
                            </a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-layout" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-coin icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='admin.nav.finance'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <div class="dropdown-menu-columns">
                                <div class="dropdown-menu-column">
                                    <a class="dropdown-item" href="/admin/product">
                                        <i class="ti ti-list-details"></i>&nbsp;
                                        {trans key='admin.nav.products'}
                                    </a>
                                    <a class="dropdown-item" href="/admin/order">
                                        <i class="ti ti-receipt"></i>&nbsp;
                                        {trans key='admin.nav.orders'}
                                    </a>
                                    <a class="dropdown-item" href="/admin/invoice">
                                        <i class="ti ti-file-dollar"></i>&nbsp;
                                        {trans key='admin.nav.invoices'}
                                    </a>
                                    <a class="dropdown-item" href="/admin/coupon">
                                        <i class="ti ti-ticket"></i>&nbsp;
                                        {trans key='admin.nav.coupons'}
                                    </a>
                                    <a class="dropdown-item" href="/admin/giftcard">
                                        <i class="ti ti-gift"></i>&nbsp;
                                        {trans key='admin.nav.gift_cards'}
                                    </a>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/user">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-arrow-back-up icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='admin.nav.user_center'}
                            </span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</header>