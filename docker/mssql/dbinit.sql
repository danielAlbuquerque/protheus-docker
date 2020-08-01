sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
sp_configure 'max server memory', 32768;  
GO  
RECONFIGURE;  
GO 
CREATE DATABASE $(MSSQL_DB);
GO