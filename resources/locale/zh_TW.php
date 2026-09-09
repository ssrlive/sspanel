<?php

declare(strict_types=1);

// Translations for Chinese(Used in one and only Republic of China(Taiwan))
return [
    'lang' => 'zh_TW',
    'lang_name' => '正體中文',
    'lang_code' => 'zh',
    'nav' => [
        'logout' => '登出', 'home' => '首頁', 'account' => '帳戶', 'edit' => '資料', 'invite' => '邀請',
        'usage' => '使用', 'nodes' => '節點', 'traffic_rate' => '流量倍率', 'support' => '支援',
        'announcements' => '公告', 'tickets' => '工單', 'docs' => '文件', 'audit' => '稽核',
        'rules' => '規則', 'logs' => '日誌', 'store' => '商店', 'products' => '商品',
        'orders' => '訂單', 'invoices' => '帳單', 'balance' => '餘額', 'admin' => '網站管理',
    ],
    'auth' => [
        'login_title' => '登入使用者中心', 'email' => '電子郵件', 'password' => '登入密碼', 'forgot_password' => '忘記密碼',
        'mfa' => '兩步驟驗證', 'mfa_placeholder' => '未設定兩步驟驗證可留空', 'remember_device' => '記住此裝置',
        'login' => '登入', 'no_account' => '還沒有帳戶？', 'register_link' => '點擊註冊', 'register_title' => '註冊帳戶',
        'nickname' => '暱稱', 'email_code' => '電子郵件驗證碼', 'get_code' => '取得', 'confirm_password' => '重複登入密碼',
        'invite_code' => '註冊邀請碼', 'optional' => '選填', 'required' => '必填', 'tos_agreement' => '我已閱讀並同意',
        'tos' => '服務條款與隱私權政策', 'register' => '註冊新帳戶', 'registration_closed' => '目前尚未開放註冊，請稍後再來看看',
        'has_account' => '已有帳戶？', 'login_link' => '點擊登入',
    ],
    'password_reset' => [
        'title' => '忘記密碼', 'description' => '我們將向你的註冊信箱寄送一封郵件，內容包含重設密碼的連結',
        'registered_email' => '註冊信箱', 'send_email' => '寄送郵件', 'new_password' => '新密碼',
        'new_password_placeholder' => '請輸入新密碼', 'confirm_new_password' => '再次輸入新密碼',
        'confirm_new_password_placeholder' => '請再次輸入新密碼', 'reset' => '重設',
    ],
    'datatable' => [
        'processing' => '處理中...', 'length_menu' => '顯示 _MENU_ 筆', 'zero_records' => '沒有符合結果',
        'info' => '第 _START_ 至 _END_ 筆結果，共 _TOTAL_ 筆', 'info_empty' => '第 0 至 0 筆結果，共 0 筆',
        'info_filtered' => '(在 _MAX_ 筆中尋找)', 'empty_table' => '表格中沒有資料', 'loading' => '載入中...',
        'first' => '首頁', 'previous' => '上一頁', 'next' => '下一頁', 'last' => '末頁',
        'sort_ascending' => ': 以升冪排列此欄', 'sort_descending' => ': 以降冪排列此欄',
    ],
    'bot' => [
        'daily_job_run' => '成功執行每日任務',
        'detect_rule_added' => '新增了稽核規則 %rule_name%',
        'diary' => '今日簽到人數：%checkin_user%' . PHP_EOL . '今日使用總流量：%lastday_total%',
        'node_added' => '%node_name% 已被加',
        'node_deleted' => '%node_name% 被刪除了',
        'node_gfwed' => '%node_name% 被牆了',
        'node_offline' => '%node_name% 出現了一些故障',
        'node_online' => '%node_name% 恢復上線',
        'node_ungfwed' => '%node_name% 恢復了',
        'node_updated' => '%node_name% 已被修改',
        'order_created' => '訂單 #%order_id% 已建立' . PHP_EOL . '連結：%order_link%',
        'test_message' => '測試訊息',
        'ticket_created' => '工單 #%ticket_id% 已建立' . PHP_EOL . '連結：%ticket_link%',
        'user_join_welcome_free' => '歡迎 %user_name%',
        'user_join_welcome_paid' => '歡迎 VIP%user_class% 使用者 %user_name% 加入群組',
        'user_not_bind' => '你未綁定本站帳號，你可以進入網站的 **資料編輯**，在右下方綁定你的帳號。',
    ],
];
