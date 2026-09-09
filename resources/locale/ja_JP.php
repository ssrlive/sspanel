<?php

declare(strict_types=1);

// Translations for Japanese
return [
    'lang' => 'ja_JP',
    'lang_name' => '日本語',
    'lang_code' => 'ja',
    'nav' => [
        'logout' => 'ログアウト', 'home' => 'ホーム', 'account' => 'アカウント', 'edit' => 'プロフィール',
        'invite' => '招待', 'usage' => '利用', 'nodes' => 'ノード', 'traffic_rate' => '通信倍率',
        'support' => 'サポート', 'announcements' => 'お知らせ', 'tickets' => 'チケット', 'docs' => 'ドキュメント',
        'audit' => '監査', 'rules' => 'ルール', 'logs' => 'ログ', 'store' => 'ストア', 'products' => '商品',
        'orders' => '注文', 'invoices' => '請求書', 'balance' => '残高', 'admin' => 'サイト管理',
    ],
    'auth' => [
        'login_title' => 'ユーザーセンターにログイン', 'email' => 'メールアドレス', 'password' => 'ログインパスワード',
        'forgot_password' => 'パスワードを忘れましたか？', 'mfa' => '二段階認証', 'mfa_placeholder' => '二段階認証を設定していない場合は空欄',
        'remember_device' => 'この端末を記憶する', 'login' => 'ログイン', 'no_account' => 'アカウントをお持ちでないですか？',
        'register_link' => '登録する', 'register_title' => 'アカウントを登録', 'nickname' => 'ニックネーム',
        'email_code' => 'メール認証コード', 'get_code' => '取得', 'confirm_password' => 'パスワードの確認',
        'invite_code' => '招待コード', 'optional' => '任意', 'required' => '必須', 'tos_agreement' => '以下に同意します：',
        'tos' => '利用規約とプライバシーポリシー', 'register' => '新規登録',
        'registration_closed' => '現在登録を受け付けていません。しばらくしてから再度お試しください。',
        'has_account' => 'すでにアカウントをお持ちですか？', 'login_link' => 'ログイン',
    ],
    'password_reset' => [
        'title' => 'パスワードを忘れた場合', 'description' => '登録メールアドレスにパスワード再設定用リンクを送信します',
        'registered_email' => '登録メールアドレス', 'send_email' => 'メールを送信', 'new_password' => '新しいパスワード',
        'new_password_placeholder' => '新しいパスワードを入力', 'confirm_new_password' => '新しいパスワードの確認',
        'confirm_new_password_placeholder' => '新しいパスワードを再入力', 'reset' => 'リセット',
    ],
    'datatable' => [
        'processing' => '処理中...', 'length_menu' => '_MENU_ 件を表示', 'zero_records' => '一致する結果がありません',
        'info' => '_TOTAL_ 件中 _START_ から _END_ 件を表示', 'info_empty' => '0 件中 0 から 0 件を表示',
        'info_filtered' => '(_MAX_ 件から検索)', 'empty_table' => 'テーブルにデータがありません', 'loading' => '読み込み中...',
        'first' => '先頭', 'previous' => '前へ', 'next' => '次へ', 'last' => '最後',
        'sort_ascending' => ': 昇順に並べ替え', 'sort_descending' => ': 降順に並べ替え',
    ],
    'bot' => [
        'daily_job_run' => '日次タスクの正常な実行',
        'detect_rule_added' => '追加された監査ルール %rule_name%',
        'diary' => '今日チェックインした人の数: %checkin_user%' . PHP_EOL . '今日使用された合計トラフィック: %lastday_total%',
        'node_added' => '%node_name% が追加されました',
        'node_deleted' => '%node_name% が削除されました',
        'node_gfwed' => '%node_name% はブロックされています',
        'node_offline' => '%node_name% にはいくつかの障害があります',
        'node_online' => '%node_name% はオンラインに戻りました',
        'node_ungfwed' => '%node_name% が回復しました',
        'node_updated' => '%node_name% が変更されました',
        'order_created' => 'オーダー #%order_id% が作成されました' . PHP_EOL . 'リンク: %order_link%',
        'test_message' => 'テストメッセージ',
        'ticket_created' => 'チケット #%ticket_id% が作成されました' . PHP_EOL . 'リンク: %ticket_link%',
        'user_join_welcome_free' => 'ようこそ %user_name%',
        'user_join_welcome_paid' => 'VIP%user_class% ユーザー %user_name% のグループへの参加を歓迎します',
        'user_not_bind' => 'アカウントをこの Web サイトにバインドしていません。Web サイトの **データ編集** に入り、右下隅でアカウントをバインドできます。',
    ],
];
