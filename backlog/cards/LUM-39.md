---
id: LUM-39
titulo: "Webhook e reconciliação"
tipo: Produto
epico: "Cobrança"
fase: "Fase 3 · Monetização"
etapa: "Fase 3 · Monetização"
status: A fazer
depende_de: [LUM-37]
---

# LUM-39 · Webhook e reconciliação

## Entrega
Endpoint em ActionController::API com validação de origem, deduplicação e job; reconciliação diária.

## Critérios de aceite
- [ ] Evento repetido não processa duas vezes
- [ ] Status vem sempre da API

## Contexto
<!-- Packs afetados, ADRs e docs relevantes, armadilhas conhecidas. Opcional. -->

## Observações
<!-- Notas durante a execução. -->
