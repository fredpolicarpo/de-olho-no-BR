# *De olho no BR* : Serviço de atualização de cache
Essa documentação é uma parte do sistema **De olho no BR**, [confira  a documentação geral aqui](../README.MD). 

### Configurando o ambiente

#### Plataforma `R`
 * Instalar o `R` versão >= `3.4.2`
 * Instalar as bibliotecas do `R` necessárias executando o script [install-r-libraries.R](config/install-r-libraries.R)

#### Banco de dados de cache
 * Instalar banco de dados `Postgres SQL` versão >= 9.6.6
 * Criar uma base no `Postgres` e configurar os dados de acesso [neste arquivo](./config/postgres.properties), conforme exemplo abaixo:

```
host=127.0.0.1
port=5432
database=decifrando-eleicoes
user=postgres
password=postgres
```

### Execução e agendamento
 1. Editar o arquivo `crontab` configurando os diretórios locais do arquivo [main.R](main.R), assim como o diretório para o arquivo de log. Exemplo:
 
 - Arquivo original: `0 1 * * * /path/Rscript main.R > /path/atualizacao-cache-$(date).log`
 
 - Arquivo editado: `0 1 * * * /media/de-olho-no-BR/atualizacao-cache/Rscript main.R > /media/de-olho-no-BR/atualizacao-cache/atualizacao-cache-$(date).log`
 
 2. Dar permissão para executar o arquivo de agendamento do sistema de atualização de cache:
 `$chmod +x agendar-atualizacao-diaria.sh`
 3. Excutar o arquivo:
 `$./agendar-atualizacao-diaria.sh`
 4. Verificar que uma execuação de atualização de cache é disparada instantâneamente 
 5. Vefiricar que outras exeuções foram agendadas pelo `crontab`, com o comando: 
 `$crontab -l`
 
 