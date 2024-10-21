php bin/console cache:clear --no-warmup -e test
yarn encore dev
XDEBUG_MODE=coverage php bin/phpunit --coverage-clover /c/workspace/diba/starterkit/coverage.xml
/c/workspace/libs/sonar-scanner/bin/sonar-scanner.bat -D"sonar.host.url=http://su0244.corpo.ad.diba.es:9000/" -D"sonar.projectKey=starterkit" -D"sonar.login=017a72882cbf0c19c949115bfd6e67b4f5ca1f3d" -D"sonar.exclusions=public/**,config/**,webpack.config.js"