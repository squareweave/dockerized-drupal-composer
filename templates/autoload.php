<?php

/**
 * @file
 * Includes the autoloader created by Composer.
 *
 * @see composer.json
 * @see index.php
 * @see core/install.php
 * @see core/rebuild.php
 * @see core/modules/statistics/statistics.php
 */

$autoloader = require __DIR__ . '/vendor/autoload.php';
require '/app/vendor/autoload.php';

return $autoloader;