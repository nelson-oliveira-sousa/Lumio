# ADR-0001: Organizar o monolito em packs do Packwerk, não em engines

- **Status:** Aceito
- **Data:** 2026-09-29

## Contexto
O Lumio é um monolito modular desenvolvido por uma pessoa com agentes de IA. O código ficava em `app/domains/`, onde nada impedia um domínio de usar os internos de outro. Agentes cruzam fronteiras com facilidade quando elas não são verificadas.

## Decisão
Usar Packwerk com packs em `packs/<nome>/`, cada um com `app/public` como API e dependências declaradas no `package.yml`. O CI falha quando surge uma violação nova.

## Alternativas descartadas
- **Rails engines**: isolamento mais forte, mas com rotas, migrations, assets e configuração duplicados em cada engine. É um custo alto para uma pessoa só e não traz ganho, porque tudo é deployado junto.
- **Só convenção em `app/domains/`**: sem verificação, a fronteira se degrada a cada PR de agente.
- **Microsserviços**: complexidade operacional incompatível com o tamanho do time.

## Consequências
- Fronteiras verificadas por máquina. O agente recebe um erro claro quando cruza uma.
- É preciso manter `package.yml` e fachadas `Api`.
- O `package_todo.yml` só pode diminuir (há hook e CI para isso).
- Revisitar se algum pack precisar escalar ou ser deployado separadamente.
