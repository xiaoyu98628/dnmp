#!/usr/bin/env bash

# 域名 使用 ; 隔开
export DOMAINS=$(echo "$SSL_DOMAINS" | tr -s ';')
# 服务厂商
export SSL_SERVER="$SSL_SERVER"
# 邮箱
export MAIL="$MAIL"
export DNS="$DNS"
# 生成证书的文件夹
export SSL_BASE_DIR="/usr/panel/ssl/nginx/nginx1.21"
export RELOAD_CMD="nginx -s reload"

if [ -z "$MAIL" ]; then
  echo "[$(date)] Empty env var MAIL, set MAIL=\"youmail@example.com\""
  MAIL="youmail@example.com"
fi

if [ -z "$DOMAINS" ]; then
  echo "[$(date)] Empty env var SSL_DOMAINS"
fi

mkdir -p ${SSL_BASE_DIR}/

function CreateDefault() {
  local domain=$1
  local ssl_dir="${SSL_BASE_DIR}/${domain}"
  mkdir -p ${ssl_dir}

  if [ -s "${ssl_dir}/${domain}_fullchain.pem" ]; then
    echo "[$(date)] default cert exists in :${ssl_dir}"
  else
    echo "[$(date)] create default cert to :${ssl_dir}"
    openssl req -x509 -newkey rsa:4096 -nodes -days 365 \
      -subj "/C=CA/ST=QC/O=Company Inc/CN=${domain}" \
      -out ${ssl_dir}/${domain}_fullchain.pem \
      -keyout ${ssl_dir}/${domain}_key.pem
    chmod +w ${ssl_dir}/*
  fi
}

function StartAcmesh() {
  echo "[$(date)] sleep 2 second to start Acme.sh..."
  sleep 2
  echo "[$(date)] Start Acme.sh..."
  echo "[$(date)] SSL_BASE_DIR :${SSL_BASE_DIR}"
  echo "[$(date)] MAIL :${MAIL}"
  echo "[$(date)] RELOAD_CMD :${RELOAD_CMD}"

  IFS=' '
  read -ra list <<<"$DOMAINS"

  for domain in "${list[@]}"; do
    local ssl_dir="${SSL_BASE_DIR}/${domain}"
    mkdir -p ${ssl_dir}

    # 判断当前证书是否存在，存在则跳出当前循环
    if [ -s "${ssl_dir}/${domain}_fullchain.pem"]; then
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

    echo "[$(date)] 1、acme.sh register .."
    /root/.acme.sh/acme.sh --register-account -m $MAIL

    echo "[$(date)] 2、acme.sh issue .."
    /root/.acme.sh/acme.sh --issue --nginx $ACME_DOMAIN_OPTION --renew-hook "${RELOAD_CMD}"

    echo "[$(date)] 3、acme.sh install-cert .."
    /root/.acme.sh/acme.sh --install-cert $ACME_DOMAIN_OPTION \
      --fullchain-file ${ssl_dir}/${domain}_fullchain.pem \
      --cert-file ${ssl_dir}/${domain}_cert.pem \
      --key-file ${ssl_dir}/${domain}_key.pem \
      --reloadcmd "${RELOAD_CMD}"
  done

  echo "[$(date)] Start acme.sh crond "
  crond
}

if [[ -n "$DOMAINS" ]]; then
  echo "[$(date)] 生成默认证书, 配置文件中使用，否则nginx启动会失败"
  IFS=' '
  read -ra list <<<"$DOMAINS"
  for domain in "${list[@]}"; do
    CreateDefault "$domain"
  done

  export -f StartAcmesh
  nohup bash -c StartAcmesh "${SSL_BASE_DIR}" "${RELOAD_CMD}" &
fi

echo "[$(date)] Start nginx"
nginx -g "daemon off;"
