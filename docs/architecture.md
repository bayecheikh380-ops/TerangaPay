# Architecture technique de TerangaPay

## 1. Présentation

TerangaPay est une plateforme composée d'une API web, d'une base de données
relationnelle, d'un service de cache et d'un reverse proxy.

Le projet utilise Docker pour exécuter les services, OpenTofu pour provisionner
une partie de l'infrastructure et Ansible pour configurer les conteneurs.

## 2. Composants

| Composant | Technologie | Responsabilité |
|---|---|---|
| Reverse proxy | Nginx | Recevoir les requêtes HTTP et les transmettre à l'API |
| API | Python / Flask | Exposer les routes de la plateforme |
| Base de données | PostgreSQL | Stocker les données |
| Cache | Redis | Fournir un service de cache |
| Infrastructure | OpenTofu | Créer le réseau et les ressources Docker |
| Configuration | Ansible | Configurer et démarrer les services |

## 3. Schéma logique

```text
Utilisateur
    |
    | HTTP : 127.0.0.1:8080
    v
Nginx (Reverse Proxy)
    |
    | Réseau Docker privé
    v
API Flask
    |
    +----------> PostgreSQL
    |             Volume persistant
    |
    +----------> Redis
    |
    +----------> Redis

## 4. Réseau et sécurité

Les services communiquent sur le réseau Docker privé `terangapay-network`.

Seul Nginx publie un port sur la machine hôte :
`127.0.0.1:8080`.

PostgreSQL, Redis et l'API ne publient pas directement de port sur l'hôte.

## 5. Persistance

PostgreSQL utilise le volume Docker nommé `terangapay-postgres-data`.
Ce volume permet de conserver les données lorsque le conteneur est recréé.

## 6. Déploiement et configuration

OpenTofu provisionne le réseau Docker et les ressources de base de données
et de cache.

Ansible intervient ensuite avec trois rôles :
- database : vérification de la disponibilité de PostgreSQL ;
- app : construction et démarrage de l'API Flask ;
- proxy : configuration et démarrage de Nginx.

## 7. Vérification

Les routes utilisées pour les tests sont :
- `/` : page d'accueil ;
- `/health` : état de santé de l'API ;
- `/db` : vérification de la connexion à PostgreSQL.

Le script `tests/e2e.sh` vérifie ces trois routes.
