USE [master]
GO

CREATE DATABASE [AdventureWorks2014]
GO

CREATE LOGIN [usrlink] WITH PASSWORD=N'123', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [AdventureWorks2014]
GO
CREATE USER [usrlink] FOR LOGIN [usrlink]
GO
ALTER USER [usrlink] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [usrlink]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [usrlink]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [usrlink]
GO


---Criar o linked server

USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'ULTRA-GU\SQL2014', @srvproduct=N'SQL Server'

GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'rpc', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'rpc out', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'ULTRA-GU\SQL2014', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
USE [master]
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'ULTRA-GU\SQL2014', @locallogin = N'ULTRA-GU\gusta', @useself = N'False', @rmtuser = N'usrlink', @rmtpassword = N'123'
GO


--Consultas distribuídas
--Usando Four-Part-Name (FQN)
SELECT *
FROM [ULTRA-GU\SQL2014].[master].[sys].[databases]
GO

SELECT GETDATE(), @@VERSION
FROM [ULTRA-GU\SQL2014].[master].[sys].[sysprocesses]
GO

--Usando Openquery
SELECT * 
FROM OPENQUERY ([ULTRA-GU\SQL2014],'SELECT GETDATE(), @@VERSION')
GO

--Usando Execute At
EXECUTE ( 'SELECT GETDATE(), @@VERSION' ) AT [ULTRA-GU\SQL2014];  
GO 
--RPC!


--DDL com Linked Server

--Usando Four-Part-Name (FQN) (não é possível)
CREATE TABLE .....???....
FROM [ULTRA-GU\SQL2014].[master].[sys].[databases] ??
GO

--Usando Openquery (não é possível)
SELECT * 
FROM OPENQUERY ([ULTRA-GU\SQL2014],'CREATE TABLE [AdventureWorks2014].[dbo].[TESTE] (codigo int)'
GO

--Usando Execute At
EXECUTE ( 'CREATE TABLE [AdventureWorks2014].[dbo].[TESTE] (codigo int)' ) AT [ULTRA-GU\SQL2014];  
GO 

EXECUTE ( 'SELECT * FROM [AdventureWorks2014].[dbo].[TESTE]' ) AT [ULTRA-GU\SQL2014];  
GO 


--Transação distribuída
--Usando Four-Part-Name (FQN) 
INSERT INTO [ULTRA-GU\SQL2014].[AdventureWorks2014].[dbo].[TESTE] VALUES (10)
GO
SELECT * FROM [ULTRA-GU\SQL2014].[AdventureWorks2014].[dbo].[TESTE]
GO

--Usando Openquery (não é possível)
SELECT * 
FROM OPENQUERY ([ULTRA-GU\SQL2014],'INSERT INTO [AdventureWorks2014].[dbo].[TESTE] VALUES (1)'
GO

--Usando Execute At
EXECUTE ( 'INSERT INTO [AdventureWorks2014].[dbo].[TESTE] VALUES (100)' ) AT [ULTRA-GU\SQL2014];  
GO 

EXECUTE ( 'SELECT * FROM [AdventureWorks2014].[dbo].[TESTE]' ) AT [ULTRA-GU\SQL2014];  
GO 

