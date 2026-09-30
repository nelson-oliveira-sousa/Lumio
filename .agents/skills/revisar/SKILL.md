---
name: revisar
description: Revisa o diff da branch atual contra os padrões e as regras invioláveis do Lumio. Use antes de abrir qualquer PR ou quando o usuário pedir revisão.
---

# Revisar a branch

1. Invoque o subagente `revisor` (definido em `.agents/agents/revisor.md`) pedindo a revisão de `git diff main...HEAD` e do card da branch.
   - Se subagentes customizados não estiverem disponíveis nesta superfície, faça você mesmo a revisão seguindo **exatamente** as instruções e o formato de saída de `.agents/agents/revisor.md`, sem editar arquivos durante a revisão.
2. Com o relatório em mãos:
   - Corrija cada item **Bloqueante**.
   - Para cada item **Atenção**, corrija ou escreva no PR por que não se aplica.
3. Rode `make ci` de novo se algo mudou.
