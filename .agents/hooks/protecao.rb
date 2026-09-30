#!/usr/bin/env ruby
# frozen_string_literal: true

# HAR-08 · PreToolUse em ferramentas de arquivo.
# Bloqueia: ler/editar segredos, editar migration já commitada, aumentar package_todo.yml.

require_relative "comum"

SEGREDOS = [
  %r{\A\.env\z}, %r{\A\.env\.(?!example\z)}, %r{\Aconfig/master\.key\z},
  %r{\Aconfig/credentials(/|\.yml\.enc\z)}, %r{\A\.kamal/secrets}, /\.(pem|key)\z/
].freeze

Hook.proteger do
  a = Hook.args
  caminho = (a["TargetFile"] || a["AbsolutePath"]).to_s
  Hook.seguir_padrao if caminho.empty?

  rel = Hook.relativo(caminho)
  dentro_do_workspace = rel != caminho || !caminho.start_with?("/")

  if SEGREDOS.any? { rel.match?(_1) }
    Hook.negar("#{rel} é arquivo de segredo. O agente não lê nem edita segredos. " \
               "Se o card precisa de uma chave nova, adicione o NOME dela ao .env.example e peça ao humano para preencher.")
  end

  Hook.permitir if Hook.ferramenta == "view_file" && dentro_do_workspace
  Hook.seguir_padrao if Hook.ferramenta == "view_file"

  if rel.match?(%r{(\A|/)db/[^/]*migrate[^/]*/[^/]+\.rb\z}) &&
     system("git", "-C", Hook.raiz(caminho), "cat-file", "-e", "HEAD:#{rel}", err: File::NULL, out: File::NULL)
    Hook.negar("#{rel} já foi commitada. Migrations commitadas não se editam: crie uma migration nova " \
               "(skill migration-tenant para tabelas de tenant). Ver docs/padroes.md, seção Migration de tenant.")
  end

  if File.basename(rel) == "package_todo.yml"
    tam = ->(s) { s.to_s.length }
    cresceu =
      case Hook.ferramenta
      when "write_to_file"
        tam.(a["CodeContent"]) > (File.exist?(caminho) ? File.size(caminho) : 0)
      when "replace_file_content"
        tam.(a["ReplacementContent"]) > tam.(a["TargetContent"])
      when "multi_replace_file_content"
        Array(a["ReplacementChunks"]).any? { tam.(_1["ReplacementContent"]) > tam.(_1["TargetContent"]) }
      else false
      end
    if cresceu
      Hook.negar("#{rel} só pode diminuir. Não congele violações novas de Packwerk: use a API pública (app/public) " \
                 "do outro pack ou, se a dependência for legítima, pare e pergunte ao humano. Ver ADR-0001.")
    end
  end

  dentro_do_workspace ? Hook.permitir : Hook.seguir_padrao
end
