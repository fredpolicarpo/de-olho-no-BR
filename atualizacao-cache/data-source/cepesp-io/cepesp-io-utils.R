library(lubridate)
library(dplyr)
library(stringr)
library(rjson)
source("config/settings.R")
source("data-source/cache-postgres/db-connector.R")

base.url = "http://cepesp.io/api/consulta/"

get_data_atualizacao_cepesp = function(categoria, colunas, cargo_cod, ano, extra_param = '') {
  param_colunas = paste0('&selected_columns[]=', colunas, collapse = '')
  
  url = paste0(
    base.url,
    categoria,
    "?start=0&length=1&format=datatable",
    "&ano=",
    ano,
    "&cargo=",
    cargo_cod,
    param_colunas,
    extra_param
  )
  print(url)
  
  dados_atualizacao = fromJSON(file = url)
  
  if (length(dados_atualizacao$data) > 0) {
    data_atualizacao = dados_atualizacao$data[[1]]$DATA_GERACAO %>% as.Date("%d/%m/%Y")
  } else {
    # Se não conseguir obter data, considera data atual para forçar atualização
    data_atualizacao = now() %>% as.Date()
  }
  
  return(data_atualizacao)
}

get_dados = function(categoria,
                     colunas,
                     cargo_cod,
                     ano,
                     extra_param = "") {
  param_colunas = paste0('&selected_columns[]=', colunas, collapse = '')
  
  url = paste0(
    base.url,
    categoria,
    "?format=csv",
    "&ano=",
    ano,
    "&cargo=",
    cargo_cod,
    param_colunas,
    extra_param
  )
  
  # Extrai nomes e tamanhos dos arquivos via requisição HEAD da api do CEPESP
  head = HEAD(url)
  headers = head[['headers']]
  
  nome.arquivo = headers[["content-disposition"]] %>% str_extract("[^=]*.csv")
  
  if (is.na(nome.arquivo) | is.null(nome.arquivo)) {
    nome.arquivo = glue("{categoria}-{cargo}-{ano}-{extras_params}.csv")
  }
  
  # Define caminho onde o arquivo será baixado
  caminho.arquivo = file.path(DATA_DIR, nome.arquivo)
  
  print("Baixando dados...")
  download.file(url, caminho.arquivo)
  
  print("Carregando data frame...")
  dados = lerCsv(caminho.arquivo)
  
  return(dados)
}

lerCsv = function(path) {
  na.strings = c("#NULO#", "#NI#", "#NE#", "", "-1")
  
  df = read.csv(
    path,
    na.strings = na.strings,
    dec = ",",
    stringsAsFactors = F
  )
  
  df = tratar_dados_cepesp(df)
  
  return(df)
}

tratar_dados_cepesp = function(df) {
  separador_decimal_cepesp = ","
  separador_decimal_r = "."
  
  colnames(df) = colnames(df) %>% toupper()
  
  colunas = colnames(df)
  
  if ("COD_SIT_TOT_TURNO" %in% colunas) {
    df$COD_SIT_TOT_TURNO =  df$COD_SIT_TOT_TURNO %>% as.numeric()
  }
  
  if ("CODIGO_MUNICIPIO_NASCIMENTO" %in% colunas) {
    df$CODIGO_MUNICIPIO_NASCIMENTO =  df$CODIGO_MUNICIPIO_NASCIMENTO %>% as.numeric()
  }
  
  if ("CODIGO_NACIONALIDADE" %in% colunas) {
    df$CODIGO_NACIONALIDADE =  df$CODIGO_NACIONALIDADE %>% as.numeric()
  }
  
  if ("CODIGO_ESTADO_CIVIL" %in% colunas) {
    df$CODIGO_ESTADO_CIVIL =  df$CODIGO_ESTADO_CIVIL %>% as.numeric()
  }
  
  if ("COD_SITUACAO_CANDIDATURA" %in% colunas) {
    df$COD_SITUACAO_CANDIDATURA =  df$COD_SITUACAO_CANDIDATURA %>% as.numeric()
  }
  
  if ("COD_GRAU_INSTRUCAO" %in% colunas) {
    df$COD_GRAU_INSTRUCAO =  df$COD_GRAU_INSTRUCAO %>% as.numeric()
  }
  
  if ("CODIGO_OCUPACAO" %in% colunas) {
    df$CODIGO_OCUPACAO =  df$CODIGO_OCUPACAO %>% as.numeric()
  }
  
  if ("NUMERO_PARTIDO" %in% colunas) {
    df$NUMERO_PARTIDO =  df$NUMERO_PARTIDO %>% as.numeric()
  }
  
  if ("DESPESA_MAX_CAMPANHA" %in% colunas) {
    df$DESPESA_MAX_CAMPANHA = str_replace(df$DESPESA_MAX_CAMPANHA,
                                          separador_decimal_cepesp,
                                          separador_decimal_r) %>%
      as.numeric()
  }
  
  if ("DATA_NASCIMENTO" %in% colunas) {
    df$DATA_NASCIMENTO = df$DATA_NASCIMENTO %>% dmy() %>% as.character()
    
    data_incompletas = df$DATA_NASCIMENTO[nchar(df$DATA_NASCIMENTO) == 8]
    datas_novas = paste0("19", data_incompletas)
    
    tamanhos_datas = nchar(df$DATA_NASCIMENTO)
    df$DATA_NASCIMENTO[!is.na(tamanhos_datas) & tamanhos_datas == 8] = datas_novas
  }
  
  if ("DATA_GERACAO" %in% colunas) {
    df$DATA_GERACAO = df$DATA_GERACAO %>% dmy() %>% as.character()
  }
  
  if ("CPF_CANDIDATO" %in% colunas) {
    df$CPF_CANDIDATO = str_replace(df$CPF_CANDIDATO, " ", "") %>% as.numeric()
  }
  
  return (df)
}
