# 指定基于 node:19.0-alpine 创建
FROM node:19.0-alpine

LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

ARG CONTAINER_PACKAGE_URL
ARG TZ

# 资源替换 阿里云镜像
RUN sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories

# 更新apk 修改时间
RUN apk update && apk upgrade \
    && apk add --no-cache --virtual .build-deps tzdata \
    && cp -r "/usr/share/zoneinfo/${TZ}" /etc/localtime \
    && echo "${TZ}" > /etc/timezone

# npm 资源替换 安装vue脚手架
RUN npm install -g nrm \
    && nrm use taobao \
    && npm install -g @vue/cli