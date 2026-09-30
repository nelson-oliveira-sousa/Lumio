#!/usr/bin/env ruby
# frozen_string_literal: true

# Backlog do Lumio em backlog/cards/*.md (um arquivo por card, com frontmatter YAML).
#
#   scripts/backlog.rb liberados              # cards "A fazer" com todas as dependências fechadas
#   scripts/backlog.rb listar [texto]         # todos, ou filtrados por id/título/épico/fase/status
#   scripts/backlog.rb ver LUM-08             # mostra o card e a situação das dependências
#   scripts/backlog.rb status LUM-08 "Em andamento"
#   scripts/backlog.rb resumo                 # contagem por fase e status
#   scripts/backlog.rb csv > status.csv       # ID;Status;Situação na ordem da planilha (para colar)
#   scripts/backlog.rb validar                # ids, dependências inexistentes e ciclos

require "yaml"

DIR = File.expand_path("../backlog/cards", __dir__)
STATUS = ["A fazer", "Em andamento", "Em revisão", "Concluído", "Cancelado"].freeze
FECHADOS = ["Concluído", "Cancelado"].freeze

Card = Struct.new(:id, :titulo, :tipo, :epico, :fase, :etapa, :status, :deps, :arquivo, :texto)

def carregar
  Dir[File.join(DIR, "*.md")].map do |arq|
    texto = File.read(arq, encoding: "UTF-8")
    fm = texto[/\A---\n(.*?)\n---\n/m, 1] or abort("Sem frontmatter: #{arq}")
    d = YAML.safe_load(fm)
    Card.new(d["id"], d["titulo"], d["tipo"], d["epico"], d["fase"], d["etapa"], d["status"],
             Array(d["depende_de"]), arq, texto)
  end.sort_by { |c| [c.id.start_with?("LUM") ? 0 : 1, c.id] }
end

def indice(cards) = cards.to_h { [_1.id, _1] }

def abertas(card, idx) = card.deps.reject { FECHADOS.include?(idx[_1]&.status) }

def situacao(card, idx)
  return "—" if FECHADOS.include?(card.status)
  abertas(card, idx).empty? ? "Liberado" : "Bloqueado"
end

def linha(c, idx) = format("%-7s %-13s %-10s %s", c.id, c.status, situacao(c, idx), c.titulo)

cards = carregar
idx = indice(cards)
cmd, *args = ARGV.map { _1.dup.force_encoding("UTF-8").unicode_normalize(:nfc) }

case cmd
when "liberados"
  lib = cards.select { _1.status == "A fazer" && situacao(_1, idx) == "Liberado" }
  puts lib.empty? ? "Nenhum card liberado." : lib.map { linha(_1, idx) }
when "listar"
  termo = args.join(" ").downcase
  sel = cards.select { termo.empty? || [_1.id, _1.titulo, _1.epico, _1.fase, _1.status].join(" ").downcase.include?(termo) }
  puts sel.map { linha(_1, idx) }
when "ver"
  c = idx[args[0].to_s.upcase] or abort("Card não encontrado: #{args[0]}")
  puts c.texto
  puts "\nSituação: #{situacao(c, idx)}"
  c.deps.each { |d| puts "  #{d}: #{idx[d]&.status || 'INEXISTENTE'}" }
when "status"
  id, novo = args[0].to_s.upcase, args[1..].join(" ")
  c = idx[id] or abort("Card não encontrado: #{id}")
  abort("Status inválido. Use: #{STATUS.join(' | ')}") unless STATUS.include?(novo)
  if novo == "Em andamento" && !(ab = abertas(c, idx)).empty?
    abort("#{id} está bloqueado por: #{ab.join(', ')}")
  end
  File.write(c.arquivo, c.texto.sub(/^status: .*$/, "status: #{novo}"))
  puts "#{id}: #{c.status} → #{novo}"
when "resumo"
  cards.group_by(&:fase).each do |fase, cs|
    cont = STATUS.map { |s| "#{s}: #{cs.count { _1.status == s }}" }.join(" | ")
    puts format("%-22s %2d  %s", fase, cs.size, cont)
  end
  validos = cards.reject { _1.status == "Cancelado" }
  pct = validos.empty? ? 0 : (100.0 * validos.count { _1.status == "Concluído" } / validos.size).round
  puts "Total: #{cards.size} cards, #{pct}% concluído (sem contar cancelados)"
when "csv"
  puts "ID;Status;Situação"
  cards.each { puts [_1.id, _1.status, situacao(_1, idx)].join(";") }
when "validar"
  erros = []
  cards.group_by(&:id).each { |id, cs| erros << "id duplicado: #{id}" if cs.size > 1 }
  cards.each do |c|
    erros << "#{c.id}: status inválido '#{c.status}'" unless STATUS.include?(c.status)
    c.deps.each { |d| erros << "#{c.id}: depende de #{d}, que não existe" unless idx[d] }
    erros << "#{c.id}: arquivo com nome diferente do id" unless File.basename(c.arquivo, ".md") == c.id
  end
  visitando, feito = {}, {}
  ciclo = lambda do |id, caminho|
    return if feito[id] || !idx[id]
    return erros << "ciclo: #{(caminho + [id]).join(' → ')}" if visitando[id]
    visitando[id] = true
    idx[id].deps.each { ciclo.(_1, caminho + [id]) }
    visitando.delete(id)
    feito[id] = true
  end
  cards.each { ciclo.(_1.id, []) }
  if erros.empty? then puts "Backlog válido: #{cards.size} cards." else puts erros; exit 1 end
else
  puts File.read(__FILE__)[/^# Backlog.*?(?=\n\n)/m].gsub(/^# ?/, "")
end
