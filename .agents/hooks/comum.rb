# frozen_string_literal: true

# Utilitários compartilhados pelos hooks do Antigravity.
# Contrato: JSON no stdin (camelCase) e JSON no stdout. O Antigravity falha fechado se a saída for inválida.

require "json"
require "tmpdir"

module Hook
  module_function

  def entrada
    @entrada ||= JSON.parse($stdin.read.to_s.then { _1.empty? ? "{}" : _1 })
  end

  def ferramenta = entrada.dig("toolCall", "name").to_s
  def args = entrada.dig("toolCall", "args") || {}

  def raiz(caminho = nil)
    ws = Array(entrada["workspacePaths"])
    ws.find { caminho.to_s.start_with?(_1) } || ws.first || Dir.pwd
  end

  def relativo(caminho) = caminho.to_s.sub(%r{\A#{Regexp.escape(raiz(caminho))}/?}, "")

  def responder(hash)
    $stdout.write(JSON.generate(hash))
    exit 0
  end

  def negar(motivo) = responder(decision: "deny", reason: "BLOQUEADO pelo harness do Lumio: #{motivo}")
  def perguntar(motivo) = responder(decision: "force_ask", reason: motivo)
  def permitir = responder(decision: "allow")
  def seguir_padrao = responder(decision: "ask")

  def fila_lint = File.join(Dir.tmpdir, "lumio-lint-#{entrada['conversationId'] || 'sem-conversa'}.txt")

  # Qualquer erro interno vira "ask": nunca libera às cegas, nunca trava o agente.
  def proteger
    yield
  rescue SystemExit
    raise
  rescue StandardError => e
    responder(decision: "ask", reason: "Hook do Lumio falhou (#{e.class}: #{e.message}). Confirme manualmente.")
  end
end
