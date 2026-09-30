---
id: LUM-13
titulo: "Solid Queue e Solid Cache no banco principal"
tipo: Produto
epico: "Dados e fila"
fase: "Fase 1 · Fundação"
etapa: "Fase 1 · Fundação"
status: A fazer
depende_de: [LUM-08]
---

# LUM-13 · Solid Queue e Solid Cache no banco principal

## Entrega
Schemas convertidos em migrations; enqueue_after_transaction_commit = false.

## Critérios de aceite
- [ ] Job enfileirado dentro de transação desaparece no rollback

## Contexto
<!-- Packs afetados, ADRs e docs relevantes, armadilhas conhecidas. Opcional. -->

## Observações
<!-- Notas durante a execução. -->
