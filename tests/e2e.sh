#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8080}"

echo "===== TEST 1 : ACCUEIL ====="
curl --silent --show-error --fail "$BASE_URL/" | grep -q "TerangaPay"
echo "OK : page d'accueil accessible"

echo "===== TEST 2 : SANTE API ====="
curl --silent --show-error --fail "$BASE_URL/health" | grep -q '"status":"OK"'
echo "OK : API opérationnelle"

echo "===== TEST 3 : CONNEXION BASE DE DONNEES ====="
curl --silent --show-error --fail "$BASE_URL/db" | grep -q '"database":"connected"'
echo "OK : connexion PostgreSQL opérationnelle"

echo "===== RESULTAT ====="
echo "Tous les tests de bout en bout sont réussis."
