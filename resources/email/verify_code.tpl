<html>

{include file='header.tpl'}

<body style="background-color:#EEEEEE;">
    <div style="text-align: center">
        <div border="0" cellpadding="0" cellspacing="0" width="100%"
            style="padding-top:30px;table-layout:fixed;background-color:#EEEEEE;">
            <div align="center" valign="top" style="padding-right:10px;padding-left:10px;">
                <div border="0" cellpadding="0" cellspacing="0"
                    style="background-color:#FFFFFF;max-width:600px;text-align:center;" width="100%">
                    <div align="center" valign="top">
                        <div border="0" cellpadding="0" cellspacing="0" width="100%">
                            <div align="center" valign="middle" style="padding-top:60px;padding-bottom:60px;">
                                <h2 class="bigTitle">
                                    邮箱验证
                                </h2>
                            </div>
                        </div>
                        <div border="0" cellpadding="0" cellspacing="0" style="background-color:#FFFFFF" width="100%">
                            <div align="center" valign="top"
                                style="padding-bottom:60px;padding-left:20px;padding-right:20px;">
                                <p class="midText">
                                    你请求的邮箱验证代码为:<b style="color:#505050">{$code}</b> <br>
                                    本验证代码在 {$expire} 前有效。<br>
                                    如果此验证码非你本人申请，请忽视此邮件。<br>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                {include file='footer.tpl'}
            </div>
        </div>
    </div>
</body>

</html>