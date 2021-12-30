# 指定基于 php:7.4-fpm-alpine 创建
FROM php:7.4-fpm-alpine

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

# 安装redis扩展
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv phpredis-${PHPREDIS_VERSION} /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && rm -rf /usr/src/php \