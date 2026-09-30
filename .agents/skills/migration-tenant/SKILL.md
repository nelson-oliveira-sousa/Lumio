---
name: migration-tenant
description: Cria uma migration que roda em todos os schemas de tenant do Lumio. Use sempre que um card pedir tabela, coluna ou índice em dados de tenant.
---

# Migration de tenant

O usuário (ou o card) descreve a mudança. Regras:

- Arquivo em `db/tenant_migrate/<timestamp>_<nome>.rb`. **Nunca** em `db/migrate/`, que é só do `public`.
- Sem FK para tabelas do `public`: guarde o id e valide na aplicação.
- Índices em tabelas grandes: `algorithm: :concurrently` + `disable_ddl_transaction!`.
- Nomes de tabela e coluna seguem `docs/glossario.md`. Nada de `igreja`, `campo`, `congregacao`.
- Coluna sensível? Anote no PR que ela precisa de `encrypts` no model.

Depois:
1. Mostre a migration e espere a confirmação.
2. Rode `bin/rails tenants:migrate` (vai pedir aprovação).
3. Confirme que nenhuma `schema_migrations` do `public` registrou a versão.
4. Rode os testes do pack afetado.
