# 指定基于 php:7.3-fpm-alpine 创建
FROM php:7.3-fpm-alpine

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories