# ADR-0002 : Persistance des données PostgreSQL

## Statut
Accepté

## Contexte
TerangaPay utilise PostgreSQL pour stocker les données de la plateforme.
Les données ne doivent pas disparaître lors de la suppression ou de la
recréation du conteneur.

## Décision
Utiliser un volume Docker nommé :
terangapay-postgres-data

Ce volume est monté dans le conteneur PostgreSQL au chemin :
/var/lib/postgresql/data

## Conséquences
Les données sont conservées indépendamment du cycle de vie du conteneur.
Cette solution facilite la maintenance et limite les risques de perte
des données lors d'un redémarrage ou d'une recréation du conteneur.
