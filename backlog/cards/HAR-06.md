---
id: HAR-06
titulo: "Permissões do agente"
tipo: Harness
epico: "H2 · Guardrails"
fase: "Harness"
etapa: "Harness · etapa 2"
status: A fazer
depende_de: [LUM-02]
---

# HAR-06 · Permissões do agente

## Entrega
Permissões do Antigravity (`docs/antigravity-permissoes.md`) e hook de comandos (`.agents/hooks/comandos.rb`) com comandos liberados, que pedem confirmação e proibidos.

## Critérios de aceite
- [ ] Agente não lê .env, chaves nem .kamal/secrets
- [ ] Agente não faz deploy
- [ ] Migration e push pedem confirmação

## Contexto
<!-- Packs afetados, ADRs e docs relevantes, armadilhas conhecidas. Opcional. -->

## Observações
<!-- Notas durante a execução. -->
