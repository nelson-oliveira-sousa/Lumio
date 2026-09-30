# ADR-0007: Cargos só por ocupação explícita, sem derivação

- **Status:** Aceito
- **Data:** 2026-09-29

## Contexto
As cartas precisam de signatários (quem preside, quem secretaria). Seria tentador deduzir isso ("o pastor da sede é o presidente"), mas as estruturas variam e uma pessoa pode acumular cargos em unidades diferentes.

## Decisão
Um cargo existe apenas em `ocupacoes_cargo`, com vigência. Para achar signatários, o sistema sobe a árvore procurando ocupações de tipos com `assina_cartas`. Os signatários ficam **congelados** na carta quando ela é emitida.

## Alternativas descartadas
- **Derivar cargo de perfil ou da posição na árvore**: quebra na primeira estrutura diferente.
- **Recalcular signatários ao exibir**: uma carta antiga mudaria quando o cargo mudasse.

## Consequências
- A organização precisa cadastrar as ocupações (o onboarding ajuda).
- O histórico de cargos é preservado.
- Um acúmulo de cargos gera aviso na nomeação e na substituição.
