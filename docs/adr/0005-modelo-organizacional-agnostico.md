# ADR-0005: Hierarquia e nomenclatura definidas por organização

- **Status:** Aceito
- **Data:** 2026-09-29

## Contexto
Cada denominação tem uma estrutura própria (Campo, Setor, Congregação, Igreja local...) e a mesma pessoa pode presidir vários Campos. Uma estrutura fixa no código exigiria um fork para cada cliente.

## Decisão
A hierarquia é um dado: `tipos_unidade` (pais permitidos e flags de comportamento) e `unidades` em árvore `ltree`. As regras de negócio consultam **flags**, nunca nomes. Os nomes das telas vêm de `Organizacao::Termos`. Existem modelos prontos ("Campo com setores", "Igreja local") que são aplicados no onboarding.

## Alternativas descartadas
- **Tabelas fixas (igrejas, congregações)**: cada nova estrutura exigiria migration e mudança de código.
- **Nested set / closure table**: o `ltree` é nativo, indexável e mais simples de mover.

## Consequências
- Um cliente novo com uma estrutura nova não exige código.
- Regras ficam mais abstratas e testes precisam de cenários variados (os seeds cobrem isso).
- A interface se adapta: uma igreja com uma única unidade não vê nenhum conceito de hierarquia.
