#!/usr/bin/env ruby
# frozen_string_literal: true

# HAR-06 · PreToolUse em run_command.
# Versiona no repositório o que é proibido, o que pede confirmação e o que roda direto.
# As permissões da interface (docs/antigravity-permissoes.md) continuam valendo por cima.

require_relative "comum"

PROIBIDOS = {
  /\bmake\s+(deploy|reset-db)\b/ => "deploy e reset-db são só do humano",
  %r{(\A|[\s;&|])(bin/)?kamal\b} => "deploy é só do humano",
  /\bgh\s+pr\s+merge\b/ => "merge é sempre humano",
  /\bgit\s+push\b.*(\s-f\b|\s--force)/ => "force push é proibido",
  /\bgit\s+push\s+\S+\s+(HEAD:)?main\b/ => "push direto na main é proibido; abra PR",
  /RAILS_ENV=production/ => "nada roda em produção pelo agente",
  /\bcredentials:(edit|show)\b/ => "o agente não lê credentials",
  %r{(\A|[\s/'"=<])\.env(\.(?!example\b)[\w.-]+)?(\z|[\s'";|&)])} => "o agente não lê .env",
  /master\.key|\.kamal\/secrets|config\/credentials/ => "o agente não lê segredos",
  /(\A|[\s;&|])(printenv|env)(\s*\z|\s*[;&|])/ => "listar variáveis de ambiente expõe segredos",
  /(\A|[\s;&|])(curl|wget)\b/ => "sem downloads arbitrários; peça ao humano"
}.freeze

CONFIRMAR = [
  /\bgit\s+push\b/, /\bgh\s+pr\s+create\b/, /\bdb:(migrate|drop|reset|rollback)\b/, /\btenants:migrate\b/,
  /\bmake\s+migrate\b/, /\bbundle\s+(add|install|update)\b/, /\bnpm\s+(install|i|add|update)\b/,
  /(\A|[\s;&|])rm\s/, /\bgit\s+(reset|rebase)\b/
].freeze

LIBERADOS = [
  /\Amake(\s|\z)/, %r{\A(ruby\s+)?(\./)?scripts/(backlog\.rb|testes-alterados\.sh)\b},
  /\Agit\s+(status|diff|log|show|branch|switch|checkout\s+-b|add|commit|restore|fetch|pull)\b/,
  /\Agh\s+pr\s+(view|diff|checks|list)\b/,
  /\Abundle\s+exec\s+(rspec|rubocop|packwerk\s+(check|validate))\b/,
  %r{\Abin/rails\s+(routes|generate|g)\b}, /\Anpm\s+run\s+(lint|build|test)\b/,
  /\A(ls|cat|head|tail|wc|grep|rg|find|pwd|echo|which)\b/
].freeze

Hook.proteger do
  linha = Hook.args["CommandLine"].to_s.strip
  Hook.seguir_padrao if linha.empty?

  PROIBIDOS.each { |re, motivo| Hook.negar("#{motivo}. Comando: #{linha}") if linha.match?(re) }
  Hook.perguntar("O harness do Lumio exige confirmação para: #{linha}") if CONFIRMAR.any? { linha.match?(_1) }

  segmentos = linha.split(/\s*(?:&&|\|\||;|\|)\s*/).map(&:strip).reject(&:empty?)
  Hook.permitir if segmentos.all? { |s| LIBERADOS.any? { s.match?(_1) } }

  Hook.seguir_padrao
end
