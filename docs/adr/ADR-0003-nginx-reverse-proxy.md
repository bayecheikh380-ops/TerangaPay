# ADR-0003 : Utilisation de Nginx comme reverse proxy

## Statut
Accepté

## Contexte
L'API Flask de TerangaPay doit être accessible depuis un point d'entrée
unique, sans exposer directement les autres conteneurs sur la machine hôte.

## Décision
Utiliser Nginx comme reverse proxy.
Nginx reçoit les requêtes HTTP sur le port 8080 de la machine locale
et les transmet à l'API Flask sur le port 8080 du réseau Docker privé.

Le port publié est limité à 127.0.0.1.

## Conséquences
L'accès à l'API passe par un point d'entrée unique.
Les conteneurs PostgreSQL, Redis et Flask ne publient pas directement
leurs ports sur la machine hôte.

Cette organisation améliore l'isolation des services.
