---
name: codigo-tenant
description: Regras para escrever código multi-tenant no Lumio. Use sempre que for criar ou alterar model, query, job, cache, migration, controller ou teste que toque dados de tenant (membros, unidades, cargos, perfis, vínculos, documentos).
---

# Código multi-tenant no Lumio

Cada tenant é um schema PostgreSQL (`tenant_<id>`). Detalhes em `docs/adr/0002-schema-por-tenant.md`.

## Onde está cada tabela
- `public`: `tenants`, `usuarios`, fila e cache do Solid, cobrança, registro de chamadas externas
- schema do tenant: tudo da organização para baixo (organização, unidades, perfis, vínculos, membros, cargos, documentos)

Se não souber onde uma tabela nova vai, **pergunte**. Errar isso vaza dados.

## Regras
1. **Consulta**: dado de tenant só dentro de `Tenancy::Api.com_tenant(id) { ... }`. Em request, o controller base já entrou no tenant. Em job, console ou rake, entre você.
2. **Job**: herde de `SharedKernel::TenantJob` e passe `tenant_id:` no `perform_later`. Nunca passe objeto AR, só ids.
3. **Cache**: use `SharedKernel::Cache.fetch(chave)`, que prefixa `t:<id>:`. Nunca chame `Rails.cache` direto com dado de tenant.
4. **Migration**: tabela de tenant em `db/tenant_migrate/` (use `/migration-tenant`), sem FK para `public`.
5. **Escopo**: dentro do tenant ainda existe o escopo do usuário. Liste sempre com `policy_scope`.
6. **Busca por árvore**: "tudo abaixo de X" é `Unidade.where("caminho <@ ?", x.caminho)`. Nunca faça recursão em Ruby.

## Testes
- Marque com `:tenant` para rodar dentro do tenant de teste.
- Para provar isolamento, crie o dado em um tenant e consulte a partir de outro:
```ruby
it "não vaza entre tenants", :tenant do
  create(:membro)
  com_tenant(outro_tenant) { expect(Membros::Membro.count).to eq 0 }
end
```

## Sinais de erro
- `Tenancy::SemTenantAtivo`: a consulta rodou fora do bloco. Não contorne o erro: entre no tenant.
- Teste que passa sozinho e falha em conjunto: provavelmente o schema vazou entre exemplos, porque faltou restaurar o tenant.
