USE AdventureWorks2019
GO

--AutoCommit (DEFAULT)
CREATE TABLE TRAN1 (COD int)
GO

INSERT INTO TRAN1
VALUES (1)
GO

SELECT * FROM TRAN1
GO
--Mesmo SELECT em outra sess�o


--Transa��o Impl�cita
--SSMS: Tools �> Options -> Query Execution �> SQL Server �> ANSI -> SET IMPLICIT_TRANSACTIONS
--T-SQL: SET IMPLICIT_TRANSACTIONS ON
SET IMPLICIT_TRANSACTIONS ON
GO

INSERT INTO TRAN1
VALUES (2)
GO

SELECT * FROM TRAN1
GO
--Mesmo SELECT em outra sess�o: bloqueada -> transa��o aberta implicitamente, mas n�o confirmada ainda

--Em Outra Sess�o: Listar Processos Bloqueados e os Bloqueadores
select sp.waittime,sp.lastwaittype,hostname,db_name(sp.dbid) as DBName, cmd,st.Text,
(select substring(text, stmt_start/2, 
  (case when stmt_end = -1 then len(convert(nvarchar(max),text))*2
   ELSE stmt_end end - stmt_start)/2)
 from sys.dm_exec_sql_text(sql_handle)
 ) as inside_query_text, sp.*
from sys.sysprocesses sp 
CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) as st
where sp.blocked <> 0
OR (sp.spid in (select blocked from sys.sysprocesses) and sp.blocked = 0)
order by sp.waittime desc
GO

--Efetivando uma Transa��o Aberta Implicitamente
COMMIT
GO
--Ver a Outra Sess�o



--Desativar Abertura de Transa��o Impl�cita
SET IMPLICIT_TRANSACTIONS OFF
GO


--Abertura de Transa��o Expl�cita
BEGIN TRANSACTION

	INSERT INTO TRAN1
	VALUES (3)
GO

--Listar Sess�es com Transa��o Aberta
select sp.waittime,sp.lastwaittype,hostname,db_name(sp.dbid) as DBName, cmd,st.Text,
(select substring(text, stmt_start/2, 
  (case when stmt_end = -1 then len(convert(nvarchar(max),text))*2
   ELSE stmt_end end - stmt_start)/2)
 from sys.dm_exec_sql_text(sql_handle)
 ) as inside_query_text, sp.*
from sys.sysprocesses sp 
CROSS APPLY sys.dm_exec_sql_text(sp.sql_handle) as st
where sp.open_tran > 0
order by sp.waittime desc
GO


--SELECT de Dentro da Transa��o 
SELECT * FROM TRAN1
GO

--SELECT de Outra Sess�o
SELECT * FROM TRAN1
GO

--Efetivando uma Transa��o Aberta Implicitamente
COMMIT
GO
--Ver a Outra Sess�o



--Rollback de Transa��o DML Aberta Explicitamente
BEGIN TRANSACTION

	INSERT INTO TRAN1
	VALUES (5)
GO

--SELECT de Dentro da Transa��o 
SELECT * FROM TRAN1
GO

--SELECT de Outra Sess�o
SELECT * FROM TRAN1
GO

--Desfazendo uma Transa��o Aberta Implicitamente
ROLLBACK
GO
--Ver a Outra Sess�o



--Transa��o com Comandos DDL
BEGIN TRANSACTION
	CREATE TABLE TRAN2 (CODIGO int)
GO

--Listar Sess�es com Transa��o Aberta

--SELECT de Dentro da Transa��o 
SELECT * FROM TRAN2
GO

--SELECT de Outra Sess�o (Objeto J� Consta no Cat�logo, mas n�o est� efetivamente liberado para uso)
SELECT * FROM TRAN2
GO

--Efetivando uma Transa��o Aberta Implicitamente
COMMIT
GO
--Ver a Outra Sess�o




--Transa��o com Comandos DDL + ROLLBACK
BEGIN TRANSACTION
	CREATE TABLE TRAN3 (CODIGO int)
GO

--Listar Sess�es com Transa��o Aberta

--SELECT de Dentro da Transa��o 
SELECT * FROM TRAN3
GO

--SELECT de Outra Sess�o (Objeto J� Consta no Cat�logo, mas n�o est� efetivamente liberado para uso)
SELECT * FROM TRAN3
GO

--N�o liberada, inclusive no dicion�rio de dados
SELECT *
FROM sys.objects
WHERE name = 'TRAN3'


--Desfazer uma Transa��o Aberta Implicitamente (Desfaz a cria��o da tabela)
ROLLBACK
GO
--Ver a Outra Sess�o



--Transa��o Nomeada + Transa��o Aninhada
CREATE TABLE TRAN4 (CODIGO int)
GO

SELECT * FROM TRAN4
GO

BEGIN TRANSACTION Transacao1
	
	--Verificar quantidade de transa��es abertas
	SELECT @@TRANCOUNT
	GO

	INSERT INTO TRAN4
	VALUES (1)
	GO

	SELECT * FROM TRAN4
	GO

	BEGIN TRANSACTION Transacao2  
	--Listar Sess�es com Transa��o Aberta
	--Verificar quantidade de transa��es abertas
	SELECT @@TRANCOUNT
	GO

		INSERT INTO TRAN4
		VALUES (2)
		GO

		SELECT * FROM TRAN4
		GO

	COMMIT TRANSACTION Transacao2
	GO

	--Verificar quantidade de transa��es abertas
	SELECT @@TRANCOUNT
	GO
		  
COMMIT TRANSACTION Transacao1
GO

--Verificar quantidade de transa��es abertas
SELECT @@TRANCOUNT
GO



--Transa��o Nomeadas Aninhadas x Rollback
CREATE TABLE TRAN5 (CODIGO int)
GO

SELECT * FROM TRAN5
GO

BEGIN TRANSACTION Transacao1
GO
	
	--Verificar quantidade de transa��es abertas
	SELECT @@TRANCOUNT
	GO

	INSERT INTO TRAN5
	VALUES (1)
	GO

	SELECT * FROM TRAN5
	GO

	BEGIN TRANSACTION Transacao2
	GO
	--Listar Sess�es com Transa��o Aberta
	--Verificar quantidade de transa��es abertas
	SELECT @@TRANCOUNT
	GO

		INSERT INTO TRAN5
		VALUES (2)
		GO

		SELECT * FROM TRAN5
		GO

	ROLLBACK TRANSACTION Transacao2  --Error
	GO

	ROLLBACK  --Desfaz todas as transa��es
	GO

	--Verificar quantidade de transa��es abertas
	SELECT @@TRANCOUNT
	GO
		  
COMMIT TRANSACTION Transacao1  --Error
GO


--TRY / CATCH

BEGIN TRY  
    -- Gerar erro de divis�o por zero
    SELECT 1/0 
END TRY  
BEGIN CATCH  
    -- Query a ser executada quanto houver erro no TRY
	SELECT  ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage    
END CATCH
GO

--Erro de resolu��o de nome n�o tratado no TRY / CATCH
BEGIN TRY  
    SELECT * FROM TabelaInexistente  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber,
		ERROR_MESSAGE() AS ErrorMessage 
END CATCH 
GO

--TRY / CATCH com transa��o
BEGIN TRANSACTION  
  
BEGIN TRY  
    --For�ar um erro (viola��o de constraint) 
    DELETE FROM Production.Product  
    WHERE ProductID = 980  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
  
	PRINT 'Quantidade de transa��es: ' + CAST (@@TRANCOUNT AS VARCHAR)
    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION
END CATCH

PRINT 'Quantidade de transa��es: ' + CAST (@@TRANCOUNT AS VARCHAR)
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION
GO 

--Sem acionar o CATCH
--Usando [Production].[Gloves]  
BEGIN TRANSACTION  
  
BEGIN TRY  
    --Sem for�ar erro de viola��o de constraint
    DELETE FROM [Production].[Gloves]       
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
  
	PRINT 'Quantidade de transa��es: ' + CAST (@@TRANCOUNT AS VARCHAR)
    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION
END CATCH

PRINT 'Quantidade de transa��es: ' + CAST (@@TRANCOUNT AS VARCHAR)
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION
GO 