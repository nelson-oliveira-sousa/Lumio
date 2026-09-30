---
name: card
description: Executa um card do backlog do Lumio de ponta a ponta (card → branch → plano → código → PR). Use quando o usuário pedir para executar, começar ou fazer um card, por exemplo "/card LUM-08".
---

# Executar um card

O usuário informa o ID do card (ex.: `LUM-08`). Os cards ficam em `backlog/cards/<ID>.md`. Siga `docs/fluxo-agente.md` à risca.

1. Rode `scripts/backlog.rb ver <ID>` e leia Entrega, Critérios de aceite, Contexto e a situação das dependências.
2. Se a situação for **Bloqueado**, **pare** e liste as dependências abertas. Não comece.
3. Com a `main` atualizada, crie a branch `card/<id-em-minúsculas>-<slug-do-título>` (ex.: `card/lum-08-troca-de-schema`).
4. Rode `scripts/backlog.rb status <ID> "Em andamento"` e faça commit dessa mudança como primeiro commit da branch.
5. Leia o `AGENTS.md` de cada pack afetado, os ADRs citados e `docs/licoes.md`. Se o card toca dados de tenant, use a skill `codigo-tenant`.
6. Escreva o plano como **Implementation Plan** (artefato) e peça revisão:
   - arquivos por pack (criar/alterar)
   - arquivo canônico de `docs/padroes.md` que será copiado para cada arquivo novo
   - um teste por critério de aceite
   - riscos (tenant, escopo, fronteira de pack, migration)
7. **Espere a aprovação explícita do plano.** Não escreva código antes disso.
8. Implemente em commits pequenos, rodando `make test-pack PACK=<pack>` a cada passo.
9. No fim: `make test-changed`, `make ci` e depois a skill `revisar`.
10. Marque os critérios atendidos (`- [x]`) no arquivo do card, rode `scripts/backlog.rb status <ID> "Em revisão"` e faça commit.
11. Abra o PR com `gh pr create`, título `[<ID>] <título do card>` e o corpo de `.github/pull_request_template.md` preenchido.
12. Entregue um **Walkthrough** com o link do PR e como verificar. Não faça merge nem marque "Concluído": isso é do humano, depois do merge.
