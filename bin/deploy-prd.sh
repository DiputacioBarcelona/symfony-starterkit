#!/bin/bash

echo "===== Iniciant deploy PRD ====="
echo "===== Connectant al repositori de codi ====="
git checkout master
echo "===== Guardant els canvis locals al stash ====="
echo "===== Es pot revertir i recuperar els canvis locals executant: git stash pop"
git stash clear
git stash
echo "===== Baixant la darrera versió del codi ====="
git fetch origin
git reset --hard origin/master
echo "===== Actualitzant dependències ====="
export COMPOSER_ALLOW_SUPERUSER=1; php74 -d memory_limit=-1 /usr/bin/composer install --prefer-dist --no-interaction --ansi
echo "===== Actualitzant el timestamp del build desplegat ====="
sudo touch .env
echo "===== Netejant cache ====="
php74 -f bin/console cache:clear --no-warmup -e prod
echo "===== Corregeix usuari/grup dels fitxers, aquest pas és lent i pot trigar varis minuts ====="
chown -R apache:apache ./
