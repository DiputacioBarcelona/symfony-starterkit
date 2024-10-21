# Manual tècnic

Llista de scripts bàsics per instal·lar els paquets, executar l'aplicació en local i fer el manteniment de les
dependències.

Per executar-ho cal tenir:

* nodejs: https://nodejs.org
* yarn: npm install --global yarn
* PHP >= 8.2.19
* composer: https://getcomposer.org/

## Instal·lació

Cal executar-ho quan despleguem en un nou entorn o canviem les versions. Aquest script instal·larà el npm si no existeix
i els paquets del yarn i el composer en les versions definides.

> sh bin/build.sh

Si ja tens npm i yarn instal·lats i funcionant pots llençar directament l'script de manteniment.

## Manteniment

Cal executar-ho quan volem actualitzar un entorn que ja està funcionant. Aquest script actualitzarà els paquets del yarn
i el composer, actualitzarà les traduccions i generarà els fitxers públics JS i CSS necessaris a partir dels assets.
El script de desenvolupament generarà un JS/CSS agregat sense comprimir i el de Producció afegirà compressió, versionat
i hash d'integritat. Cal vigilar en fer el build correcte a cada entorn.

Entorn de desenvolupament:

> sh bin/update.sh -env dev

Entorn de Producció:

> sh bin/update.sh -env prod

## Execució en local

Pots executar en local l'aplicació pots fer servir Symfony CLI.

https://symfony.com/download

> symfony server:start

I visitar la url: http://127.0.0.1:8000/

## Base de dades

Si la teva aplicació utilitza base de dades, afegeix els paquets de l'ORM i configura la connexió:

> composer require doctrine/doctrine-bundle doctrine/doctrine-migrations-bundle

## Tests ##

Pots executar els tests amb la comanda:

> php bin/phpunit

A la carpeta "tests" hi ha un exemple de test d'aplicació, test d'integració i test unitari.

## Anàlisis del codi ##

Hi ha un script que analitza el codi a través del SonarQube corporatiu. Per llençar-lo cal instal·lar el client
SonarScanner: https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/ i executar l'anàlisi des del root del
projecte:

> __PATH_TO_SONAR__/sonar-scanner.bat 
> -D"sonar.host.url=__HOST__" 
> -D"sonar.projectKey=__PROJECT_KEY__" 
> -D"sonar.login=__SONAR_TOKEN__" 
> -D"sonar.exclusions=node_modules/**,var/**,vendor/**,public/**"

## Web ##

La web de l'entorn de desenvolupament sortirà amb un requadre en vermell, l'entorn d'integració o test sortirà en groc i
l'entorn de producció sortirà sense cap requadre. El color el controla el valor de la variable APP_ENV.

Recordeu que els valors de les variables no sensibles han d'anar en els fitxers .env .env.dev .env.prod .env.test i
aquests s'han de sincronitzar amb el repositori de codi, però les dades sensibles com l'usuari/contrasenya de la base de 
dades han d'anar a les variables .env.local .env.dev.local .env.prod.local .env.test.local i **MAI** s'han de
sincronitzar amb el repositori de codi.

## Autenticació VUS ##

Podeu afegir l'autenticador del VUS com a firewall al: security.yaml, ja sigui per poder fer login dins de l'aplicació o
per permetre el single-sign-on des de l'accés restringit corportiu:

    firewalls:
        in_app:
            context: 'back'
            pattern: ^/login/in-app
            lazy: true
            provider: users_in_app
            custom_authenticators:
                - App\Security\WebserviceVus\VusAuthenticator
            form_login:
                login_path: login.in_app
                check_path: login.in_app
                enable_csrf: true
            logout:
                path: app_logout
                target: login
        in_diba:
            context: 'back'
            pattern: ^/login/in-diba
            lazy: true
            provider: users_in_app
            custom_authenticators:
                - App\Security\WebserviceVus\VusSingleSignOnAuthenticator
            logout:
                path: app_logout
                target: login

I caldrà afegir els següents paràmetres i variables d'entorn al: services.yaml

    parameters:
        vus:
            ws_url: '%env(VUS_WS_URL)%'
            ws_user: '%env(VUS_WS_USER)%'
            ws_pass: '%env(VUS_WS_PASS)%'
            ws_app: '%env(VUS_WS_APPLICATION)%'

A més del corresponent controlador per fer el login:

    /**
     * @Route("/login/in-app", name="login.in_app", methods={"GET", "POST"})
     */
    public function loginInApp(Security $security, AuthenticationUtils $authenticationUtils): Response
    {
        return $this->render('pages/login_in_app.html.twig', [
            'last_username' => $authenticationUtils->getLastUsername(),
            'error'         => $authenticationUtils->getLastAuthenticationError(),
        ]);
    }
