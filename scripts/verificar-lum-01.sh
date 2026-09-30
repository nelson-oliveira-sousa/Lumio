#!/usr/bin/env bash
# LUM-01 · Verifica os 3 critérios de aceite do ambiente de desenvolvimento Docker.
set -euo pipefail
cd "$(dirname "$0")/.."

erro() { echo "FALHOU: $1" >&2; exit 1; }

echo "1) Nenhuma senha em arquivo versionado"
git ls-files | grep -qx '\.env' && erro ".env está rastreado pelo git"
grep -qE 'POSTGRES_PASSWORD:\s*\$\{POSTGRES_PASSWORD:-' docker-compose.yml && erro "docker-compose.yml define senha default para POSTGRES_PASSWORD"
echo "   ok"

echo "2) Portas presas em 127.0.0.1"
grep -qE '^\s*- "127\.0\.0\.1:\$\{POSTGRES_PORT' docker-compose.yml || erro "porta do postgres não está presa em 127.0.0.1"
grep -qE '^\s*- "127\.0\.0\.1:\$\{PGWEB_PORT' docker-compose.yml || erro "porta do pgweb não está presa em 127.0.0.1"
echo "   ok"

echo "3) make up sobe banco e pgweb"
export POSTGRES_PASSWORD="verificacao-$$"
trap 'docker compose --profile pgweb down -v >/dev/null 2>&1 || true' EXIT
make up >/dev/null
docker compose ps db | grep -q "healthy" || erro "db não ficou healthy"
docker compose ps pgweb | grep -q "Up" || erro "pgweb não subiu"
echo "   ok"

echo "LUM-01: todos os critérios de aceite verificados."
