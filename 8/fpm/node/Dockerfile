FROM php:7.0-fpm

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
        rsync \
        patch \
        mysql-client \
        ssmtp \
        newrelic-php5 \
        --no-install-recommends \
        && \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr && \
    docker-php-ext-install opcache gd mbstring pdo pdo_mysql zip && \
    apt-get clean && \
    rm /etc/apt/sources.list.d/newrelic.list && \
    apt-key del 548C16BF && \
    rm -r /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    curl -L -o /tmp/dockerize.tar.gz \
        https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v0.2.0.tar.gz && \
    echo "$DOCKERIZE_SHA1 */tmp/dockerize.tar.gz" | sha1sum -c - && \
    tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz && \
    { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini && \
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

RUN set -xe && \
    apt-get -qq update && \
    apt-get -qq install \
        apt-transport-https \
        --no-install-recommends && \
    curl -sL 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key' | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node_5.x jessie main' > /etc/apt/sources.list.d/nodesource.list && \
    apt-get -qq update && \
    apt-get -qq install \
        nodejs \
        --no-install-recommends \
        && \
    rm /etc/apt/sources.list.d/nodesource.list && \
    apt-key del 68576280 && \
    apt-get purge -qq --auto-remove \
        -o APT::AutoRemove::RecommendsImportant=false \
        -o APT::AutoRemove::SuggestsImportant=false \
        apt-transport-https \
        && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    true