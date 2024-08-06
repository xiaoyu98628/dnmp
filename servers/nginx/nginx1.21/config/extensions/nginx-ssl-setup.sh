#!/usr/bin/env bash

# 域名 使用 ; 隔开
export DOMAINS=$(echo "$SSL_DOMAINS" | tr -s ';' ' ')
# 服务厂商
export SSL_SERVER="$SSL_SERVER"
export DNS="$SSL_DNS"
# 生成证书的文件夹
export SSL_BASE_DIR="$SSL_BASE_DIR"
export RELOAD_CMD="$RELOAD_CMD"

# 检查域名变量
if [ -z "$DOMAINS" ]; then
  echo "[$(date)] Empty env var SSL_DOMAINS"
fi

# 存放和设置默认证书的文件夹
if [ -z "$SSL_BASE_DIR" ]; then
  echo "[$(date)] Empty env var SSL_BASE_DIR, set SSL_BASE_DIR=\"/usr/panel/ssl/nginx/nginx1.21\""
  SSL_BASE_DIR="/usr/panel/ssl/nginx/nginx1.21"
fi

if [ -z "$RELOAD_CMD" ]; then
  echo "[$(date)] Empty env var RELOAD_CMD, set RELOAD_CMD=\"nginx -s reload\""
  RELOAD_CMD="nginx -s reload"
fi

# 创建SSL证书目录
mkdir -p ${SSL_BASE_DIR}/

# 函数：启动acme.sh并处理证书
function StartAcmeSh() {
  echo "[$(date)] sleep 2 second to start Acme.sh..."
  sleep 2
  echo "[$(date)] Start Acme.sh..."
  echo "[$(date)] SSL_BASE_DIR :${SSL_BASE_DIR}"
  echo "[$(date)] RELOAD_CMD :${RELOAD_CMD}"

  IFS=' '
  read -ra list <<<"$DOMAINS"

  for domain in "${list[@]}"; do
    local ssl_dir="${SSL_BASE_DIR}/${domain}"
    mkdir -p ${ssl_dir}

    # 判断当前证书是否存在，存在则跳出当前循环
    if [ -s "${ssl_dir}/${domain}.fullchain.pem"]; then
      echo "[$(date)] Certificate already exists for $domain, skipping issuance"
      continue
    fi

    ACME_DOMAIN_OPTION="-d ${domain}"
    if [[ -n "$DNS" ]]; then
      ACME_DOMAIN_OPTION+=" --dns $DNS"
    fi

    echo "[$(date)] Issue the cert: $domain with options $ACME_DOMAIN_OPTION"

    if [[ -n "$SSL_SERVER" ]]; then
      /root/.acme.sh/acme.sh --set-default-ca --server $SSL_SERVER
    fi

    echo "[$(date)] 2、acme.sh issue .."
    /root/.acme.sh/acme.sh --issue --nginx $ACME_DOMAIN_OPTION --renew-hook "${RELOAD_CMD}"

    echo "[$(date)] 3、acme.sh install-cert .."
    /root/.acme.sh/acme.sh --install-cert $ACME_DOMAIN_OPTION \
      --fullchain-file ${ssl_dir}/${domain}.fullchain.pem \
      --cert-file ${ssl_dir}/${domain}.cert.pem \
      --key-file ${ssl_dir}/${domain}.key \
      --reloadcmd "${RELOAD_CMD}"
  done

  echo "[$(date)] Start acme.sh crond "
  crond
}

if [[ -n "$DOMAINS" ]]; then
  export -f StartAcmeSh
  nohup bash -c StartAcmeSh "${SSL_BASE_DIR}" "${RELOAD_CMD}" &
fi

echo "[$(date)] Start nginx"
nginx -g "daemon off;"