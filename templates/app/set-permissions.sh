#!/bin/bash

set -xe

chown -R www-data:www-data /app/web

chmod -R =r,+X /app/web

chmod -R =rw,+X /app/web/sites/default/files
