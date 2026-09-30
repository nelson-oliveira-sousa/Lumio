---
name: novo-pack
description: Cria o esqueleto de um pack novo do Lumio (package.yml, README.md, AGENTS.md). Use apenas quando o usuário pedir explicitamente um pack novo.
---

# Pack novo

Antes de tudo, confirme com o usuário: nome, responsabilidade e de quais packs ele depende. Um pack novo muda a arquitetura, então pare se houver qualquer dúvida.

Estrutura:
```
packs/<nome>/
  package.yml            # enforce_dependencies: true, enforce_privacy: true, dependencies: [...]
  README.md              # a partir de modelos/README.md (nesta skill)
  AGENTS.md              # a partir de modelos/AGENTS.md (nesta skill); o Antigravity carrega sozinho ao trabalhar no pack
  app/public/<nome>/api.rb
  app/models/<nome>/.keep
  app/services/<nome>/.keep
  config/locales/pt-BR.yml
  spec/<nome>/.keep
```

Preencha os modelos de verdade: nenhuma seção pode ficar com texto de exemplo. Se não souber o que colocar em "Armadilhas", pergunte.

Depois:
1. `bundle exec packwerk validate` sem ciclos
2. Adicione o pack à tabela do `AGENTS.md` da raiz e ao diagrama de `docs/arquitetura.md`
3. Se a decisão não for óbvia, proponha um ADR usando `docs/adr/0000-modelo.md`
