# 指定基于 php:7.3-fpm-alpine3.13 创建
FROM php:7.3-fpm-alpine3.13

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 编码转换库
RUN apk add gnu-libiconv --no-cache --repository http://${CONTAINER_PACKAGE_URL}/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# 修改时间
RUN apk add --no-cache --virtual .build-deps \
    tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    # 相关依赖必须手动安装
    autoconf \
    g++ \
    make \
    # zip扩展 相关依赖
    libzip-dev \
    # GD库扩展 相关依赖
    libpng-dev \
    freetype-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    # 安装扩展
    && docker-php-source extract  \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include \
    --with-jpeg-dir=/usr/include \
    --with-png-dir=/usr/include \
    --with-webp-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) \
    gd \
    pdo_mysql \
    mysqli \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-source delete \
    && pecl clear-cache \
    && apk del .build-deps
