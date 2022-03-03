# 指定基于 php:7.3-fpm-alpine3.15 创建
FROM php:7.3-fpm-alpine3.15

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 修改时间
RUN apk add --no-cache --virtual .build-deps \
    tzdata \
    && cp "/usr/share/zoneinfo/${TZ}" /etc/localtime \
    && echo "${TZ}" > /etc/timezone

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    # 相关依赖必须手动安装
    curl \
    g++ \
    make \
    autoconf \
    # zip扩展 相关依赖
    libzip-dev \
    # GD库扩展 相关依赖
    libpng-dev \
    freetype-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    && docker-php-source extract \
    # 安装扩展
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include \
    --with-jpeg-dir=/usr/include \
    --with-png-dir=/usr/include \
    --with-webp-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip \
    && pecl install redis swoole \
    && docker-php-ext-enable redis swoole \
    && docker-php-source delete \
    && pecl clear-cache \
    && apk del .build-deps
