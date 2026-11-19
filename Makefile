.PHONY: help fmt validate plan status logs test e2e

help:
	@echo "TerangaPay - Commandes disponibles"
	@echo "make fmt       : formater les fichiers OpenTofu"
	@echo "make validate  : valider les configurations"
	@echo "make plan      : afficher les changements prévus"
	@echo "make status    : afficher les conteneurs"
	@echo "make logs      : afficher les journaux de l'API"
	@echo "make e2e       : lancer les tests de bout en bout"
	@echo "make test      : lancer les tests de bout en bout"

fmt:
	tofu -chdir=infrastructure/network fmt -recursive
	tofu -chdir=infrastructure/containers fmt -recursive

validate:
	tofu -chdir=infrastructure/network validate
	tofu -chdir=infrastructure/containers validate

plan:
	tofu -chdir=infrastructure/network plan
	tofu -chdir=infrastructure/containers plan

status:
	docker ps

logs:
	docker logs --tail 50 terangapay-app

e2e:
	bash tests/e2e.sh

test: e2e
