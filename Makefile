
.PHONY: help fmt validate plan deploy destroy status logs test e2e lint secrets-check gitops-start gitops-stop versions

help:
	@echo "===== TERANGAPAY - COMMANDES ====="
	@echo "make deploy        : deployer l'application"
	@echo "make destroy       : afficher les précautions de destruction"
	@echo "make fmt           : formater OpenTofu"
	@echo "make validate      : valider OpenTofu"
	@echo "make plan          : afficher les changements prévus"
	@echo "make test          : lancer les tests"
	@echo "make e2e           : lancer les tests de bout en bout"
	@echo "make lint          : contrôler YAML et Ansible"
	@echo "make secrets-check : rechercher les secrets exposés"
	@echo "make gitops-start  : démarrer l'agent GitOps"
	@echo "make gitops-stop   : arrêter l'agent GitOps"
	@echo "make versions      : afficher les versions"
	@echo "make status        : afficher les conteneurs"
	@echo "make logs          : afficher les journaux de l'API"

fmt:
	tofu -chdir=infrastructure/network fmt -recursive
	tofu -chdir=infrastructure/containers fmt -recursive

validate:
	tofu -chdir=infrastructure/network validate
	tofu -chdir=infrastructure/containers validate

plan:
	tofu -chdir=infrastructure/network plan
	tofu -chdir=infrastructure/containers plan

deploy:
	bash scripts/deploy.sh

destroy:
	@echo "Protection PostgreSQL active : prevent_destroy = true"
	@echo "Destruction bloquée pour protéger les données."
	@echo "Effectuer une sauvegarde et une procédure contrôlée avant toute suppression."
	@exit 1

status:
	docker ps

logs:
	docker logs --tail 50 terangapay-app

e2e:
	bash tests/e2e.sh

test: e2e

lint:
	yamllint .
	ansible-lint --offline playbooks/site.yml ansible/roles/

secrets-check:
	gitleaks detect --source . --config .gitleaks.toml --no-banner --redact
gitops-start:
	@if [ -f gitops/agent_gitops.sh ]; then \
		bash gitops/agent_gitops.sh start; \
	else \
		echo "Agent GitOps non encore configuré."; \
		exit 1; \
	fi

gitops-stop:
	@if [ -f gitops/agent_gitops.sh ]; then \
		bash gitops/agent_gitops.sh stop; \
	else \
		echo "Agent GitOps non encore configuré."; \
		exit 1; \
	fi

versions:
	@tofu version
	@docker --version
	@ansible --version
	@python3 --version
	@make --version | head -n 1
