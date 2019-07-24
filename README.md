
[![Maintainability](https://api.codeclimate.com/v1/badges/cb7334374140808435c3/maintainability)](https://codeclimate.com/github/etalab/sirene_as_api/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/cb7334374140808435c3/test_coverage)](https://codeclimate.com/github/etalab/sirene_as_api/test_coverage)

## ⚠ Breaking Changes ⚠

#### Mise à jour au 23/07/19 :
L'API renvoie pour le moment les données de mi-avril 2019. Nous travaillons à la prochaine version qui nous permettra de renvoyer les données à jour.
Attention, la nouvelle version nécessite de drop puis réinstaller la base de donnée.

### Comment me tenir au courant des prochains changements ?

Notre site frontend présente dorénavant la possibilité de s'inscrire sur [une mailing-list](https://entreprise.data.gouv.fr/api_doc). Si vous utilisez notre API régulièrement, nous vous conseillons de vous inscrire.

Vous pouvez également nous contacter au travers des issues de ce repo GitHub.



# SIRENE_as_api

Dans le cadre du SPD, (Service Public de la Donnée), certains jeux de données
dont le fichier SIRENE sont devenus publics.

Le projet SIRENE_as_api a pour vocation de mettre en valeur la donnée brute en
la servant sous forme d'API.

Le projet se découpe en trois sous-projets :

- Une API Ruby on Rails qui importe les fichiers de données mis à disposition par l'INSEE : [sirene_as_api](https://github.com/etalab/sirene_as_api)

- Un script capable de déployer l'API automatiquement : [sirene_as_api_ansible](https://github.com/etalab/sirene_as_api_ansible)

- Une interface web de recherche exploitant l'API en Vue.js : [entreprise.data.gouv.fr](https://github.com/etalab/entreprise.data.gouv.fr)

Nouveau ! l'[API RNA](https://github.com/etalab/rna_as_api) est disponible !

## Essayez l'API

Vous pouvez interroger l'API en ligne: https://entreprise.data.gouv.fr/api/sirene/v1/full_text/ + Nom de l'entreprise recherchée (cf. plus bas pour d'autres usages).

Ou bien par le site front-end : https://entreprise.data.gouv.fr/

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

### Limitations des fichiers Sirene

L'INSEE ne délivre pour le moment pas les établissements refusant la prospection commerciale. Ces établissements sont donc manquants de la base Sirene.

# Requêtes V1

Trois endpoints principaux sont disponibles sur l'API :

## Recherche FullText

Il s'agit de l'endpoint principal. Vous pouvez faire des requêtes avec Curl :

    curl 'localhost:3000/v1/full_text/MA_RECHERCHE'

ou simplement en copiant l'adresse ´localhost:3000/v1/full_text/MA_RECHERCHE´
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

    curl 'localhost:3000/v1/suggest/MA_RECHERCHE'

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
| Activité principale de l'entreprise (code NAF)                       | activite_principale       | Le code `activité principale` (code NAF)                |
| Code postal                                               | code_postal               | Le code postal désiré                               |
| Code commune INSEE                                             | code_commune              | Le code INSEE de la commune                     |
| Departement                                               | departement               | Le departement désiré                               |
| Appartenance au champs de l'économie sociale et solidaire | is_ess                    | `O` pour Oui, `N` pour Non, `I` pour Invalide       |
| Entreprises individuelles                                 | is_entrepreneur_individuel| `yes` pour Oui, `no` pour Non                       |
| Tranche effectif salarié de l'entreprise                                 | tranche_effectif_salarie_entreprise | le code INSEE pour cette tranche d'effectif salarié |

D'autres facettes pourront être implémentées en fonction des retours utilisateurs.

Référence rapide pour les codes INSEE de tranches d'effectifs salariés :

| Code à renseigner| Signification |
|----|-----------------------------|
| NN | Unités non employeuses |
| 00 | 0 salarié |
| 01 | 1 ou 2 salariés |
| 02 | 3 à 5 salariés |
| 03 | 6 à 9 salariés |
| 11 | 10 à 19 salariés |
| 12 | 20 à 49 salariés |
| 21 | 50 à 99 salariés |
| 22 | 100 à 199 salariés |
| 31 | 200 à 249 salariés |
| 32 | 250 à 499 salariés |
| 41 | 500 à 999 salariés |
| 42 | 1 000 à 1 999 salariés |
| 51 | 2 000 à 4 999 salariés |
| 52 | 5 000 à 9 999 salariés |
| 53 | 10 000 salariés et plus |

### Exemple

Je souhaite les entreprises individuelles avec "foobar" dans le nom, je désire 15
résultats par page et afficher la deuxième page (soit les résultats 15 à 30) :

    curl 'localhost:3000/v1/full_text/foobar?page=2&per_page=15&is_entrepreneur_individuel=yes'

## Recherche par Numéro SIRET

La requête se fait par :

    curl 'localhost:3000/v1/siret/MON_SIRET'

L'API renvoie un JSON de l'établissement correspondant.

## Recherche par Numéro SIREN (établissements enfants)

La requête se fait par :

    curl 'localhost:3000/v1/siren/MON_SIREN'

l'API renvoie :

- Le nombre total de sirets existants à partir de ce siren.
- Les données de l'établissement siège correspondant à ce siren.
- La liste des sirets enfants (sirets correspondants à ce siren & qui ne sont pas le siège de l'établissement)
- Le numéro de TVA intracommunautaire.

## Autres endpoints

Un endpoint spécial "suggestions de recherche" est disponible :

    curl 'localhost:3000/v1/suggest/MA_RECHERCHE'

# Recherche par géolocalisation

L'API intègre dorénavant la géolocalisation des établissements.

## Établissements autour d'un point

La requête se fait par :

    curl 'localhost:3000/v1/near_point/?lat=LATITUDE&long=LONGITUDE'

Oú LATITUDE et LONGITUDE sont un point autour duquel vous désirez chercher des établissements. Vous pouvez également préciser le radius de recherche (défaut: 5km). Les résultats sont paginés de la même façon que précedemment.

Les options de filtrage suivantes sont disponibles :

| Filtrage désiré                                           | Requête GET               | Valeur                                              |
|-----------------------------------------------------------|---------------------------|-----------------------------------------------------|
| Filtrage par activité principale (code NAF) | activite_principale               | Code NAF desiré |
| Filtrage par code NAF approximé | approximate_activity               | 2 premiers chars du code NAF (Ex: 62 pour 620Z) |
| Radius de recherche | radius               | Entier ou flottant |

## Établissements autour d'un autre établissement

La requête se fait par :

    curl 'localhost:3000/v1/near_etablissement/SIRET'

avec SIRET le siret de l'établissement autour duquel chercher.

| Filtrage désiré                                           | Requête GET               | Valeur                                              |
|-----------------------------------------------------------|---------------------------|-----------------------------------------------------|
| Seulement les établissements avec la même activité principale (code NAF) | only_same_activity               | true / false (défaut: false) |
| Seulement les établissements avec une activité principale proche | approximate_activity               | true / false (défaut: false) |
| Radius de recherche | radius               | Entier ou flottant |

Le système de pagination étant toujours là, les paramètres `page` ou `per_page` sont disponibles.

## Établissements autout d'un autre établissement, format GeoJSON

Si vous désirez l'endpoint précedent au format GeoJSON, la requête se fait par :

    curl 'localhost:3000/v1/near_etablissement_geojson/SIRET'

Les résultats ne sont pas paginés.

Afin d'éviter une surcharge du serveur, seuls les 500 établissements les plus proches sont retournés. Cette option est modifiable dans le controller /app/controllers/api/v1/near_etablissement_geojson_controller.rb si vous désirez installer votre propre version de l'API.

Les mêmes filtres que /near_etablissement/ sont disponibles.

# Requêtes V2

Des endpoints sont en reconstruction en V2 ajoutant des informations supplémentaires. Les endpoints V1 ne sont pas discontinués.

## Endpoint SIREN V2

L'endpoint SIREN V2 ajoute des métadonnées, et un lien vers la requête RNM (Répertoire National des Métiers) correspondante pour ce SIREN.

La requête se fait par :

    curl 'localhost:3000/v2/siren/:SIREN'

Le format de réponse se divise entre :

- Sirene : Données et métadonnées
- Repertoire National des Métiers : Lien vers la requête et métadonnées
- Computed : Informations calculées automatiquement (Numéro TVA introcommunautaire, Géocodage...). Les métadonnées précisent les calculs. ⚠ Attention ⚠ De par leur nature, les données calculées peuvent être érronnées.

On peut également requêter des informations supplémentaires sur les établissements liés à un SIREN :

    curl 'localhost:3000/v2/siren/:SIREN/etablissements'

On peut également demander ce retour au format GeoJSON :

    curl 'localhost:3000/v2/siren/:SIREN/etablissements_geojson'

# Installation et configuration

Pour installer rapidement & efficacement l'API en environnement de production,
vous pouvez vous referer a la documentation sur [sirene_as_api_ansible](https://github.com/etalab/sirene_as_api_ansible)
et utiliser les scripts de déploiement automatiques.

## Nouveau : Installation avec Docker

Si vous disposez de docker et de docker-compose, vous pouvez lancer le serveur en local avec les commandes suivantes :

Une fois cloné ce répertoire à l'aide de

    git clone git@github.com:etalab/sirene_as_api.git && cd sirene_as_api

Construisez le container avec `docker-compose build` et lancez-le avec `docker-compose up`.

Pour faciliter l'interaction avec le container du serveur, il est conseillé d'utiliser le mode interactif (à partir d'un autre terminal) :

    docker exec -it <nom_container> bash

Vous pourrez ainsi exécuter, de manière transparente, toutes les tâches d'administration et de mises à jour présentées dans les sections suivantes. Sinon vous pouvez prendre exemple sur les commandes ci-dessous dans cette même section.

Vous pouvez effectuer les migrations (nécessaire seulement au premier lancement) à l'aide de :

    docker-compose run sirene bundle exec rails db:create
    docker-compose run sirene bundle exec rails db:migrate

La base de donnée sera persistée dans le dossier `/var/lib/postgresql` par défaut. Il est possible  de changer l'emplacement d'installation des données ou d'indiquer un emplacement d'installation existante en modifiant la variable d'environnement `POSTGRES_DATA` dans le fichier `.env`.

La base de donnée Postgres de docker se link sur le port 5432, donc assurez vous de ne pas avoir postgres qui tourne déjà sur ce port, ou bien modifiez `docker-compose.yml`

Si votre machine comprend déjà une base installée sur `/var/lib/postgresql`, libre à vous de modifier le fichier `.env` :
```yml
POSTGRES_DATA=/path/to/other/data_folder
```

Lancez les imports à l'aide des commandes rake (Cf plus bas, partie Mises à jour / Administration) précédées par `docker-compose run sirene`. Par exemple :

    docker-compose run sirene rake sirene_as_api:populate_database

Vous pouvez d'ors et déjà interroger l'API sur `http://localhost:3000/v1/siren/552032534`.

La recherche fulltext devrait fonctionner après avoir executé `docker-compose run sirene rake sunspot:solr:reindex`. Les index solr sont persistés egalement.

Attention : pour faciliter les modifications par nos utilisateurs, le docker est lancé en environnement de développement. N'oubliez pas de changer le mot de passe postgres dans /config/docker/init.sql, /config/docker/database.yml et docker-compose.yml.

Il peut y avoir une erreur 500 Solr au premier lancement, dans ce cas un simple `docker-compose down` puis `docker-compose up` peut suffir à relancer le server correctement.

## Installation manuelle en environnement dev

Pour une installation manuelle, vous aurez besoin de :

- postgresql en version supérieure a 9.5, la dernière version stable de
  préférence
- ruby en version 2.4.2
- git installé
- bundler installé
- un runtime java pour solr

 Pour vous simplifier la tâche, nous vous conseillons d'utiliser le script Ansible mis a disposition pour déployer votre
 architecture. Une tâche [Mina](https://github.com/mina-deploy/mina) est également disponible (fichier config/deploy.rb). Vous pouvez la modifier pour entrer vos propres valeurs.

Une fois cloné ce répertoire à l'aide de

    git clone git@github.com:etalab/sirene_as_api.git && cd sirene_as_api

Lancez bundle install pour récupérer les gems nécessaires, ceci peut prendre un
peu de temps en fonction de votre installation. Vous pouvez omettre l'installation de
bundler s'il est déjà présent sur la machine

    gem install bundler && bundle install

### Preparation de la base de donnée

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

### Mises à jour automatique (Infrastructure à double server)

Pour assurer une continuité de service 24/7 et ce même pendant la reconstruction de la base de donnée, nous utilisons un système de double-server. Si vous désirez les réglages pour un seul server, reportez vous à la section suivante.

Nous utilisons la commande `bundle exec rake sirene_as_api:dual_server_update` pour effectuer la mise à jour : le server va effectuer une mise à jour, tester si tout fonctionne, puis effectuer un switch d'IP fallback sur lui-même.

Si vous avez 2 servers, vous pouvez modifier /config/switch_server.rb pour ajouter vos propres valeurs.

### Mises à jour automatiques (1 seul server)

La commande `bundle exec rake sirene_as_api:automatic_update_database` permet la mise à jour automatique de la base de donnée.
Pour modifier la fréquence des mises à jour, modifiez config/schedule.rb
puis exécutez la commande :

    whenever --update-crontab

La gem [whenever](https://github.com/javan/whenever) s'occupe de mettre à jour
vos tâches cron. Par défaut la mise à jour se fait à 4h30 du matin.

L'API reste disponible sans interruptions pendant ce process, excepté ~ 3 à 4 heures lors de la
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

# Problèmes fréquents

Si l'API ne renvoie aucun résultat sur la recherche `fulltext` mais que la recherche `siret` fonctionne, vous avez sans doute besoin de réindexer. Tentez `RAILS_ENV=MonEnvironnement bundle exec rake sunspot:solr:reindex` (le server solr doit être actif).

En cas de problèmes avec le serveur solr, il peut être nécessaire de tuer les processus Solr en cours (obtenir le PID solr avec `ps aux | grep solr` puis les tuer avec la commande `kill MonPidSolr`). Relancer le serveur avec `RAILS_ENV=MonEnvironnement bundle exec rake sunspot:solr:start` suffit en général à corriger la situation.

Si Solr renvoie toujours des erreurs, c'est peut-être un problème causé par une allocation de mémoire trop importante. Commenter les lignes `memory` dans `config/sunspot.yml` et recommencer. Il peut être nécessaire de re-tuer les processus Solr.

En cas d'erreur 500, et si redemarrer le serveur après l'avoir tué ne suffit pas (echec à l'initialisation du core solr), la suppression du contenu du dossier 'data' de l'environnement cible peut résoudre le problème (il sera alors nécessaire de réindexer).

Dans certains cas, le déploiement par Mina ne copie pas correctement les fichiers solr.
En cas d'erreur 404 - Solr not found, assurez vous que le fichier /solr/MonEnvironnement/core.properties est bien présent. Sinon, vous pouvez l'ajouter manuellement.

Si tout fonctionne sauf les suggestions, c'est probablement que le dictionnaire de suggestions n'a pas été construit. Executez la commande : `RAILS_ENV=MonEnvironnement bundle exec rake sirene_as_api:build_dictionary`

# License

Ce projet est sous [license MIT](https://fr.wikipedia.org/wiki/Licence_MIT)
