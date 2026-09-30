#!/usr/bin/env ruby
# frozen_string_literal: true

# HAR-07 · PostToolUse em ferramentas de escrita.
# Formata o arquivo. O que o formatador não corrige vai para uma fila que o hook
# lint-pendente.rb injeta na próxima chamada ao modelo (PostToolUse não fala com o agente).

require_relative "comum"
require "open3"

Hook.proteger do
  caminho = Hook.args["TargetFile"].to_s
  Hook.responder({}) if caminho.empty? || !File.exist?(caminho) || !Hook.entrada["error"].to_s.empty?

  raiz = Hook.raiz(caminho)
  saida, ok =
    case caminho
    when /\.(rb|rake|ru|jbuilder)\z/, %r{/(Gemfile|Rakefile)\z}
      Hook.responder({}) unless File.exist?(File.join(raiz, "Gemfile"))
      o, s = Open3.capture2e("bundle", "exec", "rubocop", "-a", "--force-exclusion", "--format", "simple", caminho, chdir: raiz)
      [o, s.success?]
    when /\.(vue|js|ts|mjs)\z/
      eslint = File.join(raiz, "node_modules/.bin/eslint")
      Hook.responder({}) unless File.executable?(eslint)
      o, s = Open3.capture2e(eslint, "--fix", caminho, chdir: raiz)
      [o, s.success?]
    else
      Hook.responder({})
    end

  unless ok
    File.open(Hook.fila_lint, "a") do |f|
      f.puts "## #{Hook.relativo(caminho)}"
      f.puts saida.lines.last(30).join
    end
  end
  Hook.responder({})
end
