#!/bin/bash

echo "===== Iniciant deploy DEV ====="
echo "===== Connectant al repositori de codi ====="
sudo git checkout develop
echo "===== Guardant els canvis locals al stash ====="
echo "===== Es pot revertir i recuperar els canvis locals executant: git stash pop"
sudo git stash clear
sudo git stash
echo "===== Baixant la darrera versió del codi ====="
sudo git fetch origin
sudo git reset --hard origin/develop
echo "===== Actualitzant dependències ====="
export COMPOSER_ALLOW_SUPERUSER=1; sudo php -d memory_limit=-1 /usr/bin/composer update --prefer-dist --no-interaction --ansi
echo "===== Actualitzant el timestamp del build desplegat ====="
sudo touch .env
echo "===== Netejant cache ====="
sudo php -f bin/console cache:clear --no-warmup -e dev
echo "===== Corregeix usuari/grup dels fitxers, aquest pas és lent i pot trigar varis minuts ====="
sudo chown -R apache:apache ./
