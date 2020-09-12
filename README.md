# Desafio Banking (Desafio Técnico)

Desafio técnico para criação de uma banking API utlizando Elixir. 

## O que vai encontrar aqui ?
 Uma API REST impleementada utilizando [Elixir](https://elixir-lang.org/) e o framwork [Phoenix](https://www.phoenixframework.org) que simula um sistema bancario simples. Além disso, essa é uma aplicação 'dockerizada' juntamente com um banco de dados Postgres em um docker-compose.

## Features
  
1. Login com [JWT](https://jwt.io/)
2. Cadastro de Usuários
3. Operações bancarias:
    - Saque de conta.
    - Depositos em conta.
    - Transferências entre contas.
    - Transferências externas.
4. Relátorio de extrato bancário,  

## API
- TODO

## Setup

#### Servidor Local

Para executar dessa forma é necessário um postgres rodando e configurado nas 
os arquivos de configuração da aplicação, que são os mesmo de qualquer aplicação 
Phoenix, Além disso é necessário ter .env configurdado.
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

![Modelo_ER]

- **users**: Utiliza para acesso no sistema
- **clients**: Clientes cadastrados no sistema, que podem possuir uma ou mais _accounts_. 
- **accounts**: Representa as contas de um cliente, que por sua vez pode ter diversas _operations_ associadas.
- **operations**: Representa as operações realizadas em uma _account_, que por sua vez pode ter diversas operações associadas. O campo _type_ representa o tipo de operação e tem o seguinte domínio: 
   * _SAQUE_ : Retirada de dinheiro da conta.
   * _TRANSFERENCIA_ : Movimentação de recursos de uma conta para outra.
   * _CREDITO_ : Entrada de dinheiro na conta, que pode ser oriundo de uma _TRANSFERENCIA_, é referenciada pelo campo _origin_operation_id_.

## Testes

Testes podem ser executados com o seguinte comando:

```

mix test

```

Pode-se ver a cobertura dos testes utilizando o seguinte commando:

```

mix converalls

```

## TODOs

Veja as Issues do repositório.
