# ADR-0001 : Répartition des responsabilités entre OpenTofu et Ansible

## Statut
Accepté

## Contexte
TerangaPay utilise plusieurs conteneurs Docker. Il faut séparer la création
de l'infrastructure de la configuration et du démarrage des services.

## Décision
OpenTofu est utilisé pour provisionner les ressources d'infrastructure,
notamment le réseau Docker et les ressources persistantes.

Ansible est utilisé pour configurer et démarrer les services applicatifs,
notamment l'API Flask et le reverse proxy Nginx.

## Conséquences
Cette séparation facilite la maintenance et rend les opérations plus lisibles.
OpenTofu gère l'infrastructure déclarative, tandis qu'Ansible applique
la configuration des services.

Le déploiement complet automatisé en une seule commande reste à finaliser.
