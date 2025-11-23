COMPOSE ?= docker compose
ENV_FILE ?= .env

.PHONY: bootstrap
bootstrap:
	@if [ ! -f $(ENV_FILE) ]; then cp .env.example $(ENV_FILE); fi
	$(COMPOSE) build
	$(COMPOSE) run --rm web bundle install
	$(COMPOSE) run --rm web bin/rails db:prepare
	$(COMPOSE) run --rm web bin/rails db:seed
	$(COMPOSE) run --rm frontend pnpm install

.PHONY: up
up:
	$(COMPOSE) up

.PHONY: up-build
up-build:
	$(COMPOSE) up --build

.PHONY: down
down:
	$(COMPOSE) down --remove-orphans

.PHONY: logs
logs:
	$(COMPOSE) logs -f

.PHONY: console
console:
	$(COMPOSE) run --rm web bin/rails console

.PHONY: db-shell
db-shell:
	$(COMPOSE) exec db psql -U $$POSTGRES_USER $$POSTGRES_DB

.PHONY: lint-backend
lint-backend:
	$(COMPOSE) run --rm web bundle exec rubocop

.PHONY: lint-frontend
lint-frontend:
	$(COMPOSE) run --rm frontend pnpm lint

.PHONY: test
test:
	$(COMPOSE) run --rm web bin/rails test

.PHONY: seed
seed:
	$(COMPOSE) run --rm web bin/rails db:seed
