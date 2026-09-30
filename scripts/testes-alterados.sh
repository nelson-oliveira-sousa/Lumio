#!/usr/bin/env bash
# HAR-10 · Roda só os specs afetados pelo que mudou em relação à main.
# Regras: spec alterado roda; arquivo de pack alterado roda a pasta spec/ daquele pack;
# arquivo fora de packs roda o spec espelhado (app/x/y.rb -> spec/x/y_spec.rb) se existir.
set -euo pipefail

BASE="${BASE:-origin/main}"
mapfile -t ARQUIVOS < <( { git diff --name-only "$BASE"...HEAD; git diff --name-only; git ls-files --others --exclude-standard; } | sort -u )

declare -A ALVOS=()
for f in "${ARQUIVOS[@]}"; do
  [[ -e "$f" ]] || continue
  if [[ "$f" == *_spec.rb ]]; then
    ALVOS["$f"]=1
  elif [[ "$f" =~ ^packs/([^/]+)/ ]]; then
    d="packs/${BASH_REMATCH[1]}/spec"; [[ -d "$d" ]] && ALVOS["$d"]=1
  elif [[ "$f" =~ ^app/(.+)\.rb$ ]]; then
    s="spec/${BASH_REMATCH[1]}_spec.rb"; [[ -f "$s" ]] && ALVOS["$s"]=1
  elif [[ "$f" =~ ^db/(tenant_)?migrate/ ]]; then
    ALVOS["packs/tenancy/spec"]=1
  fi
done

if [[ ${#ALVOS[@]} -eq 0 ]]; then
  echo "Nenhum spec afetado."
  exit 0
fi

echo "Rodando: ${!ALVOS[*]}"
exec bundle exec rspec "${!ALVOS[@]}"
