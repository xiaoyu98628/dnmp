#!/usr/bin/env bash

# 日志文件
LOG_FILE="/var/log/nginx/nginx-ssl-setup.log"

# 域名 使用 ; 隔开
# shellcheck disable=SC2155
export DOMAINS=$(echo "$SSL_DOMAINS" | tr -s ';' ' ')
# 服务厂商
export SSL_SERVER="$SSL_SERVER"
export DNS="$SSL_DNS"
# 生成证书的文件夹
export SSL_BASE_DIR="$SSL_BASE_DIR"
export RELOAD_CMD="$RELOAD_CMD"

# 检查域名变量
if [ -z "$DOMAINS" ]; then
  echo "[$(date)] ERROR: Empty env var SSL_DOMAINS" | tee -a "$LOG_FILE"
fi

# 设置默认 SSL 目录和重载命令
if [ -z "$SSL_BASE_DIR" ]; then
  echo "[$(date)] INFO: Empty env var SSL_BASE_DIR, setting default SSL_BASE_DIR=\"/usr/panel/ssl/nginx/nginx1.21\"" | tee -a "$LOG_FILE"
  SSL_BASE_DIR="/usr/panel/ssl/nginx/nginx1.21"
fi

if [ -z "$RELOAD_CMD" ]; then
  echo "[$(date)] INFO: Empty env var RELOAD_CMD, setting default RELOAD_CMD=\"nginx -s reload\"" | tee -a "$LOG_FILE"
  RELOAD_CMD="nginx -s reload"
fi

# 创建SSL证书目录
mkdir -p ${SSL_BASE_DIR}/ || { echo "[$(date)] ERROR: Failed to create SSL base directory"; exit 1; }

# 函数：启动acme.sh并处理证书
function StartAcmeSh() {
  echo "[$(date)] INFO: Starting Acme.sh..." | tee -a "$LOG_FILE"
  sleep 2  # Sleep for 2 seconds before starting
  echo "[$(date)] INFO: Using SSL_BASE_DIR: ${SSL_BASE_DIR} and RELOAD_CMD: ${RELOAD_CMD}" | tee -a "$LOG_FILE"

  IFS=' ' read -ra list <<<"$DOMAINS"
  for domain in "${list[@]}"; do
    local ssl_dir="${SSL_BASE_DIR}/${domain}"
    mkdir -p ${ssl_dir} || { echo "[$(date)] ERROR: Failed to create SSL directory for $domain"; continue; }

    ACME_DOMAIN_OPTION="-d ${domain}"
    if [[ -n "$DNS" ]]; then
      ACME_DOMAIN_OPTION+=" --dns $DNS"
    fi

    echo "[$(date)] INFO: Issuing cert for $domain with options $ACME_DOMAIN_OPTION" | tee -a "$LOG_FILE"

    if [[ -n "$SSL_SERVER" ]]; then
      /root/.acme.sh/acme.sh --set-default-ca --server $SSL_SERVER
    fi

    echo "[$(date)] INFO: Running acme.sh to issue certificate..." | tee -a "$LOG_FILE"
    /root/.acme.sh/acme.sh --issue --nginx $ACME_DOMAIN_OPTION --renew-hook "${RELOAD_CMD}"

    echo "[$(date)] INFO: Installing certificate for $domain..." | tee -a "$LOG_FILE"
    /root/.acme.sh/acme.sh --install-cert $ACME_DOMAIN_OPTION \
      --fullchain-file ${ssl_dir}/${domain}.pem \
      --key-file ${ssl_dir}/${domain}.key \
      --reloadcmd "${RELOAD_CMD}"

  done

  echo "[$(date)] INFO: Starting acme.sh cron job..." | tee -a "$LOG_FILE"
  crond
}

# 如果域名存在，则启动 acme.sh
if [[ -n "$DOMAINS" ]]; then
  export -f StartAcmeSh
  nohup bash -c StartAcmeSh "${SSL_BASE_DIR}" "${RELOAD_CMD}" &>> "$LOG_FILE" &
fi

echo "[$(date)] INFO: Starting Nginx..." | tee -a "$LOG_FILE"
nginx -g "daemon off;"