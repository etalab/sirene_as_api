# SIRENE_as_api

Dans le cadre du SPD, (Service Public de la Donnée), certains jeux de données
dont le fichier SIRENE sont devenus publics.

Le projet SIRENE_as_api a pour vocation de mettre en valeur la donnée brute en
la servant sous forme d'API.

## Qualification des fichiers mis à disposition par l'INSEE

L'ensemble des fichiers mis à disposition pour le SIRENE se trouvent sur
[data.gouv.fr](http://files.data.gouv.fr/sirene). On y trouve chaque début de
mois un fichier dit stock qui reflète tous les établissements dont la diffusion commerciale
est autorisée. Ces fichiers stocks sont accompagnés de fichiers stocks mensuels,
ainsi que de fichiers de mise à jour fréquentes.

### Fichiers stocks mensuels

Règle de nommage : sirene_YYYYMM_L_M.zip, YYYY => 2017, MM => 01 pour janvier

Pour récupérer le dernier stock et l'insérer en base, veuillez utiliser

    rake sirene_as_api:import_last_monthly_stock

Notez que ceci ne fait qu'insérer des rows et ne doit pas être lancé sur une
base non vide

### Fichiers de mise à jour fréquents

Règle de nommage : sirene_YYYYddd, YYY => 2017, 032 pour le 1er février car 32e
jour de l'année

Ces fichiers paraissent le lendemain des 5 jours ouvrés classiques de semaine.
Pour en savoir plus, rendez vous sur la [faq de l'insee](https://www.sirene.fr/sirene/public/faq?sirene_locale=fr)


## Démonstration de ce projet

Il existe un serveur de démonstration de SIRENE_as_api, sur lequel vous pouvez
faire des essais.

    curl 'http://entreprises.beta.gouv.fr/full_text/VOTRE_RECHERCHE'
    curl 'http://entreprises.beta.gouv.fr/siret/VOTRE_SIRET'

Le fair use est de 1000 requêtes par heure. Au dela vous risquez un bannissement
de votre IP.

### Mises à jour

TODO

# Installation par soi même et setup

Vous aurez besoin de :
* postgresql en version supérieure a 9.5, la dernière version stable de
  préférence
* ruby en version 2.3.1 (un bump vers 2.4.x est prévu)
* git installé
* bundler d'installé
* un runtime java pour solr

Une fois cloné ce répertoire à l'aide de

    git clone git@github.com:sgmap/sirene_as_api.git && cd sirene_as_api

Lancez bundle install pour récupérer les gems nécessaires, ceci peut prendre un
peu de temps en fonction de votre installation. Vous pouvez omettre l'installation de
bundler s'il est déjà présent sur la machine

    gem install bundler && bundle install

Il faut maintenant préparer la base de données postgres

    psql -f postgresql_setup.txt

Assurez vous que tout s'est bien passé

    bundle exec rake db:create

Puis runnez les migrations

    bundle exec rake db:migrate

Si vous souhaitez utiliser les tests

    RAILS_ENV=test bundle exec rake db:migrate

Puis lancez l'import du dernier dump

    bundle exec rake sirene_as_api:import_last_monthly_stock

Une fois réalisé, lancez Solr, des fichiers de config seront copiés

    bundle exec rake sunspot:solr:start

Lancez l'indexation (sur une base remplie, comptez ~ 1-2 heures)

    bundle exec rake sunspot:reindex

C'est prêt vous pouvez lancer le serveur

    bundle exec rails server

Et y faire des requêtes

    curl 'localhost:3000/full_text/MA_RECHERCHE'
    curl 'localhost:3000/siret/MON_SIRET'

## Mises à jour / Administration

Tâches disponibles
    rake -T

Tâches spécifiques sirene_as_api
    bundle exec rake -T sirene_as_api

Remplissage base (dernier stock + mises a jour) : ~ 4 heures, patching variable
    bundle exec rake sirene_as_api:populate_database

Remplissage base dernier stock seulement : ~ 4 heures
    bundle exec rake sirene_as_api:import_last_monthly_stock

Mise a jour et applications des patches idoines : ~ 2 minutes par patch
    bundle exec rake sirene_as_api:select_and_apply_patches

ACHTUNG *Il faut réindexer après chacune de ces opérations*. La réindexation
automatique viendra plus tard

## Sunspot / SOlr

### Start the server
    bundle exec rake sunspot:solr:start

### Stop the server
    bundle exec rake sunspot:solr:stop

### Reindex model
    bundle exec rake sunspot:reindex

# License

[MIT](https://fr.wikipedia.org/wiki/Licence_MIT)
