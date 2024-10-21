#!/bin/sh
set -e

COMPOSER_MEMORY_LIMIT=-1 composer install --no-interaction --ansi

yarn install
npm rebuild node-sass
yarn encore dev
