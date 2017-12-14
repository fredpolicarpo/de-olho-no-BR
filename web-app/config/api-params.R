# Eleições federativas
cod_cargos_eleicoes_federatvas = c(1, 3, 5, 6, 7, 8)
names(cod_cargos_eleicoes_federatvas) = c(
  "Presidente",
  "Governador",
  "Senador",
  "Deputado federal",
  "Deputado estadual",
  "Deputado distrital"
)
anos_eleicoes_federativas = c(1998, 2002, 2006, 2010, 2014)

# Eleições municipais
cod_cargos_eleicoes_municipais = c(11, 13)
names(cod_cargos_eleicoes_municipais) = c("prefeito", "vereador")
anos_eleicoes_municipais = c(2000, 2004, 2008, 2012, 2016)

agregacoes_politicas = c(1, 2, 3, 4)
names(agregacoes_politicas) = c("partido", "candidatos", "coligacao", "conslidacao_eleicao")

ufs = c('Acre' = 'AC',
        'Alagoas' = 'AL',
        'Amapá' = 'AP',
        'Amazonas' = 'AM',
        'Bahia' = 'BA',
        'Ceará' = 'CE',
        'Distrito Federal' = 'DF',
        'Espírito Santo' = 'ES',
        'Goiás' = 'GO',
        'Maranhão' = 'MA',
        'Mato Grosso' = 'MT',
        'Mato Grosso do Sul' = 'MS',
        'Minas Gerais' = 'MG',
        'Pará' = 'PA',
        'Paraíba' = 'PB',
        'Paraná' = 'PR',
        'Pernanbuco' = 'PE',
        'Piauí' = 'PI',
        'Rio de Janeiro' = 'RJ',
        'Rio Grande do Norte' = 'RN',
        'Rio Grande do Sul' = 'RS',
        'Roraima' = 'RO',
        'Rondônia' = 'RR',
        'Acre' = 'SC',
        'São Paulo' = 'SP',
        'Sergipe' = 'SE',
        'Tocantins' = 'TO')
