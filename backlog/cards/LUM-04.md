---
id: LUM-04
titulo: "Pipeline de CI"
tipo: Produto
epico: "Fundação"
fase: "Fase 1 · Fundação"
etapa: "Fase 1 · Fundação"
status: A fazer
depende_de: [LUM-03, LUM-05]
---

# LUM-04 · Pipeline de CI

## Entrega
CI rodando RuboCop, Brakeman, bundler-audit, npm audit, Packwerk, gitleaks e RSpec.

## Critérios de aceite
- [ ] PR com violação de Packwerk falha
- [ ] PR com segredo commitado falha
- [ ] PR com teste quebrado falha

## Contexto
<!-- Packs afetados, ADRs e docs relevantes, armadilhas conhecidas. Opcional. -->

## Observações
<!-- Notas durante a execução. -->
