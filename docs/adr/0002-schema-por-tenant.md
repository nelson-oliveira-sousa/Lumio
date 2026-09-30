# ADR-0002: Isolar cada tenant em um schema PostgreSQL

- **Status:** Aceito
- **Data:** 2026-09-29

## Contexto
Os clientes guardam dados pessoais e disciplinares de membros. Um vazamento entre clientes seria fatal para o produto. O número de tenants esperado fica na casa das centenas, não das centenas de milhares.

## Decisão
Cada tenant tem um schema `tenant_<id>`. O `search_path` é trocado por `Tenancy::Api.com_tenant`. As tabelas globais (usuários, tenants, fila, cache, cobrança, registro de chamadas externas) ficam em `public`, e as tabelas de tenant **não podem existir** em `public`.

O tenant é a **organização contratante**. Um ministério com dois Campos (Lins e Penápolis) é um tenant só, com os Campos como unidades.

## Alternativas descartadas
- **Coluna `tenant_id` em toda tabela**: um `where` esquecido já vaza dados. O isolamento depende de disciplina em cada consulta.
- **Um banco por tenant**: operação e custo proibitivos para o estágio atual.
- **Gem Apartment**: sem manutenção ativa e com muita mágica escondida. O código próprio tem poucas linhas e é testável.

## Consequências
- Consulta sem tenant ativo falha (guarda de tenant) em vez de vazar dados.
- Migrations de tenant rodam em N schemas (`tenants:migrate`), então o deploy fica mais lento com muitos tenants.
- Jobs e cache precisam carregar o tenant explicitamente.
- Relatórios entre tenants exigem uma consulta por schema.
- Revisitar acima de ~2.000 tenants (catálogo do PostgreSQL e tempo de migration).
