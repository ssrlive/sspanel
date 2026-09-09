<?php

declare(strict_types=1);

// Translations for Chinese(Used in illegally occupied areas of Republic of China)
return [
    'lang' => 'zh_CN',
    'lang_name' => '中文',
    'lang_code' => 'zh',
    'nav' => [
        'logout' => '登出', 'home' => '主页', 'account' => '账户', 'edit' => '资料', 'invite' => '邀请',
        'usage' => '使用', 'nodes' => '节点', 'traffic_rate' => '流量倍率', 'support' => '支援',
        'announcements' => '公告', 'tickets' => '工单', 'docs' => '文档', 'audit' => '审计',
        'rules' => '规则', 'logs' => '日志', 'store' => '商店', 'products' => '商品',
        'orders' => '订单', 'invoices' => '账单', 'balance' => '余额', 'admin' => '站点管理',
    ],
    'auth' => [
        'login_title' => '登录到用户中心', 'email' => '邮箱', 'password' => '登录密码', 'forgot_password' => '忘记密码',
        'mfa' => '两步认证', 'mfa_placeholder' => '如果没有设置两步认证可留空', 'remember_device' => '记住此设备',
        'login' => '登录', 'no_account' => '还没有账户？', 'register_link' => '点击注册', 'register_title' => '注册账户',
        'nickname' => '昵称', 'email_code' => '邮箱验证码', 'get_code' => '获取', 'confirm_password' => '重复登录密码',
        'invite_code' => '注册邀请码', 'optional' => '可选', 'required' => '必填', 'tos_agreement' => '我已阅读并同意',
        'tos' => '服务条款与隐私政策', 'register' => '注册新账户', 'registration_closed' => '还没有开放注册，过两天再来看看吧',
        'has_account' => '已有账户？', 'login_link' => '点击登录',
    ],
    'password_reset' => [
        'title' => '忘记密码', 'description' => '我们将向你的注册邮箱发送一封邮件，邮件内容中包含一个可以重设密码的链接',
        'registered_email' => '注册邮箱', 'send_email' => '发送邮件', 'new_password' => '新密码',
        'new_password_placeholder' => '请输入新密码', 'confirm_new_password' => '再次输入新密码',
        'confirm_new_password_placeholder' => '请再次输入新密码', 'reset' => '重置',
    ],
    'datatable' => [
        'processing' => '处理中...', 'length_menu' => '显示 _MENU_ 条', 'zero_records' => '没有匹配结果',
        'info' => '第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项', 'info_empty' => '第 0 至 0 项结果，共 0 项',
        'info_filtered' => '(在 _MAX_ 项中查找)', 'empty_table' => '表中数据为空', 'loading' => '载入中...',
        'first' => '首页', 'previous' => '上一页', 'next' => '下一页', 'last' => '末页',
        'sort_ascending' => ': 以升序排列此列', 'sort_descending' => ': 以降序排列此列',
    ],
    'settings' => [
        'title' => '资料修改', 'subtitle' => '修改账户的部分信息', 'personal' => '资料', 'security' => '登录', 'usage' => '使用', 'other' => '其他',
        'login_email' => '登录邮箱', 'current_email' => '当前邮箱：', 'new_email' => '新邮箱', 'verification_code' => '验证码', 'get_code' => '获取验证码', 'update' => '修改', 'change_disabled' => '不允许修改',
        'username' => '用户名', 'current_username' => '当前用户名：', 'new_username' => '新用户名', 'im_bind' => 'IM 账号绑定', 'unbound' => '未绑定', 'unbind_im' => '解绑 IM 账户', 'no_im' => '你的账户当前没有绑定任何 IM 服务', 'current_im' => '当前绑定的 IM 服务：', 'account_id' => '账户 ID：', 'unbind' => '解绑',
        'mfa' => '多因素认证', 'client' => '客户端', 'enable_mfa' => '使用两步认证登录', 'test_code' => '测试两步认证验证码', 'secret' => '密钥：', 'reset' => '重置', 'test' => '测试', 'set' => '设置',
        'change_password' => '修改登录密码', 'current_password' => '当前密码', 'new_password' => '新密码', 'confirm_password' => '确认密码', 'enter_current_password' => '请输入当前登录密码', 'enter_new_password' => '请输入新密码', 'enter_password_again' => '请再次输入新密码',
        'change_method' => '更换加密方式', 'method_help' => '不同的客户端支持的加密方式可能会有所不同，请参考客户端支持列表进行设置', 'reset_subscription' => '重置订阅地址', 'reset_subscription_help' => '重置订阅地址后，旧的订阅地址将无法获取配置，但节点配置仍能使用。如果希望作废旧节点配置请配合重置连接密码操作', 'reset_connection' => '重置连接密码', 'reset_connection_help' => '重置连接密码，重置后需更新订阅，才能继续使用', 'current_password_value' => '当前连接密码', 'current_uuid' => '当前 UUID', 'copy_uuid' => '复制用户 UUID',
        'daily_report' => '每日流量报告', 'no_receive' => '不接收', 'email_receive' => '邮件接收', 'im_receive' => 'IM 接收', 'preferred_contact' => '偏好的联系方式', 'contact_help' => '当 IM 未绑定时站点依然会向账户邮箱发送通知信息', 'email' => '邮件', 'theme' => '修改主题', 'theme_mode' => '修改主题模式', 'automatic' => '自动', 'light' => '浅色', 'dark' => '深色', 'language' => '语言', 'delete_data' => '删除账户数据', 'confirm_delete' => '确认删除', 'delete_title' => '删除确认', 'delete_help' => '请确认是否真的要删除你的账户，此操作无法撤销，你的所有账户数据将会被从服务器上彻底删除', 'enter_login_password' => '输入登录密码', 'cancel' => '取消', 'confirm' => '确认', 'bind_slack' => '绑定 Slack', 'bind_discord' => '绑定 Discord',
    ],
    'bot' => [
        'daily_job_run' => '成功执行每日任务',
        'detect_rule_added' => '新增了审计规则 %rule_name%',
        'diary' => '今日签到人数：%checkin_user%' . PHP_EOL . '今日使用总流量：%lastday_total%',
        'node_added' => '%node_name% 已被添加',
        'node_deleted' => '%node_name% 被删除了',
        'node_gfwed' => '%node_name% 节点被墙了',
        'node_offline' => '%node_name% 节点出现了一些故障',
        'node_online' => '%node_name% 节点恢复上线',
        'node_ungfwed' => '%node_name% 节点恢复了',
        'node_updated' => '%node_name% 已被修改',
        'order_created' => '订单 #%order_id% 已创建' . PHP_EOL . '链接：%order_link%',
        'test_message' => '测试消息',
        'ticket_created' => '工单 #%ticket_id% 已创建' . PHP_EOL . '链接：%ticket_link%',
        'user_join_welcome_free' => '欢迎 %user_name%',
        'user_join_welcome_paid' => '欢迎 VIP%user_class% 用户 %user_name% 加入群组',
        'user_not_bind' => '你未绑定本站账号，你可以进入网站的 **资料编辑**，在右下方绑定你的账号。',
    ],
];
