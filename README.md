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

# Requêtes

Trois endpoints sont disponibles sur l'API :

## Recherche FullText

Il s'agit de l'endpoint principal. Vous pouvez faire des requêtes avec Curl :

    curl 'localhost:3000/full_text/MA_RECHERCHE'

ou simplement en copiant l'adresse ´localhost:3000/full_text/MA_RECHERCHE´
dans votre navigateur favori.

### Format de réponse

L'API renvoie les réponses au format JSON avec les attributs suivant :

| Attribut      | Valeur                       |
|---------------|------------------------------|
| total_results | Total résultats              |
| total_pages   | Total de pages               |
| per_page      | Nombre de résultats par page |
| page          | Page actuelle                |
| etablissement | Résultats                    |
| spellcheck    | Correction orthographique suggérée |
| suggestions   | Suggestions de recherche |

### Suggestions de recherche

Les suggestions de recherche sont utiles pour obtenir une complétion sur une requête utilisateur incomplète.
Vous pouvez n'obtenir que les suggestions par la commande suivante :

    curl 'localhost:3000/suggest/MA_RECHERCHE'

**Attention : La construction du dictionnaire de suggestions est une tache lourde.**  
Une allocation de memoire vive de minimum 4G est actuellement conseillée. L'opération prend environ 30 minutes.  
Une fois le dictionnaire construit, une allocation de 2G est suffisante pour utiliser les suggestions. En dessous, les suggestions seront desactivées, mais vous pourrez toujours utiliser toutes les autres fonctionnalités de l'API.

L'allocation de mémoire de la Machine Virtuelle Java peut être modifié dans le fichier config/sunspot.yml.  

### Pagination

La page par défaut est la première. L'API renvoie par défaut 10 résultats par page.
Ces attributs peuvents être modifiés en passant en paramètres `page` et `per_page`.

### Filtrage par faceting

Les options suivantes de filtrage sont disponibles :

| Filtrage désiré                                           | Requête GET               | Valeur                                              |
|-----------------------------------------------------------|---------------------------|-----------------------------------------------------|
| Activité principale de l'entreprise                       | activite_principale       | Le code `activité principale` désiré                |
| Code postal                                               | code_postal               | Le code postal désiré                               |
| Appartenance au champs de l'économie sociale et solidaire | is_ess                    | `O` pour Oui, `N` pour Non, `I` pour Invalide       |
| Entreprises individuelles                                 | is_entrepreneur_individuel| `yes` pour Oui, `no` pour Non                       |

D'autres facettes pourront être implémentées en fonction des retours utilisateurs.

### Exemple

Je souhaite les entreprises individuelles avec "foobar" dans le nom, je désire 15
résultats par page et afficher la deuxième page (soit les résultats 15 à 30) :

    curl 'localhost:3000/full_text/foobar?page=2&per_page=15&is_entrepreneur_individuel=yes'

## Recherche par Numéro SIRET

La requête se fait par :

    curl 'localhost:3000/siret/MON_SIRET'

L'API renvoie un JSON de l'établissement correspondant.

## Recherche par Numéro SIREN (établissements enfants)

La requête se fait par :

    curl 'localhost:3000/siren/MON_SIREN'

l'API renvoie :
  - Le nombre total de sirets existants à partir de ce siren.
  - Les données de l'établissement siège correspondant à ce siren.
  - La liste des sirets enfants (sirets correspondants à ce siren & qui ne sont pas le siège de l'établissement)
  - Le numéro de TVA intracommunautaire.

# Installation et configuration

Pour installer rapidement & efficacement l'API en environnement de production,
vous pouvez vous referer a la documentation sur [sirene_as_api_ansible](https://github.com/sgmap/sirene_as_api_ansible)
et utiliser les scripts de déploiement automatiques.

## Installation manuelle en environnement dev

Pour une installation manuelle, vous aurez besoin de :
* postgresql en version supérieure a 9.5, la dernière version stable de
  préférence
* ruby en version 2.4.2
* git installé
* bundler installé
* un runtime java pour solr

 Pour vous simplifier la tâche, nous vous conseillons d'utiliser le script Ansible mis a disposition pour déployer votre
 architecture. Une tâche [Mina](https://github.com/mina-deploy/mina) est également disponible (fichier config/deploy.rb).

Une fois cloné ce répertoire à l'aide de

    git clone git@github.com:sgmap/sirene_as_api.git && cd sirene_as_api

Lancez bundle install pour récupérer les gems nécessaires, ceci peut prendre un
peu de temps en fonction de votre installation. Vous pouvez omettre l'installation de
bundler s'il est déjà présent sur la machine

    gem install bundler && bundle install

## Preparation de la base de donnée

Il faut maintenant préparer la base de données postgres :

    sudo -u postgres -i
    cd /path/vers/dossier/sirene_as_api
    psql -f postgresql_setup.txt

Assurez vous que tout s'est bien passé :

    bundle exec rails db:create

Puis éxécutez les migrations :

    bundle exec rails db:migrate

Si vous souhaitez utiliser les tests :

    RAILS_ENV=test bundle exec rails db:migrate

Vous pouvez maintenant lancer Solr :

    RAILS_ENV=production bundle exec rake sunspot:solr:start

Peuplez la base de données : Cette commande importe le dernier fichier stock mensuel
ainsi que les mises à jour quotidiennes. Attention, cette commande s'éxécute sur
une base vide.

    bundle exec rake sirene_as_api:populate_database

Si la commande précédente échoue en cours de route ou si la base n'est pas vide,
éxecutez plutôt :

    bundle exec rake sirene_as_api:update_database

C'est prêt ! vous pouvez lancer le serveur :

    bundle exec rails server

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

Attention ! En début de mois / à chaque nouveau fichier stock, la base de donnée est supprimée puis ré-importée
entièrement. L'opération prend ~ 3 heures. Cette commande vous demandera confirmation.

Suppression des fichiers temporaires stocks et mises à jour quotidiennes :

    bundle exec rake sirene_as_api:delete_temporary_files

Mise à jour et application des patches idoines (sans prompt) + Suppression des fichiers temporaires :

    bundle exec rake sirene_as_api:automatic_update_database

Suppression database, en cas de problèmes :

    bundle exec rake sirene_as_api:delete_database

Il est conseillé de rajouter RAILS_ENV=production au début des commandes en environnement de production.

### Mises à jour automatiques

La commande `bundle exec rake sirene_as_api:automatic_update_database` peut être lancée
a chaque nouveau fichier.
Le processus devrait être automatisé a l'installation du serveur.
Pour modifier la fréquence des mises à jour, modifiez config/schedule.rb
puis exécutez la commande :

    whenever --update-crontab

La gem [whenever](https://github.com/javan/whenever) s'occupe de mettre à jour
vos tâches cron. Par défaut la mise à jour se fait à 4h30 du matin.

L'API reste disponible sans interruptions pendant ce process, excepté ~ 3 heures lors de la
suppression / réimportation du fichier stock au début de chaque mois.

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

### Construction du dictionnaire de suggestions

Le dictionnaire se reconstruit automatiquement après un changement dans la base de donnée,
ou avec la commande suivante :

    bundle exec rake sirene_as_api:build_dictionary

# License

Ce projet est sous [license MIT](https://fr.wikipedia.org/wiki/Licence_MIT)
