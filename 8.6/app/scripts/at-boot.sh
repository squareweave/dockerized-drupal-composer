#!/bin/bash -e

if [ -n $MEMORY_LIMIT ]
then
    echo "Setting PHP memory limit to ${MEMORY_LIMIT}"
    echo "memory_limit = ${MEMORY_LIMIT}" > /usr/local/etc/php/conf.d/resources.ini
fi

: ${DEVELOPMENT_MODE:-false}

if [ "$DEVELOPMENT_MODE" == "true" ]
then
    echo "!!! RUNNING IN DEVELOPMENT MODE -- PERMISSIONS WILL NOT BE HARDENED !!!"
    chown -R www-data:www-data /app/web/sites/default/files /app/config/sync
    chmod -R =rw,+X /app/web/sites/default/files /app/config/sync

    /app/scripts/at-deploy.sh
    /app/scripts/after-deploy.sh
else
    chown -R www-data:www-data /app/web
    chmod -R =r,+X /app/web
    chmod -R =rw,+X /app/web/sites/default/files
fi

if [ -n $NR_INSTALL_KEY ]
then
    /usr/bin/newrelic-install install
    sed -i "s/newrelic.appname = \"PHP Application\"/newrelic.appname = \"${NR_APP_NAME}\"/" \
        /usr/local/etc/php/conf.d/newrelic.ini
fi

# Wait for the DB to settle
dockerize -wait tcp://${DB_HOST:-db}:${DB_PORT:-3306} -timeout 60s -template /etc/ssmtp/ssmtp.conf.tmpl:/etc/ssmtp/ssmtp.conf

# Stop. Apache time.
exec "apache2-foreground"