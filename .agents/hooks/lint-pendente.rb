#!/usr/bin/env ruby
# frozen_string_literal: true

# HAR-07 · PreInvocation. Entrega ao agente os erros de lint que o formatacao.rb enfileirou.

require_relative "comum"

Hook.proteger do
  fila = Hook.fila_lint
  Hook.responder({}) unless File.exist?(fila)

  erros = File.read(fila)
  File.delete(fila)
  Hook.responder({}) if erros.strip.empty?

  Hook.responder(injectSteps: [{
    ephemeralMessage: "O lint encontrou problemas que não corrige sozinho nos arquivos que você editou. " \
                      "Corrija antes de seguir:\n#{erros}"
  }])
end
