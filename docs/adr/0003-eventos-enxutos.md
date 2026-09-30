# ADR-0003: Eventos síncronos que só enfileiram jobs

- **Status:** Aceito
- **Data:** 2026-09-29

## Contexto
Alguns packs precisam reagir a fatos de outros (por exemplo, um desligamento que gera carta) sem criar dependência direta. A fila fica no mesmo PostgreSQL.

## Decisão
`SharedKernel::Eventos.publicar` roda dentro da transação que gerou o fato, e os handlers **apenas enfileiram jobs**. Com `enqueue_after_transaction_commit = false`, o job é gravado na mesma transação: se ela sofre rollback, nenhum job fica para trás. As assinaturas ficam num mapa central.

## Alternativas descartadas
- **Outbox + publicador**: resolve um problema (fila em outro banco) que o Lumio não tem.
- **Event sourcing / barramento externo**: complexidade sem demanda.
- **Callbacks de model cruzando packs**: acoplamento invisível e ordem de execução frágil.

## Consequências
- Consistência transacional sem infraestrutura extra.
- Publicar fora de transação levanta erro. Handler com lógica é bloqueado por revisão e por teste.
- Se a fila sair do PostgreSQL, este ADR precisa ser revisto (virar outbox).
