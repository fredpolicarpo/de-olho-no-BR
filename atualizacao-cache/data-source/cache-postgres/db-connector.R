require(RPostgreSQL)
require(crayon)
require(properties)

source("utils.R")

dbData = read.properties("config/postgres.properties")

drv <- dbDriver("PostgreSQL")

getCon = function() {
  con <- dbConnect(
    drv,
    dbname = dbData$database,
    host = dbData$host,
    port = dbData$port,
    user = dbData$user,
    password = dbData$password
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
