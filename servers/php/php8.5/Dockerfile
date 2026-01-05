# 指定基于 php:8.5-fpm-alpine 创建
FROM php:8.5-fpm-alpine

# 维护者信息
LABEL maintainer="XiaoYu <1765841705@qq.com>" \
    version="8.5" \
    description="PHP 8.5 FPM with common extensions based on Alpine Linux"

ARG CONTAINER_PACKAGE_URL
ARG PHP_EXTENSIONS
ARG COMPOSER_IMAGE_URL
ARG TZ

ENV EXTENSIONS=",${PHP_EXTENSIONS},"

# 资源替换 更换镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ]; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories; fi

# 修改时间
RUN if [ ${TZ} ]; then apk add --no-cache --virtual .fetch-deps tzdata && cp -r "/usr/share/zoneinfo/${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone && apk del .fetch-deps; fi

# 引入 composer
COPY --from=composer/composer:latest /usr/bin/composer /usr/bin/composer
# 引入 install-php-extensions 脚本 方便容器内安装扩展
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/

# 引入 docker-entrypoint 脚本 清理残留 socket 文件
ADD ./config/extensions/docker-entrypoint /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint \
    && apk add --no-cache --virtual .dos-deps dos2unix \
    # 修改换行格式 将 Windows 下 CRLF 转换成 LF \
    && dos2unix /usr/local/bin/docker-entrypoint \
    && apk del .dos-deps

# 更新包索引 安装扩展
RUN apk update && apk upgrade \
    && docker-php-source extract \
    && if [ ${PHP_EXTENSIONS} ]; \
        then \
            apk add --no-cache --virtual .build-deps autoconf g++ make libtool linux-headers \
            && apk add --no-cache libstdc++ \
            # 更新 PECL 通道 \
            && pecl update-channels; \
        fi \
    && if [ -z "${EXTENSIONS##*,pdo_mysql,*}" ]; \
        then \
            echo "---------- Install pdo_mysql ----------" \
            && docker-php-ext-install -j$(nproc) pdo_mysql; \
        fi \
    && if [ -z "${EXTENSIONS##*,pcntl,*}" ]; \
        then \
            echo "---------- Install pcntl ----------" \
            && docker-php-ext-install -j$(nproc) pcntl; \
        fi \
    && if [ -z "${EXTENSIONS##*,mysqli,*}" ]; \
        then \
            echo "---------- Install mysqli ----------" \
            && docker-php-ext-install -j$(nproc) mysqli; \
        fi \
    && if [ -z "${EXTENSIONS##*,exif,*}" ]; \
        then \
            echo "---------- Install exif ----------" \
            && docker-php-ext-install -j$(nproc) exif; \
        fi \
    && if [ -z "${EXTENSIONS##*,bcmath,*}" ]; \
        then \
            echo "---------- Install bcmath ----------" \
            && docker-php-ext-install -j$(nproc) bcmath; \
        fi \
    && if [ -z "${EXTENSIONS##*,gettext,*}" ]; \
        then \
            echo "---------- Install gettext ----------" \
            && apk add --no-cache gettext-dev \
            && docker-php-ext-install -j$(nproc) gettext; \
        fi \
    && if [ -z "${EXTENSIONS##*,gd,*}" ]; \
        then \
            echo "---------- Install gd ----------" \
            && apk add --no-cache libjpeg-turbo-dev libwebp-dev libpng-dev freetype-dev \
            && docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include --with-webp=/usr/include \
            && docker-php-ext-install -j$(nproc) gd; \
        fi \
    && if [ -z "${EXTENSIONS##*,sockets,*}" ]; \
        then \
            echo "---------- Install sockets ----------" \
            && docker-php-ext-install -j$(nproc) sockets; \
        fi \
    && if [ -z "${EXTENSIONS##*,shmop,*}" ]; \
        then \
            echo "---------- Install shmop ----------" \
            && docker-php-ext-install -j$(nproc) shmop; \
        fi \
    && if [ -z "${EXTENSIONS##*,intl,*}" ]; \
        then \
            echo "---------- Install intl ----------" \
            && apk add --no-cache icu-dev \
            && docker-php-ext-install -j$(nproc) intl; \
        fi \
    && if [ -z "${EXTENSIONS##*,bz2,*}" ]; \
        then \
            echo "---------- Install bz2 ----------" \
            && apk add --no-cache bzip2-dev \
            && docker-php-ext-install -j$(nproc) bz2; \
        fi \
    && if [ -z "${EXTENSIONS##*,calendar,*}" ]; \
        then \
            echo "---------- Install calendar ----------" \
            && docker-php-ext-install -j$(nproc) calendar; \
        fi \
    && if [ -z "${EXTENSIONS##*,snmp,*}" ]; \
        then \
            echo "---------- Install snmp ----------" \
            && apk add --no-cache net-snmp-dev \
            && docker-php-ext-install -j$(nproc) snmp; \
        fi \
    && if [ -z "${EXTENSIONS##*,soap,*}" ]; \
        then \
            echo "---------- Install soap ----------" \
            && apk add --no-cache libxml2-dev \
            && docker-php-ext-install -j$(nproc) soap; \
        fi \
    && if [ -z "${EXTENSIONS##*,sysvsem,*}" ]; \
        then \
            echo "---------- Install sysvsem ----------" \
            && docker-php-ext-install -j$(nproc) sysvsem; \
        fi \
    && if [ -z "${EXTENSIONS##*,sysvshm,*}" ]; \
        then \
            echo "---------- Install sysvshm ----------" \
            && docker-php-ext-install -j$(nproc) sysvshm; \
        fi \
    && if [ -z "${EXTENSIONS##*,sysvmsg,*}" ]; \
        then \
            echo "---------- Install sysvmsg ----------" \
            && docker-php-ext-install -j$(nproc) sysvmsg; \
        fi \
    && if [ -z "${EXTENSIONS##*,tidy,*}" ]; \
        then \
            echo "---------- Install tidy ----------" \
            && apk add --no-cache tidyhtml-dev \
            && docker-php-ext-install -j$(nproc) tidy; \
        fi \
    && if [ -z "${EXTENSIONS##*,zip,*}" ]; \
        then \
            echo "---------- Install zip ----------" \
            && apk add --no-cache libzip-dev \
            && docker-php-ext-install -j$(nproc) zip; \
        fi \
    && if [ -z "${EXTENSIONS##*,xsl,*}" ]; \
        then \
            echo "---------- Install xsl ----------" \
            && apk add --no-cache libxml2-dev libxslt-dev \
            && docker-php-ext-install -j$(nproc) xsl; \
        fi \
    && if [ -z "${EXTENSIONS##*,apcu,*}" ]; \
        then \
            echo "---------- Install apcu ----------" \
            && printf "\n" | pecl install apcu \
            && docker-php-ext-enable apcu; \
        fi \
    && if [ -z "${EXTENSIONS##*,rdkafka,*}" ]; \
        then \
            echo "---------- Install rdkafka ----------" \
            && apk add --no-cache librdkafka-dev \
            && printf "\n" | pecl install rdkafka \
            && docker-php-ext-enable rdkafka; \
        fi \
    && if [ -z "${EXTENSIONS##*,redis,*}" ]; \
        then \
            echo "---------- Install redis ----------" \
            && printf "\n" | pecl install redis \
            && docker-php-ext-enable redis; \
        fi \
    && if [ -z "${EXTENSIONS##*,swoole,*}" ]; \
        then \
            echo "---------- Install swoole ----------" \
            && apk add --no-cache pkgconf brotli-dev \
            && printf "\n" | pecl install swoole \
            && docker-php-ext-enable swoole \
            && echo "[swoole]" >> /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini \
            && echo "swoole.enable_fiber_mock = On" >> /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini; \
        fi \
    && if [ -z "${EXTENSIONS##*,memcached,*}" ]; \
        then \
            echo "---------- Install memcached ----------" \
            && apk add --no-cache libmemcached-dev zlib-dev \
            && printf "\n" | pecl install memcached \
            && docker-php-ext-enable memcached; \
        fi \
    && if [ -z "${EXTENSIONS##*,xdebug,*}" ]; \
        then \
            echo "---------- Install xdebug ----------" \
            && printf "\n" | pecl install xdebug \
            && docker-php-ext-enable xdebug \
            && echo "[xdebug]" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.start_with_request = yes ; 请求开始时自动开启" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.start_upon_error = yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.discover_client_host = true" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.client_port = 9010" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.idekey = PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.client_host = host.docker.internal ;phpstorm 官方文档上面有写 https://www.jetbrains.com/help/phpstorm/configuring-xdebug.html#feac0d97" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        fi \
    && if [ -z "${EXTENSIONS##*,mongodb,*}" ]; \
        then \
            echo "---------- Install mongodb ----------" \
            && apk add --no-cache curl-dev openssl-dev \
            && printf "\n" | pecl install mongodb \
            && docker-php-ext-enable mongodb; \
        fi \
    && if [ -z "${EXTENSIONS##*,amqp,*}" ]; \
        then \
            echo "---------- Install amqp ----------" \
            && apk add --no-cache rabbitmq-c-dev \
            && printf "\n" | pecl install amqp \
            && docker-php-ext-enable amqp; \
        fi \
    && if [ -z "${EXTENSIONS##*,protobuf,*}" ]; \
        then \
            echo "---------- Install protobuf ----------" \
            && printf "\n" | pecl install protobuf \
            && docker-php-ext-enable protobuf; \
        fi \
    && if [ -z "${EXTENSIONS##*,psr,*}" ]; \
        then \
            echo "---------- Install psr ----------" \
            && printf "\n" | pecl install psr \
            && docker-php-ext-enable psr; \
        fi \
    && if [ -z "${EXTENSIONS##*,phalcon,*}" ]; \
        then \
            echo "---------- Install phalcon ----------" \
            # 对于 phalcon 4.x 需要完成诸如安装 psr 之类的附加步骤 可参考php7.3/Dockerfile \
            # 查看 pecl支持的版本 https://pecl.php.net/package/phalcon \
            # phalcon 安装失败问题 https://github.com/phalcon/cphalcon/issues/16775 \
            && export CFLAGS="-Wno-incompatible-pointer-types" \
            && printf "\n" | pecl install phalcon \
            && docker-php-ext-enable phalcon; \
        fi \
    && if [ -z "${EXTENSIONS##*,grpc,*}" ]; \
        then \
            echo "---------- Install grpc ----------" \
            && apk add --no-cache zlib-dev \
            && printf "\n" | pecl install grpc \
            && docker-php-ext-enable grpc \
            && echo "[grpc]" >> /usr/local/etc/php/conf.d/docker-php-ext-grpc.ini \
            && echo "grpc.enable_fork_support = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-grpc.ini; \
        fi \
    && if [ -z "${EXTENSIONS##*,igbinary,*}" ]; \
        then \
            echo "---------- Install igbinary ----------" \
            && printf "\n" | pecl install igbinary \
            && docker-php-ext-enable igbinary; \
        fi \
    && if [ -z "${EXTENSIONS##*,imagick,*}" ]; \
        then \
            echo "---------- Install imagick ----------" \
            && apk add --no-cache imagemagick-dev libgomp \
            && printf "\n" | pecl install imagick \
            && docker-php-ext-enable imagick; \
        fi \
    && if [ -z "${EXTENSIONS##*,xlswriter,*}" ]; \
        then \
            echo "---------- Install xlswriter ----------" \
            && apk add --no-cache zlib-dev \
            && printf "\n" | pecl install xlswriter \
            && docker-php-ext-enable xlswriter; \
        fi \
    && if [ -z "${EXTENSIONS##*,yaml,*}" ]; \
        then \
            echo "---------- Install yaml ----------" \
            && apk add --no-cache yaml-dev \
            && printf "\n" | pecl install yaml \
            && docker-php-ext-enable yaml; \
        fi \
    && docker-php-source delete \
    # 替换 composer 镜像 \
    && if [ ${COMPOSER_IMAGE_URL} ]; then composer config -g repo.packagist composer ${COMPOSER_IMAGE_URL}; fi \
    && echo "---------- Install supervisor ----------" \
    && apk add --no-cache supervisor \
    # 删除 pecl 下载的扩展包 \
    && rm -rf /tmp/pear \
    # 删除虚拟包 \
    && apk del .build-deps \
    # 删除 apk 下载的包 \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["docker-entrypoint"]
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
