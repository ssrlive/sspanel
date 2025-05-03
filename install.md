sspanel installation tutorial
---------------------------------------------

> 本教程是基于 `Ubuntu 22.04` 系统的安装教程，其他系统可能会有所不同。

## Install `LEMP`

系統需求：
- Git
- Nginx（HTTPS configured）
- PHP 8.2+ （OPcache+JIT enabled）
- PHP Redis extension 6.0+
- MySQL 8.0+
- Redis 7.0+

請首先用 `sudo -i` 命令切換到 `root` 權限，再往下進行。

```bash
sudo ufw disable

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y curl gnupg2 ca-certificates apt-transport-https git lsb-release ubuntu-keyring

# 設置 php 官方版本的安裝源
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:ondrej/php

sudo apt remove apache2 -y
sudo apt autoremove -y
sudo apt update -y

sudo apt install -y nginx-extras mysql-server redis python3 python-is-python3 php-fpm
sleep 2
sudo apt install -y php-xmlrpc php php-json
sudo apt install -y php-{bcmath,bz2,cli,common,curl,fpm,gd,igbinary,mbstring,mysql,readline,redis,xml,yaml,zip}

sudo apt remove apache2 -y
sudo apt autoremove -y

sudo systemctl restart php8.4-fpm
```

> 如何刪除舊版 PHP? 比如 `php8.3`, 可以使用命令 `sudo apt remove 'php8.3*' -y` 然後 `sudo apt autoremove -y` 來刪除所有舊版 PHP 相關的包。

參考文章： https://portal.databasemart.com/kb/a2136/how-to-install-php-8_1-for-nginx-on-ubuntu-20_04.aspx

## **部署 SSPanel**

请自行将以下所有的 `/var/www/sspanel` 替换为你想要的文件夹名称。

### **0x41 安装网站程序**

```bash
mkdir -p /var/www/sspanel
cd /var/www/sspanel
chmod -R 755 ${PWD}
chown -R www-data:www-data ${PWD}

git clone --depth=1 -b main https://github.com/ssrlive/sspanel.git ${PWD}
git config --global --add safe.directory ${PWD}
git config core.filemode false
git checkout .

wget https://getcomposer.org/installer -O composer.phar
php composer.phar
php composer.phar install
```

### **0x42 配置 nginx 配置文件**

移除默認配置文件 default 。

```bash
mv /etc/nginx/sites-enabled/default /nginx-default
```

在 `/etc/nginx/conf.d/` 查找是否有 `.conf` 後綴的文件，如果有，就直接在裏面添加配置，
如果沒有，就新建一個文件，比如 `sspanel.conf`。
在 `/etc/nginx/conf.d/sspanel.conf` 文件中写入以下参考配置：

- 對於未配置 HTTPS 的網站，使用以下配置：
```nginx
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name mysite.com www.mysite.com; # 改成你自己的域名
        index index.php index.html index.htm index.nginx-debian.html;
        root /var/www/sspanel/public;

        location /.well-known/acme-challenge/ {
        }

        location ~ \\.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        }

        location / {
            try_files $uri /index.php$is_args$args;
        }
    }
```

- 對於已配置了 HTTPS 的網站， 可以如下設置。 注意 `ssl_certificate` 和 `ssl_certificate_key` 项。
```nginx
    server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        ssl_certificate       /fakesite_cert/chained_cert.pem; # 改成你自己的证书路径
        ssl_certificate_key   /fakesite_cert/private_key.pem; # 改成你自己的私鑰路径
        ssl_protocols         TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers           HIGH:!aNULL:!MD5;
        server_name sspanel.host;   # 改成你自己的域名
        root /var/www/sspanel/public;       # 改成你自己的路径
        index index.php index.html index.htm index.nginx-debian.html;

        location / {
            # 伪静态代码
            try_files $uri /index.php$is_args$args;
        }

        location ~ \\.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php8.4-fpm.sock;
        }
    }
```

上面配置中 `fastcgi_pass unix:/run/php/php8.4-fpm.sock;` 語句的值必須自己改正確，
可以用命令 `ls /run/php/`  查看它的確切值，我這裏實際上是  `php8.4-fpm.sock` 我就使用了它。

添加完成后使用命令 `nginx -t` 檢查，無誤後用命令 `systemctl restart nginx` 重启 Nginx。

至此 Nginx 配置完成。

### **0x43 创建数据库**

使用命令 `sudo mysql -u root -p` 並輸入密碼以後，即登录数据库，执行以下命令：
```sql
mysql> CREATE USER 'sspanel'@'localhost' IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'sspanel'@'localhost' WITH GRANT OPTION;

mysql> CREATE DATABASE sspanel;
mysql> USE sspanel;

mysql> FLUSH PRIVILEGES;

mysql> exit
```
這些命令創建名爲 `sspanel` 的數據庫，並創建一個用戶 `sspanel` ，密碼是 `password` ，並賦予其所有權限。

### **0x44 修改 sql 模式**

> 這一步必須做，否則會出現 500 錯誤黑屏。

給 `/etc/mysql/mysql.conf.d/mysqld.cnf` 文件末尾追加一行 `sql_mode = ""` ，使用下列命令：

```bash
sed -i '$asql_mode = ""\\n' /etc/mysql/mysql.conf.d/mysqld.cnf
```

然後重啓 mysql 服務

```bash
systemctl restart mysql
```

### **0x45 配置网站程序**

```bash
cd /var/www/sspanel/

cp config/.config.example.php config/.config.php
cp config/appprofile.example.php config/appprofile.php

vi config/.config.php
```

请按照自己的需求修改 config/.config.php，配置项比较多可以以后再改。为了下一步的正确执行请先务必确保数据库连接信息正确。

找到以下部分

`db_host` 如果使用本地数据库，填 `localhost` 或 `127.0.0.1` , 
如果使用云数据库，填写 `ip` 或域名，并注意允许服务器 `ip` 连接
`db_socket` 可留空，或根据文件上方注释填写
注意数据库账户需要有对表结构的操作权限
数据库名默认是 `sspanel` ，可修改为你上一步創建數據庫時指定的名稱。注意创建的库名需与在此填写的保持一致

```php
$_ENV['db_driver']    = 'mysql';
$_ENV['db_host']      = '127.0.0.1';
$_ENV['db_socket']    = '';
$_ENV['db_database']  = 'sspanel';              //数据库名
$_ENV['db_username']  = 'sspanel';              //数据库用户名
$_ENV['db_password']  = 'password';             //用户名对应的密码
```

还需要依照注释，修改这些重要的参数

```php
$_ENV['key']        = '1145141919810';          // !!! 瞎 jb 修改此 key 为随机字符串, 用以确保网站安全 !!!
$_ENV['debug']      = false;                    // 正式环境请确保为 false
$_ENV['appName']    = 'SSPanel-UIM';            // 站点名称
$_ENV['baseUrl']    = 'https://sspanel.host';   // 站点地址
$_ENV['muKey']      = 'NimaQu';                 // 用于校验后端请求，可以随意修改，但保持前后端一致，否则节点不工作！
```

导入表结构

```bash
php xcat Migration new
```

### **0x46 创建管理员并同步用户**

依次执行以下命令：

```bash
php xcat Tool importSetting # 导入配置项目
php xcat Tool createAdmin # 创建管理员账户
```

> 如果创建管理员出错, 请检查 `config/.config.php` 中的数据库连接信息。

下載各種客戶端
```bash
sudo -u www-data /usr/bin/php xcat ClientDownload
```

### **0x47 配置定时任务**

执行 `crontab -e` 指令设置 SSPanel 的基本 cron 任务：

```bash
*/1 * * * * /usr/local/php/bin/php /sspanel/xcat  Job CheckJob
0 */1 * * * /usr/local/php/bin/php /sspanel/xcat  Job UserJob
0 0 * * * /usr/local/php/bin/php -n /sspanel/xcat Job DailyJob
```

设置财务报表：

```bash
5 0 * * * /usr/local/php/bin/php /sspanel/xcat FinanceMail day
6 0 * * 0 /usr/local/php/bin/php /sspanel/xcat FinanceMail week
7 0 1 * * /usr/local/php/bin/php /sspanel/xcat FinanceMail month
```

设置节点 GFW 检测：

```bash
*/1 * * * * /usr/local/php/bin/php /sspanel/xcat DetectGFW
```

### **0x48** 如何同步更新

如果你使用原版主题 `mian`分支，可以在网站根目录下执行以下命令

```bash
git pull
```

这会与 `github` 上的 `main` 分支同步文件变动。有时候，光这么做可能不够，你可能还需要

```bash
composer update
vendor/bin/phinx migrate
php xcat Tool importAllSettings
```

同时需要注意有没有什么参数在 `.config.example.php` 文件中有，
而在你的 `.config.php` 文件中没有的（你可以谷歌一些在线文本比对工具来方便排查）
