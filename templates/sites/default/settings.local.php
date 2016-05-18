<?php

$settings['install_profile'] = 'standard';
$config_directories['sync'] = 'sites/default/files/config/sync';

$databases['default']['default'] = array(
    'driver' => 'mysql',
    'database' => getenv('DB_NAME'),
    'username' => getenv('DB_USER'),
    'password' => getenv('DB_PASSWORD'),
    'host' => getenv('DB_HOST'),
    'port' => getenv('DB_PORT') ?: 3306,
    'prefix' => getenv('DB_PREFIX') ?: 'drupal_',
    'collation' => getenv('DB_COLLATE') ?: 'utf8mb4_general_ci',
);