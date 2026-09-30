# ADR-0006: Gateway de pagamento

- **Status:** Proposto. A decisão sai do card LUM-36.
- **Data:** 2026-09-29

## Contexto
A assinatura é mensal. O cartão não pode passar pelo Rails, para ficar fora do escopo PCI. É a única integração externa pública.

## Decisão
_A preencher no LUM-36, depois de testar os dois sandboxes:_ gateway escolhido, taxas, forma de pagamento principal e comportamento em caso de falha e nova tentativa.

Já decidido, seja qual for o gateway:
- Tokenização no navegador ou página hospedada. O cartão nunca chega ao Rails.
- O webhook é só gatilho. O status real vem da API do gateway, e há reconciliação diária.

## Alternativas em avaliação
- **Vindi**: foco em recorrência, com tokenização no navegador.
- **Asaas**: PIX e boleto fortes, com página hospedada.

## Consequências
_A preencher._
