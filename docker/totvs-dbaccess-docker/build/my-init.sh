#!/bin/bash
set -e

if [ ! -z ${DATABASE_URL+x} ]; then
  pattern='^(postgres|mssql):\/\/([^:]+):([^@]+)@([^:]+):([^\/]\d+)\/(.+)'

  if [[ "${1}" =~ $pattern ]]; then
    export DB_TYPE=${BASH_REMATCH[1]}
    export DB_USER=${BASH_REMATCH[2]}
    export DB_PASS=${BASH_REMATCH[3]}
    export DB_HOST=${BASH_REMATCH[4]}
    export DB_PORT=${BASH_REMATCH[5]}
    export DB_NAME=${BASH_REMATCH[6]}
  else
    echo "Não foi possível obter configuração a partir de \$DATABASE_URL." > /dev/stderr
    exit 1
  fi
else
  /bin/sed 's/{{DB_USER}}/'"${DB_USER}"'/' -i /etc/odbc.ini
  /bin/sed 's/{{DB_PASS}}/'"${DB_PASS}"'/' -i /etc/odbc.ini
  /bin/sed 's/{{DB_HOST}}/'"${DB_HOST}"'/' -i /etc/odbc.ini
  /bin/sed 's/{{DB_PORT}}/'"${DB_PORT}"'/' -i /etc/odbc.ini
  /bin/sed 's/{{DB_NAME}}/'"${DB_NAME}"'/' -i /etc/odbc.ini
fi

/opt/totvs/dbaccess64/tools/dbaccesscfg \
  -u ${DB_USER} \
  -p ${DB_PASS} \
  -d ${DB_TYPE} \
  -a ${DB_NAME} \
  -o "clientlibrary=/usr/lib64/libodbc.so" \
  -g "LicenseServer=${LICENSE_SERVER};LicensePort=${LICENSE_SERVER_PORT};ByYouProc=0;ODBC30=1"

if [ "$1" = 'dbaccess' ]; then

  until echo -n > /dev/tcp/${DB_HOST}/${DB_PORT}
  do
      echo "INFO Esperando serviço de banco de dados..."
      sleep 0.5
  done

  echo "INFO Conectado ao serviço de banco de dados."

  exec "/opt/totvs/dbaccess64/multi/dbaccess64"

elif [ "$1" = 'dbmonitor' ]; then

  exec "/opt/totvs/dbaccess64/dbmonitor"

fi

exec "$@"
