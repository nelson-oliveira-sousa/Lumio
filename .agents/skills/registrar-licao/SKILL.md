---
name: registrar-licao
description: Registra um erro recorrente do agente em docs/licoes.md e o transforma em regra verificável. Use quando o usuário apontar um erro que já aconteceu antes, ou quando você cometer o mesmo erro pela segunda vez no card.
---

# Registrar lição

O usuário descreve o erro.

1. Leia `docs/licoes.md`. Se o erro já estiver lá, esta é uma **repetição**: a regra atual falhou e precisa ser reforçada.
2. Escreva a linha: data de hoje, o erro em uma frase (o que aconteceu, sem culpa) e a regra no imperativo.
3. Decida como verificar a regra, na ordem de preferência:
   - teste de arquitetura em `spec/arquitetura/`
   - regra num hook de `.agents/hooks/` (`protecao.rb` para arquivos, `comandos.rb` para terminal)
   - cop customizado do RuboCop
   - regra do Packwerk
   - "só doc", apenas se nenhuma das anteriores for possível (explique por quê)
4. Proponha a verificação escolhida e **espere o ok** antes de implementar.
5. Implemente no mesmo PR e preencha a coluna "Verificação" com o caminho.
6. Se a regra for inviolável, proponha incluí-la na lista do `AGENTS.md` da raiz.

A mensagem de erro do teste ou hook precisa dizer **qual regra** quebrou e **onde ler** sobre ela.
