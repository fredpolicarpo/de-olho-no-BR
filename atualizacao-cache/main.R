source("legendas.R")
source("candidatos.R")
source("votos.R")
library(crayon)

cat(green("Iniciando atualização de dados\n"))

if (!dir.exists(DATA_DIR)) {
  dir.create(DATA_DIR)
}

main_atualiza_dados_legendas()

main_atualiza_dados_candidatos()

main_atualiza_dados_votos()

