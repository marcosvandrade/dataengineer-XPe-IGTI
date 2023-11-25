USE [master]
GO
RESTORE DATABASE [AdventureWorks2017] 
FROM  DISK = N'F:\Universidade\IGTI\Aplicações com Linguagem SQL - SQL192A\Softwares, Bancos e Scripts\AdventureWorks2017.bak' 
WITH  FILE = 1,  
MOVE N'AdventureWorks2017' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks2017.mdf',  
MOVE N'AdventureWorks2017_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AdventureWorks2017_log.ldf',  
NOUNLOAD,  STATS = 5
GO


