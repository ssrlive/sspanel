<!doctype html>
<html lang="{$user->locale}"
    data-bs-theme="{$user->is_dark_mode === 1 ? 'dark' : ($user->is_dark_mode === 2 ? 'auto' : 'light')}">

{include file="user/header.tpl"}

<body {if $user->is_dark_mode === 1}data-bs-theme="dark" {elseif $user->is_dark_mode === 2}data-bs-theme="auto" {/if}>
    <style>
        .overtls-qrcode-popup {
            display: none;
            position: fixed;
            min-width: 280px;
            padding: 1rem;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.98);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
            border: 1px solid rgba(0, 0, 0, 0.08);
            text-align: center;
            pointer-events: none;
            z-index: 99999;
        }

        [data-bs-theme='dark'] .overtls-qrcode-popup {
            background: rgba(15, 23, 42, 0.95);
            border-color: rgba(255, 255, 255, 0.08);
            color: #f8fafc;
        }

        .overtls-qrcode-box {
            width: 240px;
            height: 240px;
            margin: 0 auto;
        }

        .overtls-qrcode-caption {
            margin-top: 0.5rem;
            font-size: 0.85rem;
            color: #6b7280;
        }

        [data-bs-theme='dark'] .overtls-qrcode-caption {
            color: #cbd5e1;
        }
    </style>
    <div class="page">
        {include file="user/body-prefix.tpl"}

        <div class="page-wrapper">
            <div class="container-xl">
                <div class="page-header d-print-none text-white">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">
                                <span class="home-title">节点列表</span>
                            </h2>
                            <div class="page-pretitle my-3">
                                <span class="home-subtitle">查看节点在线情况</span>
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
                                <div class="card-body">
                                    <div class="tab-content">
                                        <div class="row row-deck row-cards">
                                            {foreach $servers as $server}
                                                <div class="col-lg-4 col-md-6 col-sm-12">
                                                    <div class="card{if $server['sort'] === 'OverTLS' && $server['overtls_url'] !== ''} overtls-card{/if}"
                                                        {if $server['sort'] === 'OverTLS' && $server['overtls_url'] !== ''}
                                                        data-overtls-url="{$server.overtls_url|escape:'html'}" {/if}>
                                                        {if $server['class'] === 0}
                                                            <div class="ribbon bg-blue">免费</div>
                                                        {else}
                                                            <div class="ribbon bg-blue">LV. {$server['class']}</div>
                                                        {/if}
                                                        <div class="card-body">
                                                            <div class="row g-3 align-items-center">
                                                                <div class="col-auto">
                                                                    <span class="status-indicator status-{$server['color']}
                                                                 status-indicator-animated">
                                                                        <span class="status-indicator-circle"></span>
                                                                        <span class="status-indicator-circle"></span>
                                                                        <span class="status-indicator-circle"></span>
                                                                    </span>
                                                                </div>
                                                                <div class="col">
                                                                    <h2 class="page-title" style="font-size: 16px;">
                                                                        {$server['name']}&nbsp;
                                                                        <span class="card-subtitle my-2"
                                                                            style="font-size: 10px;">
                                                                            {$server['node_bandwidth']} /
                                                                            {$server['node_bandwidth_limit']}
                                                                        </span>
                                                                    </h2>
                                                                    <div class="text-secondary badges-list">
                                                                        <span class="badge bg-blue-lt">
                                                                            <i class="ti ti-users"></i>
                                                                            {$server['online_user']}</span>
                                                                        <span class="badge bg-blue-lt">
                                                                            {if $server['is_dynamic_rate']}
                                                                                动态倍率
                                                                            {else}
                                                                                {$server['traffic_rate']} 倍
                                                                            {/if}
                                                                        </span>
                                                                        {if $server['sort'] === 'OverTLS' && $server['overtls_url'] !== ''}
                                                                            <span class="overtls-badge-wrapper">
                                                                                <span class="badge bg-teal-lt overtls-badge"
                                                                                    data-overtls-url="{$server.overtls_url|escape:'html'}">
                                                                                    {$server['sort']}
                                                                                </span>
                                                                                <div class="overtls-qrcode-popup"></div>
                                                                            </span>
                                                                        {elseif $server['sort'] === 'OverTLS'}
                                                                            <span
                                                                                class="badge bg-blue-lt">{$server['sort']}</span>
                                                                        {else}
                                                                            <span
                                                                                class="badge bg-blue-lt">{$server['sort']}</span>
                                                                        {/if}
                                                                        {if $server['connection_type'] !== 0}
                                                                            <span class="badge bg-blue-lt">IPv6</span>
                                                                        {/if}
                                                                    </div>
                                                                </div>

                                                            </div>
                                                        </div>
                                                    </div>
                                                    {if $user->class < $server['class']}
                                                        <div class="card bg-primary-lt">
                                                            <div class="card-body">
                                                                <p class="text-secondary">
                                                                    <i class="ti ti-info-circle icon text-blue"></i>
                                                                    你当前的账户等级小于节点等级，因此无法使用。可前往 <a href="/user/product">商品页面</a>
                                                                    订购时间流量包
                                                                </p>
                                                            </div>
                                                        </div>
                                                    {/if}
                                                </div>
                                            {/foreach}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {include file="user/footer.tpl"}
        </div>
    </div>

    {include file="user/footer-scripts.tpl"}

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.overtls-card').forEach(function(card) {
                var url = card.dataset.overtlsUrl || '';
                if (!url) {
                    return;
                }

                var popup = document.createElement('div');
                popup.className = 'overtls-qrcode-popup';
                document.body.appendChild(popup);

                var qrRendered = false;

                card.addEventListener('mouseenter', function() {
                    if (!qrRendered) {
                        popup.innerHTML = '';
                        var qrBox = document.createElement('div');
                        qrBox.className = 'overtls-qrcode-box';
                        popup.appendChild(qrBox);
                        new QRCode(qrBox, {
                            text: url,
                            width: 240,
                            height: 240,
                            correctLevel: QRCode.CorrectLevel.H
                        });
                        var caption = document.createElement('div');
                        caption.className = 'overtls-qrcode-caption';
                        caption.textContent = 'OverTLS 订阅二维码';
                        popup.appendChild(caption);
                        qrRendered = true;
                    }
                    popup.style.display = 'block';
                });

                card.addEventListener('mousemove', function(event) {
                    popup.style.left = event.clientX + 16 + 'px';
                    popup.style.top = event.clientY + 16 + 'px';
                });

                card.addEventListener('mouseleave', function() {
                    popup.style.display = 'none';
                });
            });
        });
    </script>

    {include file='live_chat.tpl'}

</body>

</html>