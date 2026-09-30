---
id: LUM-07
titulo: "Shared kernel"
tipo: Produto
epico: "Monolito modular"
fase: "Fase 1 · Fundação"
etapa: "Fase 1 · Fundação"
status: A fazer
depende_de: [LUM-05]
---

# LUM-07 · Shared kernel

## Entrega
DomainError, rescue_from no ApplicationController, base HTTP com Faraday e instrumentação.

## Critérios de aceite
- [ ] Erro de domínio vira errors no Inertia sem rescue nas actions
- [ ] Erro HTTP vira Http::Erro com status e corpo

## Contexto
<!-- Packs afetados, ADRs e docs relevantes, armadilhas conhecidas. Opcional. -->

## Observações
<!-- Notas durante a execução. -->
