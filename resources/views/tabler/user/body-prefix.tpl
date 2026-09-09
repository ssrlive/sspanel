<header class="navbar navbar-expand-md navbar-overlap d-print-none" data-bs-theme="dark">
    <div class="container-xl" style="background-image: none;">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbar-menu">
            <span class="navbar-toggler-icon"></span>
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
                    <a href="/user/logout" class="dropdown-item">{trans key='nav.logout'}</a>
                </div>
            </div>
        </div>
        <div class="collapse navbar-collapse" id="navbar-menu">
            <div class="d-flex flex-column flex-md-row flex-fill align-items-stretch align-items-md-center">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="/user">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-home icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='nav.home'}
                            </span>
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-base" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-user icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='nav.account'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <div class="dropdown-menu-columns">
                                <div class="dropdown-menu-column">
                                    <a class="dropdown-item" href="/user/profile">
                                        <i class="ti ti-info-square"></i>&nbsp;
                                        {trans key='nav.account'}
                                    </a>
                                    <a class="dropdown-item" href="/user/edit">
                                        <i class="ti ti-edit"></i>&nbsp;
                                        {trans key='nav.edit'}
                                    </a>
                                    <a class="dropdown-item" href="/user/invite">
                                        <i class="ti ti-friends"></i>&nbsp;
                                        {trans key='nav.invite'}
                                    </a>
                                </div>
                            </div>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-brand-telegram icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='nav.usage'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="/user/server">
                                <i class="ti ti-server"></i>&nbsp;
                                {trans key='nav.nodes'}
                            </a>
                            <a class="dropdown-item" href="/user/rate">
                                <i class="ti ti-chart-bar"></i>&nbsp;
                                {trans key='nav.traffic_rate'}
                            </a>
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-dots-circle-horizontal icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='nav.support'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="/user/announcement">
                                <i class="ti ti-speakerphone"></i>&nbsp;
                                {trans key='nav.announcements'}
                            </a>
                            {if $public_setting['enable_ticket']}
                                <a class="dropdown-item" href="/user/ticket">
                                    <i class="ti ti-ticket"></i>&nbsp;
                                    {trans key='nav.tickets'}
                                </a>
                            {/if}
                            {if $public_setting['display_docs'] &&
                                (! $public_setting['display_docs_only_for_paid_user'] || $user->class !== 0)}
                            <a class="dropdown-item" href="/user/docs">
                                <i class="ti ti-notes"></i>&nbsp;
                                {trans key='nav.docs'}
                            </a>
                            {/if}
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-extra" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-shield-check icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='nav.audit'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="/user/detect">
                                <i class="ti ti-barrier-block"></i>&nbsp;
                                {trans key='nav.rules'}
                            </a>
                            {if $public_setting['display_detect_log']}
                                <a class="dropdown-item" href="/user/detect/log">
                                    <i class="ti ti-notes"></i>&nbsp;
                                    {trans key='nav.logs'}
                                </a>
                            {/if}
                        </div>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#navbar-layout" data-bs-toggle="dropdown"
                            data-bs-auto-close="outside" role="button" aria-expanded="false">
                            <span class="nav-link-icon d-md-none d-lg-inline-block">
                                <i class="ti ti-building-store icon"></i>
                            </span>
                            <span class="nav-link-title">
                                {trans key='nav.store'}
                            </span>
                        </a>
                        <div class="dropdown-menu">
                            <div class="dropdown-menu-columns">
                                <div class="dropdown-menu-column">
                                    <a class="dropdown-item" href="/user/product">
                                        <i class="ti ti-list"></i>&nbsp;
                                        {trans key='nav.products'}
                                    </a>
                                    <a class="dropdown-item" href="/user/order">
                                        <i class="ti ti-file-invoice"></i>&nbsp;
                                        {trans key='nav.orders'}
                                    </a>
                                    <a class="dropdown-item" href="/user/invoice">
                                        <i class="ti ti-file-dollar"></i>&nbsp;
                                        {trans key='nav.invoices'}
                                    </a>
                                    <a class="dropdown-item" href="/user/money">
                                        <i class="ti ti-home-dollar"></i>&nbsp;
                                        {trans key='nav.balance'}
                                    </a>
                                </div>
                            </div>
                        </div>
                    </li>
                    {if $user->is_admin}
                        <li class="nav-item">
                            <a class="nav-link" href="/admin">
                                <span class="nav-link-icon d-md-none d-lg-inline-block">
                                    <i class="ti ti-settings icon"></i>
                                </span>
                                <span class="nav-link-title">
                                    {trans key='nav.admin'}
                                </span>
                            </a>
                        </li>
                    {/if}
                </ul>
            </div>
        </div>
    </div>
</header>