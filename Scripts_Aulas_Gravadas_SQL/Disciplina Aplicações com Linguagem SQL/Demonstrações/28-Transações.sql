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
--Mesmo SELECT em outra sessão


--Transação Implícita
--SSMS: Tools –> Options -> Query Execution –> SQL Server –> ANSI -> SET IMPLICIT_TRANSACTIONS
--T-SQL: SET IMPLICIT_TRANSACTIONS ON
SET IMPLICIT_TRANSACTIONS ON
GO

INSERT INTO TRAN1
VALUES (2)
GO

SELECT * FROM TRAN1
GO
--Mesmo SELECT em outra sessão: bloqueada -> transação aberta implicitamente, mas não confirmada ainda

--Em Outra Sessão: Listar Processos Bloqueados e os Bloqueadores
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

--Efetivando uma Transação Aberta Implicitamente
COMMIT
GO
--Ver a Outra Sessão



--Desativar Abertura de Transação Implícita
SET IMPLICIT_TRANSACTIONS OFF
GO


--Abertura de Transação Explícita
BEGIN TRANSACTION

	INSERT INTO TRAN1
	VALUES (3)
GO

--Listar Sessões com Transação Aberta
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


--SELECT de Dentro da Transação 
SELECT * FROM TRAN1
GO

--SELECT de Outra Sessão
SELECT * FROM TRAN1
GO

--Efetivando uma Transação Aberta Implicitamente
COMMIT
GO
--Ver a Outra Sessão



--Rollback de Transação DML Aberta Explicitamente
BEGIN TRANSACTION

	INSERT INTO TRAN1
	VALUES (5)
GO

--SELECT de Dentro da Transação 
SELECT * FROM TRAN1
GO

--SELECT de Outra Sessão
SELECT * FROM TRAN1
GO

--Desfazendo uma Transação Aberta Implicitamente
ROLLBACK
GO
--Ver a Outra Sessão



--Transação com Comandos DDL
BEGIN TRANSACTION
	CREATE TABLE TRAN2 (CODIGO int)
GO

--Listar Sessões com Transação Aberta

--SELECT de Dentro da Transação 
SELECT * FROM TRAN2
GO

--SELECT de Outra Sessão (Objeto Já Consta no Catálogo, mas não está efetivamente liberado para uso)
SELECT * FROM TRAN2
GO

--Efetivando uma Transação Aberta Implicitamente
COMMIT
GO
--Ver a Outra Sessão




--Transação com Comandos DDL + ROLLBACK
BEGIN TRANSACTION
	CREATE TABLE TRAN3 (CODIGO int)
GO

--Listar Sessões com Transação Aberta

--SELECT de Dentro da Transação 
SELECT * FROM TRAN3
GO

--SELECT de Outra Sessão (Objeto Já Consta no Catálogo, mas não está efetivamente liberado para uso)
SELECT * FROM TRAN3
GO

--Não liberada, inclusive no dicionário de dados
SELECT *
FROM sys.objects
WHERE name = 'TRAN3'


--Desfazer uma Transação Aberta Implicitamente (Desfaz a criação da tabela)
ROLLBACK
GO
--Ver a Outra Sessão



--Transação Nomeada + Transação Aninhada
CREATE TABLE TRAN4 (CODIGO int)
GO

SELECT * FROM TRAN4
GO

BEGIN TRANSACTION Transacao1
	
	--Verificar quantidade de transações abertas
	SELECT @@TRANCOUNT
	GO

	INSERT INTO TRAN4
	VALUES (1)
	GO

	SELECT * FROM TRAN4
	GO

	BEGIN TRANSACTION Transacao2  
	--Listar Sessões com Transação Aberta
	--Verificar quantidade de transações abertas
	SELECT @@TRANCOUNT
	GO

		INSERT INTO TRAN4
		VALUES (2)
		GO

		SELECT * FROM TRAN4
		GO

	COMMIT TRANSACTION Transacao2
	GO

	--Verificar quantidade de transações abertas
	SELECT @@TRANCOUNT
	GO
		  
COMMIT TRANSACTION Transacao1
GO

--Verificar quantidade de transações abertas
SELECT @@TRANCOUNT
GO



--Transação Nomeadas Aninhadas x Rollback
CREATE TABLE TRAN5 (CODIGO int)
GO

SELECT * FROM TRAN5
GO

BEGIN TRANSACTION Transacao1
GO
	
	--Verificar quantidade de transações abertas
	SELECT @@TRANCOUNT
	GO

	INSERT INTO TRAN5
	VALUES (1)
	GO

	SELECT * FROM TRAN5
	GO

	BEGIN TRANSACTION Transacao2
	GO
	--Listar Sessões com Transação Aberta
	--Verificar quantidade de transações abertas
	SELECT @@TRANCOUNT
	GO

		INSERT INTO TRAN5
		VALUES (2)
		GO

		SELECT * FROM TRAN5
		GO

	ROLLBACK TRANSACTION Transacao2  --Error
	GO

	ROLLBACK  --Desfaz todas as transações
	GO

	--Verificar quantidade de transações abertas
	SELECT @@TRANCOUNT
	GO
		  
COMMIT TRANSACTION Transacao1  --Error
GO


--TRY / CATCH

BEGIN TRY  
    -- Gerar erro de divisão por zero
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

--Erro de resolução de nome não tratado no TRY / CATCH
BEGIN TRY  
    SELECT * FROM TabelaInexistente  
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber,
		ERROR_MESSAGE() AS ErrorMessage 
END CATCH 
GO

--TRY / CATCH com transação
BEGIN TRANSACTION  
  
BEGIN TRY  
    --Forçar um erro (violação de constraint) 
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
  
	PRINT 'Quantidade de transações: ' + CAST (@@TRANCOUNT AS VARCHAR)
    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION
END CATCH

PRINT 'Quantidade de transações: ' + CAST (@@TRANCOUNT AS VARCHAR)
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION
GO 

--Sem acionar o CATCH
--Usando [Production].[Gloves]  
BEGIN TRANSACTION  
  
BEGIN TRY  
    --Sem forçar erro de violação de constraint
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
  
	PRINT 'Quantidade de transações: ' + CAST (@@TRANCOUNT AS VARCHAR)
    IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION
END CATCH

PRINT 'Quantidade de transações: ' + CAST (@@TRANCOUNT AS VARCHAR)
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION
GO 