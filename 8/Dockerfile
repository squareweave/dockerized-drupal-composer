FROM php:7.0-apache

ENV DOCKERIZE_VERSION 0.2.0
ENV DOCKERIZE_SHA1 29be833b6e27009216da54114c4b47ee2534db8c

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    DEFAULT_TIMEZONE="Australia/Melbourne" \
    NR_INSTALL_SILENT=1 \
    NR_APP_NAME="Drupal Application" \
    NR_INSTALL_KEY="" \
    PATH=$PATH:/app/vendor/bin \
    COMPOSER_ALLOW_SUPERUSER=1

RUN set -xe && \
    curl -sL 'https://download.newrelic.com/548C16BF.gpg' | apt-key add - && \
    echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' > /etc/apt/sources.list.d/newrelic.list && \
    apt-get -qq update && \
    apt-get -qq install \
        git \
        zlib1g-dev \
        libpng12-dev \
        libjpeg-dev \
        libmemcached-dev \
        rsync \
        patch \
        mysql-client \
        ssmtp \
        newrelic-php5 \
        --no-install-recommends \
        && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    git clone --branch php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached && \
    echo "memcached" >> /usr/src/php-available-exts && \
    docker-php-ext-configure memcached && \
    docker-php-ext-install opcache gd mbstring pdo pdo_mysql zip memcached && \
    apt-get clean && \
    rm /etc/apt/sources.list.d/newrelic.list && \
    apt-key del 548C16BF && \
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

COPY php-config/ /usr/local/etc/php/conf.d/

WORKDIR /app

COPY app /app

RUN set -xe && \
    composer install --no-dev && \
    composer clear-cache && \
    ./scripts/set-permissions.sh && \
    true

COPY apache2-drupal.conf /etc/apache2/sites-available/drupal.conf

RUN set -xe && \
    a2ensite drupal && \
    a2dissite 000-default && \
    a2enmod rewrite && \
    true