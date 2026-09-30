# ADR-0004: Usar só PostgreSQL, sem Redis

- **Status:** Aceito
- **Data:** 2026-09-29

## Contexto
O Rails 8 oferece Solid Queue e Solid Cache apoiados em banco. Menos serviços significa menos coisa para operar, fazer backup e proteger.

## Decisão
PostgreSQL 16 é o único serviço de dados. Solid Queue e Solid Cache ficam no banco principal, com autovacuum agressivo nas tabelas deles. As extensões usadas são `ltree` e `pg_trgm`.

## Alternativas descartadas
- **Redis para fila e cache**: um serviço a mais sem gargalo que o justifique.
- **Banco separado para fila**: impede o enfileiramento transacional em que o ADR-0003 se apoia.

## Consequências
- Backup e restauração cobrem tudo de uma vez.
- Pode haver contenção de fila e cache no mesmo banco. Monitorar com PgHero.
- Revisitar se a latência de cache ou o volume de jobs pesar no banco.
