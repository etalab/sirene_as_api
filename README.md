# SIRENE_as_api

Dans le cadre du SPD, (Service Public de la Donnée), certains jeux de données
dont le fichier SIRENE sont devenus publics.

Le projet SIRENE_as_api a pour vocation de mettre en valeur la donnée brute en
la servant sous forme d'API.

Le projet se découpe en trois sous-projets :

  - Une API Ruby on Rails qui importe les fichiers de données
    mis à disposition par l'INSEE : [sirene_as_api](https://github.com/sgmap/sirene_as_api)
  - Un script capable de déployer l'API automatiquement : [sirene_as_api_ansible](https://github.com/sgmap/sirene_as_api_ansible)
  - Une interface web de recherche exploitant l'API en Vue.js : [sirene_as_api_front](https://github.com/sgmap/sirene_as_api_front)

## Qualification des fichiers mis à disposition par l'INSEE

L'ensemble des fichiers mis à disposition pour le SIRENE se trouvent sur
[data.gouv.fr](http://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/).
On y trouve chaque début de mois un fichier dit stock qui recense toutes
les entreprises et leurs établissements.
Ces fichiers stocks mensuels sont accompagnés de fichiers de mises à jour
quotidiennes (tous les jours ouvrés), ainsi que de fichiers de mises à jour
mensuelles dites "de recalage".

### Fichiers stocks mensuels

Il s'agit de fichiers mensuels contenant toute la base de donnée.
Règle de nommage : sirene_YYYYMM_L_M.zip, YYYY => 2017, MM => 01 pour janvier

### Fichiers de mises à jour quotidiennes

Il s'agit de fichiers quotidiens mettant à jour la base de donnée.
Règle de nommage : sirene_YYYYddd, YYY => 2017, ddd => 032 pour le 1er février car 32e
jour de l'année

Ces fichiers paraissent dans la nuit suivant chaque jour ouvré.
Pour en savoir plus, rendez vous sur la [faq de l'insee](https://www.sirene.fr/sirene/public/faq?sirene_locale=fr)

Une commande Rake est disponible pour mettre à jour la base de données
(Cf. liste des tâches plus bas). Toute mise à jour est suivie par une
réindexation automatique.

## Requêtes API

    curl 'http://localhost:3000/full_text/VOTRE_RECHERCHE'
    curl 'http://localhost:3000/siret/VOTRE_SIRET'

### Spécifications pour la recherche par nom d'entreprise

L'API retourne 10 résultats par page, au format JSON, avec le nombre total de
résultats et le nombre total de pages. La page par défaut est la première,
pour obtenir d'autres pages on peut passer le numéro en paramètre :

    curl 'http://localhost:3000/full_text/VOTRE_RECHERCHE?page=2'

La recherche par facette est implémentée avec les paramètres code_postal et activite_principale :

    curl 'http://localhost:3000/full_text/VOTRE_RECHERCHE?code_postal=CODE_POSTAL&activite_principale=ACTIVITE_PRINCIPALE'

D'autres facettes pourront être implémentées en fonction des retours utilisateurs.

# Installation et configuration

Vous aurez besoin de :
* postgresql en version supérieure a 9.5, la dernière version stable de
  préférence
* ruby en version 2.4.1
* git installé
* bundler installé
* un runtime java pour solr

Une fois cloné ce répertoire à l'aide de

    git clone git@github.com:sgmap/sirene_as_api.git && cd sirene_as_api

Lancez bundle install pour récupérer les gems nécessaires, ceci peut prendre un
peu de temps en fonction de votre installation. Vous pouvez omettre l'installation de
bundler s'il est déjà présent sur la machine

    gem install bundler && bundle install

Il faut maintenant préparer la base de données postgres :

    sudo -u postgres -i
    psql -f postgresql_setup.txt

Assurez vous que tout s'est bien passé :

    bundle exec rake db:create

Puis éxécutez les migrations :

    bundle exec rake db:migrate

Si vous souhaitez utiliser les tests :

    RAILS_ENV=test bundle exec rake db:migrate

Peuplez la base de données : Cette commande importe le dernier fichier stock mensuel
ainsi que les mises à jour quotidiennes.

    bundle exec rake sirene_as_api:populate_database

Une fois réalisé, lancez Solr, des fichiers de configuration seront copiés :

    bundle exec rake sunspot:solr:start

Lancez l'indexation (sur une base remplie, comptez au moins une heure)

    bundle exec rake sunspot:reindex

C'est prêt ! vous pouvez lancer le serveur :

    bundle exec rails server

Et y faire des requêtes :

    curl 'localhost:3000/full_text/MA_RECHERCHE'
    curl 'localhost:3000/siret/MON_SIRET'

## Mises à jour / Administration

Tâches disponibles : `rake -T`, ou spécifiques sirene_as_api : `bundle exec rake -T sirene_as_api`

Remplissage base (dernier stock + mises a jour) : ~ 3 heures, patching variable
(Attention : Cette commande est à lancer sur base vide)

    bundle exec rake sirene_as_api:populate_database

Remplissage base dernier stock seulement : ~ 3 heures
(Attention : Cette commande est à lancer sur base vide)

    bundle exec rake sirene_as_api:import_last_monthly_stock

Mise a jour et applications des patches idoines : ~ 2 minutes par patch

    bundle exec rake sirene_as_api:update_database

Suppression database, en cas de problèmes :

    bundle exec rake sirene_as_api:delete_database

Il est conseillé de rajouter RAILS_ENV=production en environnement de production.

### Mises à jour automatiques

La commande `bundle exec rake sirene_as_api:update_database` peut être lancée
a chaque nouveau fichier.
Pour automatiser le processus, il suffit de lancer :

    whenever --update-crontab

La gem [whenever](https://github.com/javan/whenever) s'occupe de mettre à jour
vos tâches cron. Par défaut la mise à jour se fait à 4h30 du matin.

## Sunspot / Solr

  Le serveur Solr doit être actif pour toute requête ou changement sur la
  base de donnée.
  Il est nécessaire de précéder ces commandes de `RAILS_ENV=MonEnvironnement`.
  Attention, avoir plus d'un seul serveur Solr actif peut être source de
  problèmes, il est par exemple conseillé de désactiver le serveur `test`
  si vous souhaiter effectuer des opérations en `development`.

### Demarrer le serveur
    bundle exec rake sunspot:solr:start

### Arreter le serveur
    bundle exec rake sunspot:solr:stop

### Réindexation

La réindexation est automatique après un changement appliqué à la base de
donnée, mais il est également possible de réindexer manuellement :

    bundle exec rake sunspot:reindex

# License

Ce projet est sous [license MIT](https://fr.wikipedia.org/wiki/Licence_MIT)
