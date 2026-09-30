# ADR-0008: Frontend via Inertia, sem API pública

- **Status:** Aceito
- **Data:** 2026-09-29

## Contexto
O produto é web. Não há app mobile nem integrações de terceiros previstas.

## Decisão
Todas as telas são páginas Vue servidas por Inertia a partir de controllers Rails. Os únicos endpoints fora do Inertia são o webhook do gateway (`ActionController::API`) e o health check.

## Alternativas descartadas
- **SPA + API JSON**: duplica validação, autorização e serialização, e abre superfície de ataque.
- **Hotwire**: a equipe já usa Vue, e as telas de árvore e formulários ricos são mais simples em Vue.

## Consequências
- Um só lugar para autorizar (policies no controller).
- Serializers alimentam as props do Inertia e nunca expõem o model inteiro.
- Se surgir um app mobile, será preciso um ADR novo para a API.
