# 指定基于 nginx:1.21-alpine 创建
FROM nginx:1.21-alpine

LABEL org.opencontainers.image.authors="XiaoYu <1765841705@qq.com>"

ARG TZ
ARG CONTAINER_PACKAGE_URL
ARG NGINX_REGISTER_ACME_MAIL_1_21

# 资源替换 更换镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ]; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories; fi

WORKDIR /acme.sh
ADD config/acme.sh /acme.sh

RUN apk update && apk upgrade \
    && if [ ${TZ} ]; then apk add --no-cache --virtual .build-deps tzdata && cp -r "/usr/share/zoneinfo/${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone; fi \
    && apk add --no-cache openssl bash cronie dos2unix \
    # 安装 acme.sh
    && chmod +x /acme.sh/acme.sh \
    # 修改换行格式
    && dos2unix /acme.sh/acme.sh \
    && bash ./acme.sh --install -m ${NGINX_REGISTER_ACME_MAIL_1_21} \
    && ln -s ~/.acme.sh/acme.sh /usr/local/bin/acme.sh \
    && rm -rf /acme.sh \
    && apk del .build-deps

ADD config/extensions/nginx-ssl-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx-ssl-setup.sh

WORKDIR /usr/share/nginx/html

ENTRYPOINT ["/usr/local/bin/nginx-ssl-setup.sh"]