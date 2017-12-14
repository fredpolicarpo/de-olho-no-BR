library("RPostgreSQL")
library(crayon)

source("utils.R")

dbHost = "localhost"
dbName = "decifrando-eleicoes"
dbUser = "postgres"
dbPwd = "fibo123"
dbPort = 5432

drv <- dbDriver("PostgreSQL")

getCon = function() {
  con <- dbConnect(
    drv,
    dbname = dbName,
    host = dbHost,
    port = dbPort,
    user = dbUser,
    password = dbPwd
  )
  
  return (con)
}

createTables = function() {
  con = getCon()
  
  if (dbExistsTable(con, "legendas") == F)  {
    cat(blue("Tabela legendas não existe, criando...\n"))
    dbExecute(con,
              lerArquivo("data-source/cache-postgres/ddl/legendas.sql"))
  }
  
  if (dbExistsTable(con, "candidatos") == F)  {
    cat(blue("Tabela candidatos não existe, criando...\n"))
    dbExecute(con,
              lerArquivo("data-source/cache-postgres/ddl/candidatos.sql"))
  }
  
  if (dbExistsTable(con, "votos") == F)  {
    cat(blue("Tabela votos não existe, criando...\n"))
    dbExecute(con,
              lerArquivo("data-source/cache-postgres/ddl/votos.sql"))
  }

    if (dbExistsTable(con, "consolidacao_eleicao") == F)  {
        cat(blue("Tabela consolidacao_eleicao não existe, criando...\n"))
        dbExecute(con,
            lerArquivo("data-source/cache-postgres/ddl/consolidacao_eleicao.sql"))
    }
  
  dbDisconnect(con)
}

createTables()

upsert = function(con, table, data) {
  colnames(data) <- tolower(colnames(data))
  dbWriteTable(
    con,
    tolower(table),
    value = data,
    append = T,
    row.names = F,
    overwrite = F
  )
}

lerDados = function(con, sql) {
  dados  = RPostgreSQL::dbGetQuery(con, sql)
  return(dados)
}

excutarSql = function(con, sqlFile) {
  dbExecute(con, lerArquivo(sqlFile))
}
