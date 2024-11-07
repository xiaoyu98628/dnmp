# 指定基于 nginx:1.21-alpine 创建
FROM nginx:1.21-alpine

LABEL org.opencontainers.image.authors="XiaoYu <1765841705@qq.com>"

ARG TZ
ARG CONTAINER_PACKAGE_URL
ARG NGINX_REGISTER_ACME_MAIL_1_21

# 资源替换 更换镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ]; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories; fi

# 修改时间
RUN if [ ${TZ} ]; then apk add --no-cache --virtual .time-deps tzdata && cp -r "/usr/share/zoneinfo/${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone && apk del .time-deps; fi

WORKDIR /acme.sh
ADD config/acme.sh /acme.sh
ADD config/extensions/nginx-ssl-setup.sh /usr/local/bin/

RUN apk update && apk upgrade \
    && apk add --no-cache openssl bash cronie  \
    && chmod +x /acme.sh/acme.sh \
    && apk add --no-cache --virtual .build-deps dos2unix \
    # 修改换行格式 将 Windows 下 CRLF 转换成 LF
    && dos2unix /acme.sh/acme.sh \
    # 安装 acme.sh
    && bash ./acme.sh --install -m ${NGINX_REGISTER_ACME_MAIL_1_21} \
    && ln -s ~/.acme.sh/acme.sh /usr/local/bin/acme.sh \
    # 容器生成自动生成证书所需脚本
    && chmod +x /usr/local/bin/nginx-ssl-setup.sh \
    # 修改换行格式 将 Windows 下 CRLF 转换成 LF
    && dos2unix /usr/local/bin/nginx-ssl-setup.sh \
    && rm -rf /acme.sh \
    && apk del .build-deps

WORKDIR /usr/share/nginx/html

ENTRYPOINT ["/usr/local/bin/nginx-ssl-setup.sh"]