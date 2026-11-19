
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

ENVIRONMENT="${1:-dev}"

case "$ENVIRONMENT" in
    dev)
        INVENTORY="ansible/inventory-dev.ini"
        ;;
    prod)
        INVENTORY="ansible/inventory-prod.ini"
        echo "ATTENTION : tu vas déployer en PRODUCTION."
        read -rp "Confirmer le déploiement PROD ? (oui/non) : " CONFIRMATION
        if [[ "$CONFIRMATION" != "oui" ]]; then
            echo "Déploiement annulé."
            exit 0
        fi
        ;;
    *)
        echo "Usage : ./scripts/deploy.sh [dev|prod]"
        exit 1
        ;;
esac

echo "===== DEPLOIEMENT TERANGAPAY : $ENVIRONMENT ====="

if [[ ! -f infrastructure/containers/terraform.tfvars ]]; then
    echo "ERREUR : fichier terraform.tfvars introuvable."
    exit 1
fi

if [[ ! -f "$INVENTORY" ]]; then
    echo "ERREUR : inventaire $INVENTORY introuvable."
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

echo "===== ETAPE 4 : CONFIGURATION ANSIBLE ($ENVIRONMENT) ====="
ansible-playbook -i "$INVENTORY" playbooks/site.yml

echo "===== DEPLOIEMENT $ENVIRONMENT TERMINE ====="
docker ps
