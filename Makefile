include make/*.mk

.PHONY: up down

up: ## Sobe PostgreSQL e pgweb
	docker compose --profile pgweb up -d

down: ## Derruba PostgreSQL e pgweb
	docker compose --profile pgweb down
