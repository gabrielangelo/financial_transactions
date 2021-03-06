# Desafio Banking (Desafio Técnico)

Desafio técnico para criação de uma banking API utlizando Elixir. 

## O que vai encontrar aqui ?
 Uma API REST impleementada utilizando [Elixir](https://elixir-lang.org/) e o framwork [Phoenix](https://www.phoenixframework.org) que simula um sistema bancário simples. Além disso, essa é uma aplicação 'dockerizada' juntamente com um banco de dados Postgres em um docker-compose.

## Features
  
1. Login com [JWT](https://jwt.io/)
2. Cadastro de Usuários
3. Operações bancarias:
    - Saque de conta.
    - Depósitos em conta.
    - Transferências entre contas.
    - Transferências externas.
4. Relatório de extrato bancário,  

## API
- Importar a  [json doc](https://github.com/gabrielangelo/financial_transactions/blob/master/financial-transactions.postman_collection.json) no Postman

## Setup

#### Servidor Local

Para executar dessa forma é necessário um postgres rodando e configurado nos arquivos de configuração da aplicação, que são os mesmos de qualquer aplicação 
Phoenix, Além disso é necessário ter .env configurado.
```
APP_PORT=4000
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=localhost
DB_PORT=5432

SECRET_KEY_BASE= "can be generated using 
$ mix phx.gen.secret"
DATABASE_URL=ecto://postgres:postgres@localhost/financial_transactions_docker
DATABASE_DB=financial_transactions_docker
```

```
$ make setup
```

#### Docker Compose

Presumindo que já tenha o Docker e Docker Compose instalado, execute o comando abaixo.  

```

$ docker-compose up

```


## Modelo

![Modelo_ER](https://github.com/gabrielangelo/financial_transactions/blob/master/schema.png)

- **users**: Utiliza para acesso e realizações de operações.
- **accounts**: Representa as contas de usuário.
- **transactions**: Representa as transações realizadas em uma _account_, que por sua vez pode ter diversas operações associadas. O campo _type_ representa o tipo de operação e tem o seguinte domínio: 
   * transfer : Movimentação de recursos de uma conta para outra conta.
   * withdraw : Retirada de dinheiro da conta.
- **amounts**: Coleção de amounts correspondente ao valor da transação.
## Testes

Testes podem ser executados:

local:

```

mix test

```

usando docker:
```

docker-compose run --rm -e "MIX_ENV=test" web mix test

```

Pode-se ver a cobertura dos testes utilizando o seguinte commando:
local:

```

mix coveralls

```
usando docker:
```

docker-compose run --rm -e "MIX_ENV=test" web mix coveralls

```


## TODOs

Veja as Issues do repositório.
