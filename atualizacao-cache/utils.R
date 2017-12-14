library(dplyr)
library(lubridate)

dinheiro = function(numero) {
  sufixo = ""
  
  bilhao = 1000000000
  milhao = 1000000
  mil    = 1000
  
  if (numero > bilhao) {
    sufixo = "bi"
    numero = round(numero / bilhao, 2)
  } else  if (numero > milhao) {
    sufixo = "mi"
    numero = round(numero / milhao, 2)
  } else if (numero > mil) {
    numero = round(numero / mil, 2)
    sufixo = "mil"
  }
  
  dinheiro_formatado =  paste(
    "R$",
    formatC(
      numero,
      format = "f",
      digits = 2,
      big.mark = ".",
      decimal.mark = ","
    ),
    sufixo
  )
  
  return(dinheiro_formatado)
}

numero = function(numero) {
  sufixo = ""
  
  bilhao = 1000000000
  milhao = 1000000
  mil    = 1000
  
  if (numero > bilhao) {
    sufixo = "bi"
    numero = round(numero / bilhao, 2)
  } else  if (numero > milhao) {
    sufixo = "mi"
    numero = round(numero / milhao, 2)
  } else if (numero > mil) {
    numero = round(numero / mil, 2)
    sufixo = "mil"
  }
  
  dinheiro_formatado =  paste(
    formatC(
      numero,
      format = "f",
      digits = 2,
      big.mark = ".",
      decimal.mark = ","
    ),
    sufixo
  )
  
  return(dinheiro_formatado)
}

lerArquivo = function(path) {
  return (readChar(path, file.info(path)$size)  )
}
