require(glue)
require(dplyr)
require(tidyr)

source("data-source/db-connector.R")
source("data-source/utils.R")

add_filtro_anos = function(sql, anos) {
  if (length(anos) > 0) {
    filtro_anos = paste(unlist(anos), collapse = ",")
    
    sql = paste(sql, glue("where ano_eleicao in ({filtro_anos})"))  
  }
  
  return(sql)
}

manchetes_aproveitamento_partidos = function(con, anos) {
  sql = "select * from aproveitamento_partidos" %>% add_filtro_anos(anos)
  
  dados = lerDados(con, sql) %>% 
    group_by(sigla_partido) %>% 
    summarize(total_partido = sum(total_partido), total_eleito_partido = sum(total_eleito_partido))
    
  dados$porcentagem = round(100 * dados$total_eleito_partido / dados$total_partido, 4)
  
  dados = dados %>%
    select(sigla_partido, total_eleito_partido, porcentagem) %>%
    arrange(desc(porcentagem))
  
  return(dados)
}

manchetes_partidos = function(con, anos) {
  sql = "select * from porcent_eleitos_partido"  %>% add_filtro_anos(anos)
  
  dados = lerDados(con, sql)
  
  totais_partido =  dados %>% 
    group_by(sigla_partido) %>% 
    summarise(total_partido = sum(total_partido))
  
  total_geral = sum(totais_partido$total_partido)
  
  totais_partido$porcentagem = 100 * totais_partido$total_partido/total_geral
  
  totais_partido$porcentagem =  round(totais_partido$porcentagem, 4)
  
  totais_partido = totais_partido %>%
    arrange(desc(porcentagem))
  
  return(totais_partido)
}

manchetes_turnos = function(con, anos) {
  sql = "select * from porcent_executivos_truno" %>% add_filtro_anos(anos)
  
  dados = lerDados(con, sql)
  
  total_geral = sum(dados$total_turno)
  
  total_por_turno = dados %>% 
    group_by(num_turno) %>% 
    summarise(total_turno = sum(total_turno))
  
  total_por_turno$porcentagem = round(100 * total_por_turno$total_turno/total_geral, 4)
  
  return(total_por_turno)
}

top_10_ocupacoes = function(con, anos) {
  sql = "select * from top_10_ocupacoes" %>% add_filtro_anos(anos)
  
  dados = lerDados(con, sql)
  
  total_por_ocupacao = dados %>% 
    group_by(ocupacao) %>% 
    summarise(total = sum(total)) %>% 
    arrange(desc(total))
  
  top_10 = total_por_ocupacao[1:10,]
  
  return(top_10)
}

grau_instrucao = function(con, anos) {
  sql =   'select
            cod_grau_instrucao,
            max(grau_instrucao) as grau_instrucao,
            count(*) as total
          from grau_instrucao_eleitos'  %>% add_filtro_anos(anos)

  sql = paste(sql,'GROUP BY cod_grau_instrucao ORDER BY total desc')
  
  dados = lerDados(con, sql) %>% 
    select(grau_instrucao, total) %>%
    arrange(desc(total))
  
  return(dados)
}

manchetes_genero = function(con, anos) {
  sql = "select * from eleitos_genero"  %>% add_filtro_anos(anos)
  
  dados = lerDados(con, sql)
  
  geral = geral(dados)
  
  list_top_f_uf = top_f_uf(dados)
  list_top_m_uf = top_m_uf(dados)
  
  top_cargo_sexo_df = top_cargo_sexo(dados)
  
  manchetes = list(geral = geral, 
                   top_f_uf = list_top_f_uf$top, 
                   top_m_uf = list_top_m_uf$top,
                   top_10_f_uf = list_top_f_uf$top_10, 
                   top_10_m_uf = list_top_m_uf$top_10,
                   top_cargo_m = top_cargo_sexo_df$m,
                   top_cargo_f = top_cargo_sexo_df$f)
  
  return(manchetes)
}

top_cargo_sexo = function(dados) {
  totais_cargos = dados %>% 
    group_by(codigo_cargo) %>% 
    summarise(total_cargo = sum(total))
  
  totais_cargos_sexo = dados %>% 
    group_by(codigo_cargo, descricao_sexo) %>% 
    summarise(total_sexo = sum(total))
  
  proporcionais_cargo_sexo = totais_cargos_sexo %>% 
    inner_join(totais_cargos) %>% 
    mutate(porcent = round(((total_sexo / total_cargo)* 100), 4))
  
  df_cargos = data.frame(codigo_cargo = c(cod_cargos_eleicoes_federatvas, cod_cargos_eleicoes_municipais),
                         cargo = c(names(cod_cargos_eleicoes_federatvas), names(cod_cargos_eleicoes_municipais)))
  
  proporcionais_cargo_sexo_m = proporcionais_cargo_sexo %>%
    filter(descricao_sexo == 'MASCULINO') %>%
    arrange(desc(porcent)) %>%
    inner_join(df_cargos)
  
  proporcionais_cargo_sexo_f = proporcionais_cargo_sexo %>%
    filter(descricao_sexo == 'FEMININO') %>%
    arrange(desc(porcent)) %>%
    inner_join(df_cargos)
  
  lista_cargo_sexo = list(m = proporcionais_cargo_sexo_m,
                          f = proporcionais_cargo_sexo_f)
  
  return(lista_cargo_sexo)
}

geral = function(dados) {
  total_geral = dados %>% 
    summarise(total = sum(total))
  
  total_geral = total_geral$total
  
  geral = dados %>% 
    group_by(descricao_sexo) %>% 
    summarise(total_sexo = sum(total)) %>%
    mutate(porcent_sexo = round((total_sexo/total_geral) * 100, 2))
  
  
  return(geral)
}

top_m_uf = function(dados) {
  top = top_sexo_uf(dados, "MASCULINO")
  return(top)
}

top_f_uf = function(dados) {
  top = top_sexo_uf(dados, "FEMININO")
  return(top)
}

top_sexo_uf = function(dados, sexo) {
  total_por_uf = dados %>%
    filter(sigla_uf != 'BR') %>%
    group_by(sigla_uf) %>%
    summarise(total = sum(total))
  
  sexo_por_uf = dados %>%
    filter(descricao_sexo == sexo) %>%
    group_by(sigla_uf, descricao_sexo) %>%
    summarise(total_sexo = sum(total))
  
  top_sexo = sexo_por_uf %>%
    filter(descricao_sexo == sexo) %>%
    inner_join(total_por_uf, by = "sigla_uf") %>%
    mutate(porcent = round((total_sexo/total) * 100, 2)) 
  
  top_sexo = top_sexo %>% arrange(desc(porcent)) 
  
  top_10_sexo = top_sexo[1:10,]
  top_10_sexo = top_10_sexo %>%
    inner_join(data.frame(sigla_uf = ufs, uf = names(ufs), by='sigla_uf')) %>%
    select(uf, porcent)
  
  top_sexo = top_sexo[1,]
  
  top_sexo$uf = names(ufs[ufs == top_sexo$sigla_uf])
  
  list_top_sexo = list(top = top_sexo, top_10 = top_10_sexo)
  
  return(list_top_sexo)
}
