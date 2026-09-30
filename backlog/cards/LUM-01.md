---
id: LUM-01
titulo: "Ambiente de desenvolvimento com Docker"
tipo: Produto
epico: "Fundação"
fase: "Fase 1 · Fundação"
etapa: "Fase 1 · Fundação"
status: Em revisão
depende_de: []
---

# LUM-01 · Ambiente de desenvolvimento com Docker

## Entrega
docker-compose.yml com PostgreSQL 16 e pgweb (profiles), Dockerfile.dev e .env.example.

## Critérios de aceite
- [x] Nenhuma senha em arquivo versionado
- [x] Portas presas em 127.0.0.1
- [x] `make up` sobe banco e pgweb

## Contexto
Sem pack afetado (infra de raiz). Segue ADR-0004 (só PostgreSQL, sem Redis).
Não há Rails/RSpec ainda no repo (chega no LUM-03), então não existe canônico em
`docs/padroes.md` aplicável; este PR é o primeiro arquivo de infra Docker do projeto.

## Observações
`make up`/`make down` foram criados neste card, mínimos, só para satisfazer o
critério de aceite — o Makefile completo (help/env/setup/dev/jobs/ci/deploy) é
escopo do LUM-02, que depende deste card.

Critérios verificados com `scripts/verificar-lum-01.sh` (roda `make up` de fato,
com senha só na env do shell, nunca em arquivo).
