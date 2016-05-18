#!/bin/bash

set -xe

chown -R www-data:www-data /var/www/html

chmod -R =r,+X /var/www/html

chmod -R =rw,+X /var/www/html/sites/default/files
