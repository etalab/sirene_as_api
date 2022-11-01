# Un fork de l'API pour le fichier SIRENE

## 🎉 Fork suite à dépréciation et besoin de développement

Suite à un besoin de développement, à la dépréciation de l'API, à l'avertissement concernant la sécurité et aux changements importants repris ci-après, à l'étude de l'intégration de l'annuaire entreprises SIRENE API dans un projet de développement plutôt que le maintien de sirene_as_api, j'ai proposé un fork du projet sirene_as_api que voici.

Les issues ont été activées sur ce dépôt.

Feel free to contribute 🎉

## ⚠ Déprécation de l'API & Avertissement concernant la sécurité ⚠

Les développements de la DINUM ont cessé sur cette API.

La version actuelle ne sera donc plus mise à jour et peut présenter d'importantes failles de sécurité.

## ⚠ Changements importants ⚠

Les endpoints V3 sont disponibles en béta. Les endpoints V1 et V2 ainsi que l'import des fichiers ancien format sont considérés dépréciés et ne recevront plus de développement futur.

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

- l'[API RNA](https://github.com/etalab/rna_as_api) est aussi disponible

## Essayez l'API

Vous pouvez interroger l'API en ligne: https://entreprise.data.gouv.fr/api/sirene/v1/full_text/ + Nom de l'entreprise recherchée (cf. plus bas pour d'autres usages).

Ou bien par le site front-end : https://entreprise.data.gouv.fr/

## Qualification des fichiers mis à disposition par l'INSEE

L'ensemble des fichiers mis à disposition pour le SIRENE se trouvent sur
[data.gouv.fr](https://www.data.gouv.fr/fr/datasets/base-sirene-des-entreprises-et-de-leurs-etablissements-siren-siret/).
On y trouve chaque début de mois un fichier dit stock qui recense toutes
les entreprises et leurs établissements.
Ces fichiers stocks mensuels sont accompagnés de fichiers de mises à jour
quotidiennes (tous les jours ouvrés), ainsi que de fichiers de mises à jour
mensuelles dites "de recalage".

### Fichiers stocks mensuels

Les données sont découpés en deux fichiers :
- les unités légales
- les établissements
-
Il s'agit de fichiers mensuels contenant toute la base de donnée, incluant donc aussi l'historique contenant les unités légales et établissements fermés.

P.S: le fichier des établissements n'est pas téléchargé depuis data.gouv.fr mais depuis data.cquest.org qui fournit des fichiers géo-codés.

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
| Activité principale de l'entreprise (code NAF)            | activite_principale       | Le code `activité principale` (code NAF)            |
| Code postal                                               | code_postal               | Le code postal désiré                               |
| Code commune INSEE                                        | code_commune              | Le code INSEE de la commune                         |
| Departement                                               | departement               | Le departement désiré                               |
| Appartenance au champs de l'économie sociale et solidaire | is_ess                    | `O` pour Oui, `N` pour Non, `I` pour Invalide       |
| Entreprises individuelles                                 | is_entrepreneur_individuel| `yes` pour Oui, `no` pour Non                       |
| Tranche effectif salarié de l'entreprise                  | tranche_effectif_salarie_entreprise | le code INSEE pour cette tranche d'effectif salarié |

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

# Requêtes v3

L'INSEE fournit depuis le 1er janvier 2019 des fichiers dans un nouveau format, l'API v3 reflète le contenu de ces nouveaux fichiers.
Il y a donc deux ressources distinctes : les unités légales (SIREN) et les établissements physiques (SIRET).

Sont uniquement fournit des fichiers de stocks mensuels, afin de rester à jour l'API récupère les modifications quotidiennes via [l'API de l'INSEE](api.insee.fr).

Vous devez ouvrir un compte afin d'obtenir un token pour que l'API se mette à jour toute seule. [À voir ici](#token-de-lapi-insee).

## Recherche directe par SIREN ou SIRET

La requête directe pour une unité légale se fait ainsi :

    curl 'localhost:3000/v3/unites_legales/:siren'

La requête directe pour un établissement se fait ainsi :

    curl 'localhost:3000/v3/etablissements/:siret'

## Recherche plus large

Pour ces endpoints, vous pouvez filtrer les résultats par n'importe lequel des champs des ressources demandées en passant les paramètres dans la requête. Exemple :

    # recherche de tous les établissments ouverts pour un siren donné
    curl 'localhost:3000/v3/etablissements/?etat_administratif=A&siren=345184428'

    # recherche de toutes les unité légales ouvertes du code postal 59 380
    curl 'localhost:3000/v3/unites_legales/?etat_administratif=A&code_postal=59380'

La pagination est controlée par les paramètres `page` et `per_page`.
Les options Solr telles que le full-text ou la géolocalisation ne sont pas encore disponibles sur ces endpoints.

# Installation et configuration

Pour installer rapidement & efficacement l'API en environnement de production,
vous pouvez vous referer a la documentation sur [sirene_as_api_ansible](https://github.com/etalab/sirene_as_api_ansible)
et utiliser les scripts de déploiement automatiques.

## Token de l'API INSEE

Afin de récupérer automatiquement les mises à jours quotidiennes de l'API SIRENE de l'INSEE il est nécessaire de renseigner `insee_credentials` dans `config/secrets.yml`.

Pour obtenir un token rendez-vous sur https://api.insee.fr/ dans : "Mes Applications"->sélectionnez ou créer une application->"Clefs et Jetons d'accès"->copiez la chaine de charactère sous "Génération des jetons d'accès" (dans l'exemple de code)

_Attention_, il ne s'agit ni de la _Clef du consommateur_, ni du _Secret du consommateur_, ni du _Jeton d'accès_.

Si vous ne souhaitez pas avoir les mises à jours via l'API commentez ou supprimer le bloc de code indiqué dans `config/schedule.yml`.

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

Les données ayant changé de format en 2019, nous assurons une continuité de service en convertissant les fichiers du nouveau format vers l'ancien. Il est donc pour le moment toujours possible d'utiliser les endpoints V1 et V2, bien qu'ils soient dépréciés.

### Fichiers ancien format (Endpoints V1 et V2)

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

#### Mises à jour automatiques

Il y a deux processus de mises à jour:

- pour la v1
- pour le reste

##### Base de données v1

    bundle exec rake sirene_as_api:automatic_update_database

##### Base de données v2/V3

    bundle exec rake sirene:update_database

##### Modifier la fréquence des mises à jour

Pour modifier la fréquence des mises à jour, modifiez config/schedule.yml
puis exécutez la commande :

    bundle exec rake sidekiq_cron:load

La gem [Sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron) gère les tâches indépendament de cron. Par défaut la mise à jour se fait à 0h30 du matin.

L'API reste disponible sans interruptions pendant ce process, excepté ~ 3 à 4 heures lors de la
suppression / réimportation du fichier stock au début de chaque mois.

#### Sunspot / Solr

  Le serveur Solr doit être actif pour toute requête ou changement sur la
  base de donnée.
  Il est nécessaire de précéder ces commandes de `RAILS_ENV=MonEnvironnement`.
  Attention, avoir plus d'un seul serveur Solr actif peut être source de
  problèmes, il est par exemple conseillé de désactiver le serveur `test`
  si vous souhaiter effectuer des opérations en `development`.

#### Demarrer le serveur

    bundle exec rake sunspot:solr:start

#### Arreter le serveur

    bundle exec rake sunspot:solr:stop

#### Réindexation

La réindexation est automatique après un changement appliqué à la base de
donnée, mais il est également possible de réindexer manuellement :

    bundle exec rake sunspot:reindex

#### Construction du dictionnaire de suggestions

Le dictionnaire se reconstruit automatiquement après un changement dans la base de donnée,
ou avec la commande suivante :

    bundle exec rake sirene_as_api:build_dictionary

#### Problèmes fréquents

Si l'API ne renvoie aucun résultat sur la recherche `fulltext` mais que la recherche `siret` fonctionne, vous avez sans doute besoin de réindexer. Tentez `RAILS_ENV=MonEnvironnement bundle exec rake sunspot:solr:reindex` (le server solr doit être actif).

En cas de problèmes avec le serveur solr, il peut être nécessaire de tuer les processus Solr en cours (obtenir le PID solr avec `ps aux | grep solr` puis les tuer avec la commande `kill MonPidSolr`). Relancer le serveur avec `RAILS_ENV=MonEnvironnement bundle exec rake sunspot:solr:start` suffit en général à corriger la situation.

Si Solr renvoie toujours des erreurs, c'est peut-être un problème causé par une allocation de mémoire trop importante. Commenter les lignes `memory` dans `config/sunspot.yml` et recommencer. Il peut être nécessaire de re-tuer les processus Solr.

En cas d'erreur 500, et si redemarrer le serveur après l'avoir tué ne suffit pas (echec à l'initialisation du core solr), la suppression du contenu du dossier 'data' de l'environnement cible peut résoudre le problème (il sera alors nécessaire de réindexer).

Dans certains cas, le déploiement par Mina ne copie pas correctement les fichiers solr.
En cas d'erreur 404 - Solr not found, assurez vous que le fichier /solr/MonEnvironnement/core.properties est bien présent. Sinon, vous pouvez l'ajouter manuellement.

Si tout fonctionne sauf les suggestions, c'est probablement que le dictionnaire de suggestions n'a pas été construit. Executez la commande : `RAILS_ENV=MonEnvironnement bundle exec rake sirene_as_api:build_dictionary`

### Fichiers nouveau format (Endpoint V3)

L'import pour les fichiers V3 a été entièrement réecrit et utilise maintenant la librairie sidekiq-cron. Il est possible de lancer sidekiq avec la commande `bundle exec sidekiq`.

La base devrait lancer une mise à jour automatiquement selon les horaires de la configuration définie dans `config/schedule.yml`. La configuration par défaut est pour les environnements sandbox et production.

Les informations relatives aux stocks sont enregistrées en base de données. Un stock avec un statut PENDING ou LOADING indique une opération en cours et empêche de relancer l'opération d'import.

#### Mises à jour automatiques

Il est conseillé de lancer sidekiq non pas manuellement mais avec l'ajout d'un service (à l'aide de systemd sur server debian ou ubuntu). Exemple de configuration possible du service :

```
[Service]
Type=simple
WorkingDirectory=/var/www/{{ app_name }}/current
# If you use rbenv:
# ExecStart=/bin/bash -lc 'bundle exec sidekiq -e production'
# If you use the system's ruby:
ExecStart={{ bundle_path }} exec sidekiq -e {{ rails_env }} -L {{ log_file }} -C {{ config_file }}
User={{ service_user }}
Group={{ service_group }}
UMask=0002

# if we crash, restart
RestartSec=1
Restart=on-failure

# This will default to "bundler" if we don't specify it
SyslogIdentifier=sidekiq

[Install]
```

Les tâches sidekiq s'éxecutent automatiquement en arrière plan. L'installation d'un server Redis est nécessaire pour l'enregistrement de la liste des tâches :

`sudo apt-get install redis-server`

Pour relier le serveur Redis à l'application, il est nécessaire de fournir son adresse dans la configuration Rails :

`config.redis_database = 'redis://localhost:6379/1'`

#### Mise à jour manuelle immédiate

Il est possible de lancer une mise à jour immédiate par la console rails. Pour l'environnement `development` :

```
rails c development
UpdateDatabaseJob.perform_now
```

Une fois celle-ci terminée il est possible de lancer les mises à jours quotidiennes :

```ruby
DailyUpdateJob.perform_now
```

#### Connaître l'état des mises à jours

Ce fichier contient le nom du dernier fichier importé avec succès en v1 :

```shell
cat .last_monthly_stock_applied/last_monthly_stock_link_name.txt
```

Pour l'import v2, dans la console Rails :

```shell
Stock.last
```

# License

Ce projet est sous [license MIT](https://fr.wikipedia.org/wiki/Licence_MIT)

# Contributions

Vous pouvez contribuer à ce projet open-source, par exemple [en nous ouvrant une PR](https://github.com/etalab/sirene_as_api/pulls).
