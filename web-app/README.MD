# *De olho no BR* : Portal de visualização
Essa documentação é uma parte do sistema **De olho no BR**, [confira  a documentação geral aqui](../README.MD). 

### Configurando o ambiente

#### Plataforma `R`
 * Instalar o `R` versão >= `3.4.2`
 * Instalar as bibliotecas do `R` necessárias executando o script [install-r-libraries.R](config/install-r-libraries.R)

#### Banco de dados de cache
 **Obs:** *O portal web deve ser executado após a configuração e execução do [sistema de atualização de cache de dados](../atualizacao-cache/README.MD). Portanto, neste ponto o banco deve estar instalado e configurado, bastando apenas anotar os dados de conexão no arquivo adequado, conforme instrução abaixo.*
 
 * Configurar os dados de acesso [neste arquivo](./config/postgres.properties), conforme exemplo abaixo:

```
host=127.0.0.1
port=5432
database=decifrando-eleicoes
user=postgres
password=postgres
```

## Execução
Existem diversas formas para executar a aplicação web:
 - Fazer deploy para o servidor [Shinyapps.io](http://www.shinyapps.io/)
 - Executar em um servidor [Shiny local](https://shiny.rstudio.com/articles/deployment-local.html)
 - Executar diretamente em uma sessão `R`, através do comando `runApp()`
 
 A forma mais simples é através do comando `runApp()`. Você pode fazer isso executando o script  [runShiny.R](runShiny.R), em um terminal, conforme exemplo abaixo:
 `$rscript runShiny.R`
 
 As demais formas de execução estão documentadas no [site do Shiny](https://shiny.rstudio.com/).