# Glossário

Cada conceito tem **o mesmo nome** nos docs, no código e nas telas. Nas telas, o termo pode ser trocado por organização via `Organizacao::Termos`, mas no código o nome é sempre o desta tabela.

| Conceito | No código | Definição | Não confundir com |
|---|---|---|---|
| Tenant | `Tenancy::Tenant`, tabela `public.tenants`, schema `tenant_<id>` | Um cliente do Lumio. Tem um schema isolado e uma assinatura. | Organização (o tenant é o isolamento técnico, a organização é o conteúdo) |
| Organização | `Organizacao::Organizacao`, `organizacoes` | A entidade cliente dentro do tenant: ministério, Campo ou igreja independente. Guarda a configuração da hierarquia. | Denominação (não modelada) |
| Tipo de unidade | `Organizacao::TipoUnidade`, `tipos_unidade` | Nível da hierarquia definido pela organização ("Campo", "Setor", "Congregação"), com pais permitidos e flags. | Unidade |
| Unidade | `Organizacao::Unidade`, `unidades` | Um nó da árvore (a congregação do Bairro X, por exemplo). Tem `caminho` ltree. | Igreja, congregação (são **tipos**, não conceitos do código) |
| Sede | `unidades.sede` | Unidade marcada como sede entre as irmãs. No máximo uma por pai. | Unidade raiz |
| Unidade raiz | `Organizacao::Api.raiz` | O topo da árvore, criado no provisionamento. | Sede |
| Membro | `Membros::Membro`, `membros` | Pessoa vinculada a uma unidade que `recebe_membros`. | Usuário |
| Desligamento | `Membros::Desligamento` | Saída de um membro, com tipo configurável. | Exclusão (membro nunca é apagado) |
| Tipo de desligamento | `Membros::TipoDesligamento` | Transferência, exclusão etc., configurado por organização. Flags `gera_carta` e `exige_destino`. | — |
| Disciplina | `Membros::Disciplina` | Período disciplinar do membro: início obrigatório, fim opcional, motivo criptografado. | Desligamento |
| Tipo de cargo | `Cargos::TipoCargo`, `tipos_cargo` | Função definida pela organização ("Presidente", "Secretário"), com flags (`unico`, `exibe_no_cabecalho`, `assina_cartas`, onde pode existir). | Perfil |
| Ocupação | `Cargos::Ocupacao`, `ocupacoes_cargo` | Alguém ocupando um cargo numa unidade durante um período. O ocupante pode ser um membro ou apenas um nome. | Vínculo |
| Usuário | `Identidade::Usuario`, `public.usuarios` | Quem faz login. É global e pode acessar vários tenants. | Membro |
| Permissão | `Identidade::Permissoes` | Ação atômica declarada por um pack (`membros.editar`). | Perfil |
| Perfil | `Identidade::Perfil`, `perfis` | Conjunto de permissões, definido por tenant. | Cargo (cargo é eclesiástico, perfil é acesso ao sistema) |
| Vínculo | `Identidade::Vinculo`, `vinculos` | Usuário + perfil + unidade dentro de um tenant. | Ocupação |
| Escopo | `Identidade::Escopo` | O que um vínculo enxerga: a unidade dele e toda a subárvore. | — |
| Termos | `Organizacao::Termos` | Nomes exibidos nas telas para cada conceito, por organização. | — |
| Carta | `Documentos::Carta` | Documento emitido (de recomendação ou transferência) com signatários congelados. | Modelo de carta |

## Nomes a evitar no código
`igreja`, `congregacao`, `campo`, `pastor` e `presidente` como nomes de classe, coluna ou método. Esses termos são **dados** que a organização configura.
Existe uma exceção: fixtures e seeds, que descrevem cenários reais.
