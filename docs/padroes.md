# Padrões de código

Cada padrão aponta para um **arquivo canônico**: um arquivo real do projeto que serve de exemplo. Para criar um arquivo do mesmo tipo, copie o canônico e adapte.

Enquanto um canônico não existe, a coluna "Criado em" diz qual card o cria. O primeiro arquivo daquele tipo **é** o canônico e deve ser escrito com o esqueleto abaixo. Assim que ele existir, troque "(a criar)" pelo caminho.

| Padrão | Arquivo canônico | Criado em |
|---|---|---|
| Fachada do pack | `packs/tenancy/app/public/tenancy/api.rb` (a criar) | LUM-08 |
| Erro de domínio | `packs/shared_kernel/app/public/shared_kernel/domain_error.rb` (a criar) | LUM-07 |
| Service | `packs/tenancy/app/services/tenancy/provisionar_tenant.rb` (a criar) | LUM-11 |
| Query | `packs/membros/app/queries/membros/busca_membros.rb` (a criar) | LUM-29 |
| Policy | `packs/membros/app/policies/membros/membro_policy.rb` (a criar) | LUM-29 |
| Serializer (props Inertia) | `packs/membros/app/serializers/membros/membro_serializer.rb` (a criar) | LUM-29 |
| DTO de fronteira | `packs/cargos/app/public/cargos/ocupante.rb` (a criar) | LUM-31 |
| Evento + handler | `packs/membros/app/public/membros/eventos/membro_desligado.rb` (a criar) | LUM-35 |
| Job com tenant | `packs/documentos/app/jobs/documentos/gerar_carta_job.rb` (a criar) | LUM-35 |
| Migration de tenant | `db/tenant_migrate/` (primeira a criar) | LUM-10 |
| i18n | `packs/membros/config/locales/pt-BR.yml` (a criar) | LUM-29 |
| Página Inertia | `packs/membros/app/frontend/pages/Membros/Index.vue` (a criar) | LUM-29 |

## Esqueletos

### Fachada do pack
```ruby
# packs/<pack>/app/public/<pack>/api.rb
module Tenancy
  module Api
    module_function

    # Único ponto de entrada para outros packs. Nada de model interno aqui.
    def com_tenant(tenant_id, &)
      Tenancy::TrocaDeSchema.new(tenant_id).executar(&)
    end
  end
end
```

### Erro de domínio
```ruby
module SharedKernel
  class DomainError < StandardError
    attr_reader :campo
    def initialize(mensagem, campo: :base)
      @campo = campo
      super(mensagem)
    end
  end
end
# ApplicationController faz rescue_from DomainError e devolve errors ao Inertia.
# Actions NUNCA fazem rescue de DomainError.
```

### Service
```ruby
module Membros
  class Desligar
    def self.call(...) = new(...).call

    def initialize(membro:, tipo:, autor:, destino: nil)
      @membro, @tipo, @autor, @destino = membro, tipo, autor, destino
    end

    def call
      raise SharedKernel::DomainError.new(I18n.t("membros.erros.destino_obrigatorio"), campo: :destino) if @tipo.exige_destino? && @destino.blank?

      ActiveRecord::Base.transaction do
        desligamento = @membro.desligamentos.create!(tipo: @tipo, destino: @destino, autor_id: @autor.id)
        SharedKernel::Eventos.publicar(Membros::Eventos::MembroDesligado.new(desligamento_id: desligamento.id))
        desligamento
      end
    end
  end
end
```
Regras: um verbo por service, `self.call`, transação dentro do service, **flag** e nunca nome (`@tipo.exige_destino?`).

### Query
```ruby
module Membros
  class BuscaMembros
    def initialize(escopo:) = @escopo = escopo
    def call(termo: nil)
      rel = @escopo.resolve(Membro.kept)
      termo.present? ? rel.where("nome % ?", termo).order(Arel.sql("similarity(nome, #{Membro.connection.quote(termo)}) DESC")) : rel.order(:nome)
    end
  end
end
```

### Policy
```ruby
module Membros
  class MembroPolicy < Identidade::ApplicationPolicy
    def update? = pode?("membros.editar") && no_escopo?(record.unidade)

    class Scope < Scope
      def resolve = scope.joins(:unidade).merge(escopo.unidades)
    end
  end
end
```

### Serializer
```ruby
module Membros
  class MembroSerializer
    def self.lista(membros) = membros.map { new(_1).to_h }
    def initialize(membro) = @m = membro
    def to_h = { id: @m.id, nome: @m.nome, unidade: @m.unidade.nome }
    # Campos explícitos. Nunca `as_json` do model, nunca campo criptografado sem necessidade.
  end
end
```

### DTO de fronteira
```ruby
module Cargos
  Ocupante = Data.define(:nome, :membro_id, :tipo_cargo, :unidade_id)
end
# Outros packs recebem DTOs imutáveis, nunca instâncias de model de outro pack.
```

### Evento + handler
```ruby
module Membros::Eventos
  MembroDesligado = Data.define(:desligamento_id)
end

# config/initializers/eventos.rb (mapa central)
SharedKernel::Eventos.assinar(Membros::Eventos::MembroDesligado) do |evento, tenant_id|
  Documentos::GerarCartaJob.perform_later(tenant_id:, desligamento_id: evento.desligamento_id)
end
# Handler só enfileira. Nenhuma regra de negócio aqui.
```

### Job com tenant
```ruby
module Documentos
  class GerarCartaJob < SharedKernel::TenantJob
    def executar(desligamento_id:)
      # já está dentro do tenant: TenantJob fez Tenancy::Api.com_tenant(tenant_id)
    end
  end
end
```

### Migration de tenant
Fica em `db/tenant_migrate/`. É criada com `/migration-tenant <descrição>`. Nunca referencia tabelas de `public` por FK, e nunca edite uma migration já commitada.

### i18n
Todo texto de tela e erro vai para `packs/<pack>/config/locales/pt-BR.yml`, com chaves `<pack>.<contexto>.<chave>`. Termos da organização (unidade, cargo) vêm de `Organizacao::Termos`, e não do i18n.
