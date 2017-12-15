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

numero = function(numeros) {
  numeros_formatados = character(length(numeros))
  
  mil = 1000
  milhao = mil * mil
  bilhao = milhao * mil
  
  numeros_bilhoes = numeros > bilhao
  numeros_milhoes = numeros > milhao & numeros < bilhao
  numeros_mil = numeros > mil & numeros < milhao
  numeros_sem_formatacao = numeros < mil
  
  numeros_formatados[numeros_sem_formatacao] =  numeros[numeros_sem_formatacao]
  
  numeros_formatados[numeros_mil] =  paste(formatC(
    round(numeros[numeros_mil] / mil, 2),
    format = "f",
    digits = 2,
    big.mark = ".",
    decimal.mark = ","
  ), "mil")
  
  numeros_formatados[numeros_milhoes] =  paste(formatC(
    round(numeros[numeros_milhoes] / milhao, 2),
    format = "f",
    digits = 2,
    big.mark = ".",
    decimal.mark = ","
  ), "mi")
  
  numeros_formatados[numeros_bilhoes] =  paste(formatC(
    round(numeros[numeros_bilhoes] / bilhao, 2),
    format = "f",
    digits = 2,
    big.mark = ".",
    decimal.mark = ","
  ), "bi")
  
  return(numeros_formatados)
}

lerArquivo = function(path) {
  return (readChar(path, file.info(path)$size))
}