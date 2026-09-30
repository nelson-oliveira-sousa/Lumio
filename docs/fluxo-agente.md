# Fluxo de trabalho do agente

**Um card, uma branch, um PR. O humano aprova o plano e faz o merge.**

## 1. Pegar o card
`/card LUM-08` lê `backlog/cards/LUM-08.md` via `scripts/backlog.rb ver`, confere se as dependências estão fechadas, cria a branch `card/lum-08-<slug>` e marca o card como "Em andamento".
Se alguma dependência estiver aberta, **pare** e avise.

## 2. Carregar contexto
- `AGENTS.md` da raiz (já carregado) e o `AGENTS.md` de cada pack que o card toca
- Os ADRs citados no card ou no AGENTS.md do pack
- `docs/licoes.md`

## 3. Planejar e esperar aprovação
Escreva o plano como **Implementation Plan** (artefato do Antigravity) e peça revisão:
- Arquivos que serão criados ou alterados, pack por pack
- Arquivo canônico que será copiado para cada tipo de arquivo novo
- Um teste para cada critério de aceite
- Riscos: tenant, escopo, fronteira de pack, migration

**Não escreva código antes do "ok" do humano.** Se o plano mudar no meio do caminho, pare e mostre o novo plano.

## 4. Executar
- Testes primeiro, quando o critério for verificável por teste
- Commits pequenos e com mensagem no imperativo: `membros: valida destino obrigatório no desligamento`
- `make test-pack PACK=<pack>` a cada passo, e `make test-changed` antes de terminar
- Os hooks (`.agents/hooks.json`) formatam, bloqueiam edições e comandos proibidos e pedem confirmação para os sensíveis. Se um hook bloquear, leia a mensagem: ela diz o caminho certo.

## 5. Revisar
- `make ci` verde
- A skill `revisar`, que roda o subagente revisor contra o diff. Corrija o que ele apontar ou justifique no PR.

## 6. Abrir o PR
Marque os critérios atendidos no arquivo do card e mude o status para "Em revisão". Depois, `gh pr create` com título `[LUM-08] <título>` e o template preenchido.
O push e a criação do PR pedem confirmação. **O agente nunca faz merge.**

## 7. Depois do merge
O humano marca o card como "Concluído" (`scripts/backlog.rb status LUM-08 "Concluído"`).
Se algo deu errado duas vezes durante o card, registre em `docs/licoes.md` (veja as regras lá).

## O que interromper e perguntar
- O critério de aceite está ambíguo
- A mudança exige nova dependência entre packs ou uma linha no `package_todo.yml`
- É preciso mudar uma decisão registrada em ADR
- É preciso uma gem ou pacote npm novo
