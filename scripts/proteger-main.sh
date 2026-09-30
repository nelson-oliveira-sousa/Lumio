#!/usr/bin/env bash
# HAR-09 · Protege a branch main: exige PR e CI verde, inclusive para administradores.
# Uso: scripts/proteger-main.sh [owner/repo] [nome-do-check]
# Obs.: em repositório PRIVADO de conta pessoal, proteção de branch exige GitHub Pro.
set -euo pipefail

REPO="${1:-nelson-oliveira-sousa/Lumio}"
CHECK="${2:-ci}"   # nome do job do workflow de CI (LUM-04)

gh api -X PUT "repos/${REPO}/branches/main/protection" \
  -H "Accept: application/vnd.github+json" \
  --input - <<JSON
{
  "required_status_checks": { "strict": true, "contexts": ["${CHECK}"] },
  "enforce_admins": true,
  "required_pull_request_reviews": { "required_approving_review_count": 0 },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": true
}
JSON

echo "main protegida em ${REPO}: PR obrigatório, check '${CHECK}' obrigatório, sem push direto nem force push."
