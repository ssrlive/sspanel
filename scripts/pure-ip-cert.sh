#!/usr/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root." >&2
    exit 1
fi

function install_required_packages() {
    sudo apt-get update
    sudo apt-get install -y curl
}

function resolve_acme_sh_path() {
    local acme_path

    acme_path="$(command -v acme.sh 2>/dev/null || true)"
    if [ -n "$acme_path" ] && [ -x "$acme_path" ]; then
        printf '%s\n' "$acme_path"
        return 0
    fi

    acme_path="${HOME}/.acme.sh/acme.sh"
    if [ -x "$acme_path" ]; then
        printf '%s\n' "$acme_path"
        return 0
    fi

    return 1
}

function install_or_update_acme_sh() {
    local acme_path

    if ! acme_path="$(resolve_acme_sh_path)"; then
        curl -s https://get.acme.sh | sh -s
    else
        "${acme_path}" --upgrade --auto-upgrade
    fi
}

function resolve_hostaddr() {
  local hostaddr

  hostaddr=$(curl -4 -sS https://ip.sb 2>/dev/null || true)
  if [ -n "$hostaddr" ]; then
    printf '%s\n' "$hostaddr"
    return 0
  fi

  hostaddr=$(curl -6 -sS https://ip.sb 2>/dev/null || true)
  if [ -n "$hostaddr" ]; then
    printf '%s\n' "$hostaddr"
    return 0
  fi

  hostname -f 2>/dev/null || hostname
}

# 创建定时任务以自动续期证书
function create_cron_job_for_renewal() {
    local hostaddr=$1
    local cert_dir=$2
    local cron_script_path=${cert_dir}/renew_cert.sh
    cat > "$cron_script_path" <<EOL
#!/usr/bin/env bash

if [ "\$(id -u)" -ne 0 ]; then
    echo "Error: renew_cert.sh must be run as root." >&2
    exit 1
fi

hostaddr="${hostaddr}"
acme_path="\${HOME}/.acme.sh/acme.sh"
if [ ! -x "\$acme_path" ]; then
    echo "Error: acme.sh not found at \$acme_path." >&2
    exit 1
fi

sudo systemctl stop nginx
# \${acme_path} --renew-all --force
"\${acme_path}" --renew -d "\${hostaddr}" --force
sudo systemctl start nginx
EOL
    chmod +x "$cron_script_path"

    # 将定时任务添加到 crontab 中, 每2天凌晨 5 点执行一次
    local cron_job="0 5 */2 * * /usr/bin/env bash ${cron_script_path} >> ${cert_dir}/renewal.log 2>&1"
    if ! crontab -l 2>/dev/null | grep -F -q "$cron_script_path"; then
        (crontab -l 2>/dev/null; echo "$cron_job") | crontab
    fi
}

function main() {
    install_required_packages
    install_or_update_acme_sh

    local acme_sh_path="$(resolve_acme_sh_path)"
    if [ -z "$acme_sh_path" ]; then
        echo "Error: acme.sh was installed, but its executable path could not be resolved." >&2
        exit 1
    fi

    local hostaddr=$(resolve_hostaddr)
    if [ -z "$hostaddr" ]; then
        echo "Error: Unable to resolve host IP address."
        exit 1
    fi

    # 取回当前账号的 home 目录
    local home_dir=$(eval echo "~$USER")

    # 拼装 acme.sh 的生成的证书的默认存储路径
    local cert_dir="${home_dir}/.acme.sh/${hostaddr}_ecc"
    mkdir -p "$cert_dir"

    # 取回当前脚本的路径
    local script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

    # 执行命令 ${script_dir}/share_dir.sh 将证书存储路径的权限设置为
    # 当前用户 和 `www-data` 账号都可读写
    bash "${script_dir}/share_dir.sh" "$cert_dir" "www-data"

    # 使用 acme.sh 以 standalone 模式申请证书, 申请的证书默认存储在
    # ~/.acme.sh/${hostaddr}_ecc 目录下, 申请的证书有效期为 3 天
    sudo systemctl stop nginx
    "${acme_sh_path}" --issue --standalone -d "${hostaddr}" --server letsencrypt --certificate-profile shortlived --days 3 --force --keylength ec-256 --cert-file "${cert_dir}/fullchain.cer" --key-file "${cert_dir}/private.key"
    sudo systemctl start nginx

    # 创建定时任务以自动续期证书
    create_cron_job_for_renewal ${hostaddr} ${cert_dir}
}

main
