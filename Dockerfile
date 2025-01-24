FROM php:8.4-fpm-alpine

RUN apk update && apk upgrade

# OS toolchain
RUN apk add bash curl sudo

# PHP extensions
RUN apk add libzip-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

# PHP extensions: Database
#RUN docker-php-ext-install pdo pdo_sqlite
#RUN docker-php-ext-install pdo pdo_pgsql
RUN docker-php-ext-install pdo pdo_mysql

# Install composer, dependency manager for php (@see https://getcomposer.org)
#RUN apk add composer

# Configurations for applications inside container
#COPY ./docker/nginx/default.conf /etc/nginx/http.d/default.conf
#COPY ./docker/php/www.conf /etc/php8/php-fpm.d/www.conf
#COPY ./docker/cron/crontab /etc/crontabs/nginx
#RUN echo 'memory_limit = 1024M' >> /etc/php81/conf.d/docker-php-memlimit.ini

# Prepare working directory
#RUN mkdir -p /var/www/latest
#WORKDIR /var/www/latest
#COPY ./src .
#COPY . .
#RUN chown -R nginx:nginx /var/www/latest

# Install application (since the mounted volume overwrites the content in workdir this is done in docker-compose.yml again)
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
#RUN sudo su - nginx -s /bin/bash -c "cd /var/www/latest && composer install"

# Node
RUN apk add npm

WORKDIR /var/www

STOPSIGNAL SIGTERM