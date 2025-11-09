COMPOSE = docker compose
APP_ENV ?= development

.PHONY: bootstrap
bootstrap:
	@if [ ! -f .env ]; then cp .env.example .env; fi
	$(COMPOSE) build
	$(COMPOSE) run --rm api bundle exec rails db:setup

.PHONY: up
up:
	$(COMPOSE) up --build

.PHONY: down
down:
	$(COMPOSE) down --remove-orphans

.PHONY: logs
logs:
	$(COMPOSE) logs -f

.PHONY: console
console:
	$(COMPOSE) run --rm api bundle exec rails console

.PHONY: db-shell
db-shell:
	$(COMPOSE) exec db psql -U $$POSTGRES_USER $$POSTGRES_DB

.PHONY: lint-api
lint-api:
	cd apps/api && bundle exec rubocop

.PHONY: lint-web
lint-web:
	cd apps/web && pnpm lint

.PHONY: seed
seed:
	$(COMPOSE) run --rm api bundle exec rails db:seed
