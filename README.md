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

## Sunspot / SOlr

### Start the server
    > bundle exec rake sunspot:solr:start

### Stop the server
    > bundle exec rake sunspot:solr:stop

### Reindex model
    > bundle exec rake sunspot:reindex


# License

[MIT](https://fr.wikipedia.org/wiki/Licence_MIT)
