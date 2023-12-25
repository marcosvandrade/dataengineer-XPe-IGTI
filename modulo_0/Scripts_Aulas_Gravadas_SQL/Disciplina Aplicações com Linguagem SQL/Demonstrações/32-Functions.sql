USE AdventureWorks2019
GO

--Função ESCALAR
CREATE FUNCTION dbo.ISOweek (@DATE datetime)
RETURNS int
AS
BEGIN
    DECLARE @ISOweek int;
    SET @ISOweek= DATEPART(wk,@DATE)+1
        -DATEPART(wk,CAST(DATEPART(yy,@DATE) as CHAR(4))+'0104')
--Special cases: Jan 1-3 may belong to the previous year
    IF (@ISOweek=0)
        SET @ISOweek=dbo.ISOweek(CAST(DATEPART(yy,@DATE)-1
            AS CHAR(4))+'12'+ CAST(24+DATEPART(DAY,@DATE) AS CHAR(2)))+1
--Special case: Dec 29-31 may belong to the next year
    IF ((DATEPART(mm,@DATE)=12) AND
        ((DATEPART(dd,@DATE)-DATEPART(dw,@DATE))>= 28))
    SET @ISOweek=1
    RETURN(@ISOweek)
END
GO

SELECT dbo.ISOweek(CONVERT(DATETIME,'12/26/2019',101)) AS 'ISO Week'
GO


--Função Escalar para retornar a data e horário de start do SQL Server
CREATE FUNCTION dbo.fn_sql_start_Time (@DATE datetime)
RETURNS datetime
AS
BEGIN
	DECLARE @start datetime
    SELECT @start = sqlserver_start_time FROM sys.dm_os_sys_info
	--SELECT create_date  AS SQLServerStartTime FROM sys.databases WHERE name = 'tempdb';
	RETURN(@start)
END
GO

SELECT dbo.fn_sql_start_Time ('') AS 'SQL Server start time'
GO



--Função multivalorada (TABLE VALUED FUNCTION)
CREATE FUNCTION Production.TopNProdutos (@qtde AS INT)
RETURNS TABLE AS
RETURN	(	SELECT TOP (@qtde) productid, name, ListPrice
			FROM Production.Product
			ORDER BY ListPrice DESC
		)
GO

SELECT * FROM Production.TopNProdutos(3)
GO



--Cursor
USE AdventureWorks2019;  
GO  

DECLARE contact_cursor CURSOR FOR  
SELECT DISTINCT LastName FROM Person.Person  
WHERE LastName LIKE 'Bar%'  
ORDER BY LastName 
  
OPEN contact_cursor 
  
--Faz a primeira recuperação de uma linha que está no cursor  
FETCH NEXT FROM contact_cursor  
  
--Enquanto existirem mais linhas para serem buscadas do cursor
WHILE @@FETCH_STATUS = 0  --(0 -> instrução FETCH foi bem sucedida, ou seja, retornou linha)
BEGIN  
   --Busca a próxima linha no cursor 
   FETCH NEXT FROM contact_cursor
END  
  
CLOSE contact_cursor  
DEALLOCATE contact_cursor 
GO