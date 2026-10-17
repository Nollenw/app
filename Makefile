include .env
export

PROJECT_ROOT := $(shell pwd)


env-up:
	@docker compose up -d todoapp-postgres

env-down:
	@docker compose down todoapp-postgres
env-cleanup:
	@read -p "Очичтить все файлы [y/N]": ans; \
	if ["$$ans" = "y"]; then \
		docker compose down todoapp-postgres && \
		rm -rf out/pgdata && \
		echo "Falies has been deleted"
	else \
		echo "Canselled"
	fi

migrate-create:
	@if [ -z "$(seq)"]; then \
		echo "Please specify seq" \
		exit 1; \
	fi; \
	docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		seq "$(seq)"
migrate-action:
	@if [ -z "$(action)"]; then \
		echo "Please specify action" \
		exit 1; \
	fi; \
	docker compose run --rm todoapp-postgres-migrate \
	path /migrations \
	database postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@todoapp-postgres:5432/$(POSTGRES_DB)?sslmode=disable \
	"$(action)"
migarate-up:
	@make migrate-action action=up
migarate-down:
	@make migrate-action action=down
ports-forward:
	@docker compose up -d port-forwade