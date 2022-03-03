# 指定基于 php:7.4-fpm-alpine3.15 创建
FROM php:7.4-fpm-alpine3.15

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 修改时间
RUN apk add --no-cache --virtual .build-deps \
    tzdata \
    && cp "/usr/share/zoneinfo/$TZ" /etc/localtime \
    && echo "$TZ" > /etc/timezone

RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    # 相关依赖必须手动安装
    autoconf \
    libpng-dev \
    freetype-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    # 安装扩展
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include \
    --with-jpeg=/usr/include \
    --with-webp=/usr/include \
    && docker-php-ext-install -j$(nproc) mysqli pdo_mysql gd \
    # 安装外部扩展
    && pecl install redis swoole \
    && docker-php-ext-enable redis swoole \
    && pecl clear-cache \
    && apk del .build-deps
