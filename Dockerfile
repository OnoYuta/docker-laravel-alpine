FROM php:7.4.4-fpm-alpine
LABEL maintainer "creamNote"

ENV TZ Asia/Tokyo
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer

# https://laravel.com/docs/6.x#server-requirements
RUN apk update && \
    apk --no-cache add \
    curl \
    npm \
    yarn \
    make \
    git \
    bash \
    icu-dev \
    oniguruma-dev \
    libzip-dev \
    libpng-dev && \
    git clone https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis && \
    # Set time zone
    apk --no-cache add --virtual=.build-dependencies tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    apk del .build-dependencies && \
    # Install php extensions
    docker-php-ext-install \
    bcmath \
    pdo_mysql \
    redis \
    opcache \
    intl \
    zip \
    gd && \
    # Install composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    composer config -g repos.packagist composer https://packagist.jp && \
    composer global require hirak/prestissimo