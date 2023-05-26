# 指定基于 rabbitmq:3.11-alpine 创建
FROM rabbitmq:3.11-alpine

LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

ARG CONTAINER_PACKAGE_URL
ARG RABBITMQ_PLUGINS_3_11
ARG TZ

ENV PLUGINS=",${RABBITMQ_PLUGINS_3_11},"

# 资源替换 阿里云镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ]; \
    then \
      sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories; \
    fi

# 更新apk 修改时间
RUN apk update && apk upgrade \
    && if [ ${TZ} ]; \
        then \
            apk add --no-cache --virtual .build-deps tzdata \
            && cp -r "/usr/share/zoneinfo/${TZ}" /etc/localtime \
            && echo "${TZ}" > /etc/timezone; \
        fi

# 安装插件
RUN if [ -z "${PLUGINS##*,rabbitmq_management,*}" ]; \
    then \
        echo "---------- Install rabbitmq_management ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_management; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_amqp1_0,*}" ]; \
    then \
        echo "---------- Install rabbitmq_amqp1_0 ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_amqp1_0; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_auth_backend_ldap,*}" ]; \
    then \
        echo "---------- Install rabbitmq_auth_backend_ldap ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_auth_backend_ldap; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_auth_backend_http,*}" ]; \
    then \
        echo "---------- Install rabbitmq_auth_backend_http ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_auth_backend_http; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_auth_mechanism_ssl,*}" ]; \
    then \
        echo "---------- Install rabbitmq_auth_mechanism_ssl ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_auth_mechanism_ssl; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_consistent_hash_exchange,*}" ]; \
    then \
        echo "---------- Install rabbitmq_consistent_hash_exchange ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_consistent_hash_exchange; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_federation,*}" ]; \
    then \
        echo "---------- Install rabbitmq_federation ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_federation; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_federation_management,*}" ]; \
    then \
        echo "---------- Install rabbitmq_federation_management ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_federation_management; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_management_agent,*}" ]; \
    then \
        echo "---------- Install rabbitmq_management_agent ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_management_agent; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_mqtt,*}" ]; \
    then \
        echo "---------- Install rabbitmq_mqtt ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_mqtt; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_prometheus,*}" ]; \
    then \
        echo "---------- Install rabbitmq_prometheus ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_prometheus; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_shovel,*}" ]; \
    then \
        echo "---------- Install rabbitmq_shovel ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_shovel; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_shovel_management,*}" ]; \
    then \
        echo "---------- Install rabbitmq_shovel_management ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_shovel_management; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_stomp,*}" ]; \
    then \
        echo "---------- Install rabbitmq_stomp ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_stomp; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_trust_store,*}" ]; \
    then \
        echo "---------- Install rabbitmq_trust_store ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_trust_store; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_web_stomp,*}" ]; \
    then \
        echo "---------- Install rabbitmq_web_stomp ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_web_stomp; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_web_mqtt,*}" ]; \
    then \
        echo "---------- Install rabbitmq_web_mqtt ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_web_mqtt; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_web_stomp_examples,*}" ]; \
    then \
        echo "---------- Install rabbitmq_web_stomp_examples ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_web_stomp_examples; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_web_mqtt_examples,*}" ]; \
    then \
        echo "---------- Install rabbitmq_web_mqtt_examples ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_web_mqtt_examples; \
    fi \
    && if [ -z "${PLUGINS##*,rabbitmq_delayed_message_exchange,*}" ]; \
    then \
        echo "---------- Install rabbitmq_delayed_message_exchange ----------" \
        && printf "y\n" | rabbitmq-plugins enable rabbitmq_delayed_message_exchange; \
    fi 
