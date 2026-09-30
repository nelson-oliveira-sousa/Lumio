# Backlog

Um arquivo por card em `cards/`. O frontmatter guarda status e dependências, e o corpo guarda Entrega, Critérios de aceite, Contexto e Observações.

**Este diretório é a fonte da verdade para o agente.** A planilha `lumio-tarefas.xlsx` é a sua visão de gestão: sincronize com `scripts/backlog.rb csv`.

## Comandos
```bash
scripts/backlog.rb liberados                 # o que dá para começar agora
scripts/backlog.rb ver LUM-08                # card + dependências
scripts/backlog.rb status LUM-08 "Concluído" # A fazer | Em andamento | Em revisão | Concluído | Cancelado
scripts/backlog.rb resumo                    # por fase
scripts/backlog.rb csv                       # ID;Status;Situação para colar na planilha
scripts/backlog.rb validar                   # dependências inexistentes e ciclos
```

## Ciclo de vida
| Status | Quem muda | Quando |
|---|---|---|
| A fazer | — | card criado |
| Em andamento | agente (`/card`) | início do card, na branch |
| Em revisão | agente | antes de abrir o PR |
| Concluído | você | depois do merge (commit direto na branch seguinte, ou num PR de backlog) |
| Cancelado | você | card que não se aplica (ex.: LUM-06 e LUM-18 se o projeto começar do zero) |

Como o status viaja na branch, ele só vale na `main` depois do merge.

## Card novo
Copie `_modelo.md` para `cards/<ID>.md`, preencha e rode `scripts/backlog.rb validar`.
