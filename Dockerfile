FROM php:7-fpm-alpine

WORKDIR /app

RUN apk update \
    && apk add --no-cache git g++ make autoconf libpng libpng-dev freetype freetype-dev libjpeg-turbo libjpeg-turbo-dev \
    && docker-php-source extract \
    && docker-php-source delete \
    && docker-php-ext-configure gd \
            --with-freetype-dir=/usr/include/ \
            --with-jpeg-dir=/usr/include/ \
            --with-png-dir=/usr/include/ \
    && docker-php-ext-install pdo pdo_mysql gd \
    && pecl install apcu \
    && docker-php-ext-enable apcu
    && curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    && rm -rf /tmp/* \
    && composer --version
