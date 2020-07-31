sleep 30s

echo "INFO executando o script de inicializacao..."
#run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SA_PASSWORD} -d master -i dbinit.sql