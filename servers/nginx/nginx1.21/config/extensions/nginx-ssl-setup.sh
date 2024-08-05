#!/usr/bin/env bash

export DOMAINS=$(echo "$SslDomains" | tr -s ';')
export SslServer="$SslServer"
export mail="$mail"
export SSL_BASE_DIR="/etc/nginx/ssl"
export RELOAD_CMD="nginx -s reload"

if [ -z "$mail" ]; then
  echo "[$(date)] Empty env var mail, set mail=\"youmail@example.com\""
  mail="youmail@example.com"
fi

if [ -z "$DOMAINS" ]; then
  echo "[$(date)] Empty env var SslDomains"
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
  echo "[$(date)] mail :${mail}"
  echo "[$(date)] RELOAD_CMD :${RELOAD_CMD}"

  IFS=' '
  read -ra list <<<"$DOMAINS"

  for domain in "${list[@]}"; do
    local ssl_dir="${SSL_BASE_DIR}/${domain}"
    mkdir -p ${ssl_dir}

    ACME_DOMAIN_OPTION="-d ${domain}"
    if [[ -n "$dns" ]]; then
      ACME_DOMAIN_OPTION+=" --dns $dns"
    fi

    echo "[$(date)] Issue the cert: $domain with options $ACME_DOMAIN_OPTION"

    if [[ -n "$SslServer" ]]; then
      /root/.acme.sh/acme.sh --set-default-ca --server $SslServer
    fi

    echo "[$(date)] 1、acme.sh register .."
    /root/.acme.sh/acme.sh --register-account -m $mail

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
