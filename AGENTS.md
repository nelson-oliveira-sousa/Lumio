# Lumio — contexto para agentes

> Regras de workspace do Antigravity. Mantenha este arquivo abaixo de 12.000 caracteres.

ERP multi-tenant para gestão de igrejas e ministérios. Monolito modular em Rails.
Este arquivo é o ponto de entrada. Ele **aponta** para os docs; não repete o conteúdo deles.

## Stack
- Rails 8.1, Ruby 3.x, PostgreSQL 16 (único banco: dados, Solid Queue e Solid Cache)
- Frontend: Vue 3 + Inertia.js + Vite + Tailwind CSS v4. **Não existe API pública**: toda tela é Inertia.
- Módulos: Packwerk (`packs/`). Autorização: Pundit. Testes: RSpec. Deploy: Kamal.

## Comandos (sempre via Makefile)
| Comando | Uso |
|---|---|
| `make` | lista todos os comandos |
| `make up` / `make down` | sobe/derruba PostgreSQL e pgweb |
| `make setup` | instala dependências e prepara o banco |
| `make dev` / `make jobs` | servidor web / worker do Solid Queue |
| `make test` | suíte completa |
| `make test-pack PACK=membros` | testes de um pack (use durante o trabalho) |
| `make test-changed` | testes do que mudou em relação à main |
| `make lint` | RuboCop + linter do frontend |
| `make ci` | tudo que o CI roda; rode antes de abrir PR |
| `make seed` | dados de desenvolvimento com cenários reais |
| `scripts/backlog.rb liberados` | cards que podem começar (backlog em `backlog/cards/`) |

Nunca rode `rails`, `rspec` ou `bundle exec` soltos quando existir um alvo no Makefile.
Deploy, `reset-db` e qualquer coisa em produção são **proibidos** para o agente (e bloqueados por `.agents/hooks/comandos.rb`).

## Mapa dos packs
Cada pack tem `README.md` (para humanos) e `AGENTS.md` (para você; o Antigravity carrega o do pack ao trabalhar nele). **Confira as armadilhas do pack antes de mexer.**

| Pack | Responsabilidade | Depende de |
|---|---|---|
| `shared_kernel` | DomainError, eventos, base HTTP, instrumentação | — |
| `tenancy` | schema por tenant, migrations de tenant, provisionamento | shared_kernel |
| `organizacao` | organização, tipos de unidade, árvore de unidades, termos | shared_kernel, tenancy |
| `identidade` | autenticação, permissões, perfis, vínculos, escopo, convites, 2FA | shared_kernel, tenancy, organizacao |
| `membros` | membros, tipos de desligamento, desligamento, disciplina | shared_kernel, organizacao, identidade, auditoria |
| `cargos` | tipos de cargo e ocupações com vigência | shared_kernel, organizacao, identidade, membros |
| `documentos` | cartas: modelo Liquid, signatários, PDF | shared_kernel, organizacao, cargos, membros |
| `cobranca` | gateway, checkout, webhook, reconciliação | shared_kernel, tenancy, organizacao |
| `auditoria` | quem viu e alterou dados sensíveis | shared_kernel, tenancy |

Onboarding e painel administrativo ficam no app raiz (`app/`), que pode depender de todos os packs.
Detalhes e diagrama: `docs/arquitetura.md`.

## Regras invioláveis
Cada regra tem um teste ou hook que a verifica. Se um teste de arquitetura falhar, ele diz qual regra quebrou.

1. **Tenant sempre explícito.** Toda consulta a dados de tenant roda dentro de `Tenancy::Api.com_tenant`. Todo job recebe o tenant. Toda chave de cache tem namespace de tenant.
2. **Fronteiras de pack.** Só use o que está em `app/public` de outro pack. Nunca adicione linhas ao `package_todo.yml`.
3. **Autorização em toda action.** `authorize` ou `policy_scope` em toda action; dados fora do escopo do usuário nunca aparecem.
4. **Nada de hierarquia fixa no código.** Não escreva "Campo", "Igreja", "Pastor" em regra ou tela. Use flags de tipo e `Organizacao::Termos`.
5. **Regras perguntam pela flag, nunca pelo nome** (`tipo.gera_carta?`, nunca `tipo.nome == "Transferência"`).
6. **Eventos só enfileiram jobs**, são publicados dentro de transação e não carregam lógica.
7. **Número de cartão nunca chega ao Rails.**
8. **Migration commitada não se edita.** Crie uma nova.
9. **Segredos:** não leia nem edite `.env`, `config/master.key`, `config/credentials*` ou `.kamal/secrets*`.

## Definição de pronto
- Critérios de aceite do card atendidos, cada um com teste
- `make ci` verde
- Nenhuma violação nova de Packwerk
- Docs atualizados se mudou API pública, evento, permissão ou padrão (AGENTS.md do pack, `docs/padroes.md`)
- PR aberto com o template preenchido; merge é sempre humano

## Como trabalhar
- Um card, uma branch, um PR. Plano aprovado antes do código: `docs/fluxo-agente.md`
- Comece pela skill `/card <ID>`. Skills do projeto ficam em `.agents/skills/`
- Antes de escrever um tipo de arquivo novo, copie o exemplo canônico em `docs/padroes.md`
- Errou algo que já está em `docs/licoes.md`? Leia de novo antes de continuar.

## Skills do projeto (`.agents/skills/`)
| Skill | Quando |
|---|---|
| `/card LUM-08` | começar qualquer card |
| `/revisar` | antes de todo PR |
| `/migration-tenant <descrição>` | tabela ou coluna de tenant |
| `/novo-pack <nome>` | só com aprovação do humano |
| `/registrar-licao <erro>` | erro repetido |
| `codigo-tenant` | carregada sozinha ao mexer em dado de tenant |

Subagente: `revisor` (`.agents/agents/revisor.md`), somente leitura, usado pela skill `revisar`.

## Onde ler mais
- `docs/arquitetura.md`: visão geral, packs, tenancy, eventos
- `docs/adr/`: por que cada decisão foi tomada
- `docs/glossario.md`: nomes do domínio e como aparecem no código
- `docs/padroes.md`: padrões com arquivo de referência
- `docs/fluxo-agente.md`: passo a passo do trabalho em um card
- `docs/licoes.md`: erros recorrentes e a regra que surgiu de cada um
