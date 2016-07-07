FROM php:7.0-apache

ENV DOCKERIZE_VERSION 0.2.0
ENV DOCKERIZE_SHA1 29be833b6e27009216da54114c4b47ee2534db8c

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    DEFAULT_TIMEZONE=Australia/Melbourne

RUN set -xe && \
    apt-get -qq update && \
    apt-get -qq install \
        git \
        zlib1g-dev \
        libpng12-dev \
        libjpeg-dev \
        rsync \
        mysql-client \
        --no-install-recommends \
        && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-install gd mbstring pdo pdo_mysql zip && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    curl -L -o /tmp/dockerize.tar.gz \
        https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v0.2.0.tar.gz && \
    echo "$DOCKERIZE_SHA1 */tmp/dockerize.tar.gz" | sha1sum -c - && \
    tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz && \
    rm /tmp/dockerize.tar.gz && \
    { \
        echo 'date.timezone = ${DEFAULT_TIMEZONE}'; \
    } > /usr/local/etc/php/conf.d/date-timezone.ini && \
    true

WORKDIR /app

COPY app /app

RUN set -xe && \
    composer install --no-dev && \
    composer clear-cache && \
    ./set-permissions.sh && \
    true

ENV PATH=$PATH:/app/vendor/bin

RUN set -xe && \
    sed -i 's#DocumentRoot.*#DocumentRoot /app/web#' /etc/apache2/apache2.conf && \
    sed -i 's#<Directory /var/www/>.*#<Directory /app/web/>#' /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    true