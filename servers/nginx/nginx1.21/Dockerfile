# 指定基于 nginx:1.21-alpine 创建
FROM nginx:1.21-alpine

LABEL org.opencontainers.image.authors="XiaoYu <1765841705@qq.com>"

RUN apk update && apk upgrade \
    && apk add --no-cache bash crond curl \
    && curl https://get.acme.sh | sh \
    && ln -s ~/.acme.sh/acme.sh /usr/local/bin/acme.sh

ADD config/extensions/nginx-ssl-setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx-ssl-setup.sh

ENTRYPOINT ["/usr/local/bin/nginx-ssl-setup.sh"]
