# frozen_string_literal: true

# HAR-10 · Helpers de spec para multi-tenancy.
#
#   it "lista membros do tenant", :tenant do ... end      # roda dentro de um tenant de teste
#   com_tenant(outro_tenant) { expect(Membro.count).to eq 0 }
module TenantHelpers
  def com_tenant(tenant, &)
    Tenancy::Api.com_tenant(tenant.respond_to?(:id) ? tenant.id : tenant, &)
  end

  def tenant_de_teste
    @tenant_de_teste ||= TenantHelpers.tenant_padrao
  end

  # Um tenant provisionado uma vez por processo. Criar schema a cada exemplo é caro demais.
  def self.tenant_padrao
    @tenant_padrao ||= Tenancy::Api.provisionar!(nome: "Tenant de teste")
  end
end

RSpec.configure do |config|
  config.include TenantHelpers

  config.around(:each, :tenant) do |exemplo|
    com_tenant(tenant_de_teste) { exemplo.run }
  end
end
