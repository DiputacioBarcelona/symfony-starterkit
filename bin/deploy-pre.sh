#!/bin/bash

echo "===== Iniciant deploy PRE ====="
echo "===== Connectant al repositori de codi ====="
sudo git checkout pre
echo "===== Guardant els canvis locals al stash ====="
echo "===== Es pot revertir i recuperar els canvis locals executant: git stash pop"
sudo git stash clear
sudo git stash
echo "===== Baixant la darrera versió del codi ====="
sudo git fetch origin
sudo git reset --hard origin/pre
echo "===== Actualitzant dependències ====="
export COMPOSER_ALLOW_SUPERUSER=1; sudo php74 -d memory_limit=-1 /usr/bin/composer install --prefer-dist --no-interaction --ansi
echo "===== Actualitzant el timestamp del build desplegat ====="
sudo touch .env
echo "===== Netejant cache ====="
sudo php74 -f bin/console cache:clear --no-warmup -e prod
echo "===== Corregeix usuari/grup dels fitxers, aquest pas és lent i pot trigar varis minuts ====="
sudo chown -R apache:apache ./
