#!/bin/bash -e

dockerize -wait tcp://${DB_HOST:-db}:${DB_PORT:-3306} -timeout 60s

echo "Exiting maintenance mode..."
/usr/local/bin/drupal --root=/app/web site:maintenance off --quiet
echo "Done."
