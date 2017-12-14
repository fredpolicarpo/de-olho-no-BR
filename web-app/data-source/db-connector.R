require(RPostgreSQL)
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
  
  if (dbExistsTable(con, "votos") == F)  {
    dbExecute(con, lerArquivo("data-sources/DDL/DDL_votos.sql"))
  }
  if (dbExistsTable(con, "candidatos") == F)  {
    dbExecute(con, lerArquivo("data-sources/DDL/DDL_candidatos.sql"))
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
