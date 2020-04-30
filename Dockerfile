FROM php:7.4.4-fpm-alpine
LABEL maintainer "creamNote"

ENV TZ Asia/Tokyo
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer

RUN set -eux && \
    apk add --update-cache --no-cache --virtual=.build-dependencies tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    apk del .build-dependencies && \
    docker-php-ext-install bcmath pdo_mysql && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    composer config -g repos.packagist composer https://packagist.jp && \
    composer global require hirak/prestissimo