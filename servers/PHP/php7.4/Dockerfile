# 指定基于 php:7.4-fpm-alpine 创建
FROM php:7.4-fpm-alpine3.15

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

# 修改时间
RUN apk add --no-cache --virtual .build-deps \
    tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

RUN apk add --no-cache --virtual .build-deps \
            # 相关依赖必须手动安装
            curl \
            g++ \
            make \
            autoconf \
            libpng-dev \
            freetype-dev \
            libwebp-dev \
            libjpeg-turbo-dev \
            && docker-php-source extract \
            # 安装扩展
            && docker-php-ext-configure gd \
            --with-freetype-dir=/usr/include \
            --with-jpeg-dir=/usr/include \
            --with-png-dir=/usr/include \
            --with-webp-dir=/usr/include \
            && docker-php-ext-install -j$(nproc) pdo_mysql gd \
            && pecl install redis swoole \
            && docker-php-ext-enable redis swoole \
            && docker-php-source delete \
            && pecl clear-cache \
            && apk del .build-deps
