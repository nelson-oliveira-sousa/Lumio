---
id: LUM-12
titulo: "Tenant em jobs e cache"
tipo: Produto
epico: "Multi-tenancy"
fase: "Fase 1 · Fundação"
etapa: "Fase 1 · Fundação"
status: A fazer
depende_de: [LUM-08]
---

# LUM-12 · Tenant em jobs e cache

## Entrega
Todo job recebe e entra no tenant; namespace de cache por tenant.

## Critérios de aceite
- [ ] Teste prova que a mesma chave de cache não vaza entre tenants
- [ ] Job sem tenant falha

## Contexto
<!-- Packs afetados, ADRs e docs relevantes, armadilhas conhecidas. Opcional. -->

## Observações
<!-- Notas durante a execução. -->
