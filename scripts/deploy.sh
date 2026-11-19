#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "===== DEPLOIEMENT TERANGAPAY ====="

if [[ ! -f infrastructure/containers/terraform.tfvars ]]; then
    echo "ERREUR : fichier terraform.tfvars introuvable."
    exit 1
fi

read -rsp "Saisis le mot de passe PostgreSQL : " POSTGRES_PASSWORD
echo
export POSTGRES_PASSWORD

echo "===== ETAPE 1 : INITIALISATION OPENTOFU ====="
tofu -chdir=infrastructure/network init -input=false
tofu -chdir=infrastructure/containers init -input=false

echo "===== ETAPE 2 : CREATION DU RESEAU ====="
tofu -chdir=infrastructure/network apply -auto-approve

echo "===== ETAPE 3 : BASE DE DONNEES ET REDIS ====="
tofu -chdir=infrastructure/containers apply -auto-approve -var-file=terraform.tfvars

echo "===== ETAPE 4 : CONFIGURATION ANSIBLE ====="
ansible-playbook playbooks/site.yml

echo "===== DEPLOIEMENT TERMINE ====="
docker ps
