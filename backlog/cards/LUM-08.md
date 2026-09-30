---
id: LUM-08
titulo: "Troca de schema por tenant"
tipo: Produto
epico: "Multi-tenancy"
fase: "Fase 1 · Fundação"
etapa: "Fase 1 · Fundação"
status: A fazer
depende_de: [LUM-05]
---

# LUM-08 · Troca de schema por tenant

## Entrega
Tenancy::Api.com_campo, search_path = tenant, public, validação numérica do id.

## Critérios de aceite
- [ ] Consultas dentro do bloco leem o schema certo
- [ ] Schema restaurado ao sair, inclusive com exceção

## Contexto
<!-- Packs afetados, ADRs e docs relevantes, armadilhas conhecidas. Opcional. -->

## Observações
<!-- Notas durante a execução. -->
