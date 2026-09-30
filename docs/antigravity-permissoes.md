# Permissões do Antigravity para o Lumio

No Antigravity IDE e no 2.0, as permissões ficam na interface, não em arquivo do repositório:
**Settings → Projects → Lumio** (ou **Settings → General → Permission Settings**).

Use o preset **Default** (terminal em sandbox, sem rede) e adicione as regras abaixo, uma por linha, com o botão **+ Add**. A ordem de precedência é Deny > Ask > Allow.

Os hooks em `.agents/hooks/` aplicam as mesmas regras de dentro do repositório. Estas permissões são uma segunda camada: se um hook for desativado, elas continuam valendo.

## Deny
```
read_file(.env)
read_file(config/master.key)
read_file(config/credentials)
read_file(.kamal/secrets)
command(make deploy)
command(make reset-db)
command(kamal)
command(bin/kamal)
command(gh pr merge)
command(git push --force)
command(git push -f)
command(git push origin main)
command(regex:RAILS_ENV=production.*)
command(regex:.*credentials:(edit|show).*)
command(printenv)
command(regex:curl .*)
command(regex:wget .*)
```

## Ask
```
command(git push)
command(gh pr create)
command(regex:bin/rails (db:.*|tenants:migrate))
command(make migrate)
command(regex:bundle (add|install|update).*)
command(regex:npm (install|i|add|update).*)
command(rm)
command(git reset)
command(git rebase)
```

## Allow
```
command(make)
command(git status)
command(git diff)
command(git log)
command(git show)
command(git branch)
command(git switch)
command(git checkout -b)
command(git add)
command(git commit)
command(git restore)
command(gh pr view)
command(gh pr diff)
command(gh pr checks)
command(scripts/backlog.rb)
command(scripts/testes-alterados.sh)
command(regex:bundle exec (rspec|rubocop|packwerk (check|validate)).*)
command(regex:bin/rails (routes|generate|g)( .*)?)
command(regex:npm run (lint|build|test))
```

## Antigravity CLI (`agy`)
Se usar o CLI, as mesmas regras vão em `~/.gemini/antigravity-cli/settings.json`, no formato:
```json
{ "permissions": { "deny": ["command(make deploy)"], "ask": ["command(git push)"], "allow": ["command(make)"] } }
```
