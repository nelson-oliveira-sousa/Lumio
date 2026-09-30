# HAR-10 · Alvos do harness. Inclua no Makefile principal com:
#   include make/*.mk

PACK ?=

.PHONY: test-pack test-changed lint

test-pack: ## Testes de um pack: make test-pack PACK=membros
	@test -n "$(PACK)" || (echo "Uso: make test-pack PACK=<nome>"; exit 1)
	@test -d packs/$(PACK)/spec || (echo "Pack '$(PACK)' não tem spec/"; exit 1)
	bundle exec rspec packs/$(PACK)/spec

test-changed: ## Testes do que mudou em relação à main
	@scripts/testes-alterados.sh

lint: ## RuboCop + linter do frontend
	bundle exec rubocop
	npm run lint --if-present
