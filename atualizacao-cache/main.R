source("config/install-r-libraries.R")
source("legendas.R")
source("candidatos.R")
source("votos.R")
source("consolidacao-eleicao.R")

cat(green("Iniciando atualização de dados\n"))

if (!dir.exists(DATA_DIR)) {
  dir.create(DATA_DIR)
}

con = getCon()

tryCatch({
  main_atualiza_dados_consolidacao_eleicao()
  
  main_atualiza_dados_legendas()
  
  main_atualiza_dados_candidatos()
  
  main_atualiza_dados_votos()  
  
}, finally = dbDisconnect(con))


