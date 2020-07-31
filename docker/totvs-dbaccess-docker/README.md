# TOTVS DBAccess 64bits Dockerfile

## O que é Docker ?

Docker é um _runtime_ para execução de LinuX _Containers_ (LXC). Este repositório contém um conjunto de scripts para construir uma imagem do `dbaccess64` que poderá ser executada em qualquer host Linux que tenha o [Docker Engine](https://docs.docker.com/installation/) instalado.

## Como usar esta imagem ?

Você pode clonar este reposutório e construir a sua própria imagem. O repositóprio pretende manter-se em sincronia com os lançamentos dos novos binários do TOTVS DBAccess fornecidos pela TOTVS. Então, para cada release, haverá uma tag no repositório.

Quando clonar o repositório, basta fazer o checkout para a tag específica, baixar o arquivo `.tar.gz` do DBAccess correspondente àquela tag (https://suporte.totvs.com/download), e executar o comando `$ docker build .`.

### O jeito fácil!

Instale o Docker Compose, e execute os comandos a seguir :

````
$ git clone https://github.com/endersonmaia/totvs-dbaccess-docker
$ git checkout 20160402-16-11-10
$ 
$ docker-compose up
````

### Fazendo você mesmo

Para construir sua imagem, execute os comandos a seguir:

````
$ git clone https://github.com/endersonmaia/totvs-dbaccess-docker
$ cd totvs-dbaccess-docker
$ git checkout 20141119
$ docker build -t dbaccess64-20141119 .
````

### Executando o DBAccess64

Após ter construído a imagem, é possível executá-la e linkar a um container com PostgreSQL 9.3.

````
$ docker run -d --name postgres \
  -e POSTGRES_USER=protheus \
  -e POSTGRES_PASSWORD=protheus \
  postgres:9.3
$ docker run -d --name dbaccess \
  --link postgres:postgres \
  -p 7890:7890 \
  dbaccess64-20141119
$ docker ps
CONTAINER ID        IMAGE                COMMAND                CREATED              STATUS              PORTS                    NAMES
b99abd595634        dbacces64-20141119   "/docker-entrypoint.   About a minute ago   Up About a minute   0.0.0.0:7890->7890/tcp   dbaccess            
e472b722662d        postgres:9.3         "/docker-entrypoint.   About a minute ago   Up About a minute   5432/tcp                 postgres       
````

Agora basta que você acesse o DBMonitor, apontando para o IP do seu host que está executando o Docker Engine, na porta 7890, como exibido acima.

### Conectando em um banco já existente

Caso você não queira usar o PostgreSQL 9.3 fornecido como imagem Docker, você pode informar os dados de acesso a um PostgreSQL ou SQL Server existente.

#### Com DATABASE_URL

Você pode usar uma variável de ambiente, DATABASE_URL como a seguir `[postgres|sqlserver]://<user>:<pass>@<host>:<port>/<database>`.

Por exemplo:

````
$ docker run -d --name dbaccess \
  -e DATABASE_URL=sqlserver://protheus:mypassword@databaseserver.example.com:1433/protheus \
  -p 7890:7890 \
  dbaccess64-20141119
````

#### Variáveis individuais

Pode ser necessário usar variáveis separadas quando você tem caracteres especiais no nome de usuário e/ou senha, por ex:

````
$ docker run -d --name dbaccess \
  -e DB_HOST=postgres.example.com \
  -e DB_PORT=5432 \
  -e DB_USER=protheus \
  -e DB_PASS=p@55W0rD \
  -e DB_NAME=protheus \
  -p 7890:7890 \
  dbaccess64-20141119
````

#### Via docker-compose

Você ainda pode alterar o arquivo `docker-compose.yml` e ajustar as varáveis por lá, e usar o comando `docker-compose up`, sempre que precisar levantar o DBAccess.

### Executando o DBMonitor

Também é possível executar a interface do DBMonitor, dentro de um container, basta exportar o $DISPLAY para o servidor X11 da sua máquina.

Se você estiver num OS X, você pode usar o [XQuartz](http://xquartz.macosforge.org/landing/), se estiver no Windows pode usar o [MobaXtrem](http://mobaxterm.mobatek.net/).

#### No Linux

Considerando que você executa o Docker Engine localmente.

````
$ docker run -ti --rm \
     -e DISPLAY=$DISPLAY \
     -v /tmp/.X11-unix:/tmp/.X11-unix \
     dbaccess64-20141119 dbmonitor
````

#### No OS X

Instale o XQuartz (http://xquartz.macosforge.org/landing/).

````
$ open -a XQuartz
$ socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
````

O comando `socat` deve ser executado dentro do terminal do XQuartz.

Em outro terminal :

````
$ docker build -t dbmonitor .
$ docker run -ti --rm \
  -e DISPLAY=192.168.59.3:0 \
  dbaccess64-20141119 dbmonitor
````

Você deve informar o IP do seu OS X que seja acessível pelo `DOCKER_HOST`.

# Referência

* http://tdn.totvs.com/display/tec/Character+Set+x+Collation
* http://tdn.totvs.com/display/public/mp/PostgreSQL
* http://tdn.totvs.com/display/tec/Melhoria+-+Suporte+ao+psqlODBC+09.01.0100
* http://www.edivaldobrito.com.br/instalando-o-microsiga-protheus-com-postgresql-no-linux-parte-2/
* https://docs.docker.com/userguide/
* https://github.com/docker/docker/issues/8710#issuecomment-71113263
* http://tdn.totvs.com/display/tec/DBAccess+-+Como+criar+uma+fonte+de+dados+para+uso+com+Microsoft+SQL+Server+-+Linux