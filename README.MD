# De olho no BR: plataforma de visualização de dados eleitorais brasileiros

**De olho no BR** é uma plataforma para visualização de dados eleitorais brasileiros onde o usuário pode navegar em um portal web com diversos painéis compostos por variados tipos de gráficos, além de gerar manchetes com base em alguns filtros pré-estabelecidos.

A plataforma gera uma cache com os dados fornecidos pela api do CEPESP, e à partir desta cache realiza diversas consultas e agregações que são os dados de entrada pra criação dos paineis e das manchetes.

### Requisitos

 - Ubuntu 16.04.3 LTS 64-bit
 - R >= 3.4.2
 - Postgresql >= 9.6.6
 - As bibliotecas do R necessárias para cada um dos subprojetos está detalhada na documentação deles, conforme links abaixo.

### Esta plataforma é composta por dois componentes principais

 - Portal Web: [Confira  a documentação aqui](./web-app/README.MD).
 - Serviço de atualização de cache: [Confira a documentação aqui](./atualizacao-cache/README.MD).