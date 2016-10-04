#!/bin/bash -e

dockerize -wait tcp://${DB_HOST:-db}:${DB_PORT:-3306} -timeout 60s

echo "Entering maintenance mode..."
/usr/local/bin/drupal --root=/app/web  site:maintenance on --quiet
echo "Done."

make --directory=/app config-import

# Applies pending drupal DB changes
make --directory=/app database-update
