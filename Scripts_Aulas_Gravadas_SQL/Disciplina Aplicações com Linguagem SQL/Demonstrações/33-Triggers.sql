USE AdventureWorks2019
GO

CREATE TRIGGER trg_lembrete ON Sales.Customer  
AFTER INSERT, UPDATE   
AS PRINT 'Notify Customer Relations'  
GO 

INSERT INTO [Sales].[Customer]
           ([PersonID]
           ,[StoreID]
           ,[TerritoryID]
           ,[rowguid]
           ,[ModifiedDate])
     VALUES (10, 500, 1, DEFAULT, GETDATE())
GO


--Trigger para evitar que funcion�rios sejam exclu�dos
CREATE TRIGGER [HumanResources].[dEmployee] ON [HumanResources].[Employee] 
INSTEAD OF DELETE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN
        RAISERROR
            (N'Employees cannot be deleted. They can only be marked as not current.', -- Message
            10, -- Severity.
            1); -- State.

        -- Rollback any active or uncommittable transactions
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END;
END;
GO

DELETE 
FROM [HumanResources].[Employee]
WHERE BusinessEntityID = 290
GO


--DDL Trigger no escopo do banco de dados para evitar que um sin�nimo seja removido
CREATE TRIGGER trg_no_drop_synonym  ON DATABASE   
FOR DROP_SYNONYM  
AS   
IF (@@ROWCOUNT = 0)
RETURN;
   RAISERROR ('Voc� n�o pode remover sin�nimos. Contate o DBA!', 10, 1)  
   ROLLBACK  
GO  

CREATE SYNONYM Funcionario FOR [HumanResources].[Employee]
GO

DROP SYNONYM Funcionario
GO

DROP TRIGGER trg_no_drop_synonym  
ON DATABASE
GO  

DROP SYNONYM Funcionario
GO


--Trigger no escopo da inst�ncia, que recupera comando usado para criar o banco
CREATE TRIGGER ddl_trig_database   
ON ALL SERVER   
FOR CREATE_DATABASE   
AS   
    PRINT 'Database Created.'  
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')  
GO  

--Criar banco para testar a trigger
CREATE DATABASE TESTE
GO
--Extrair script completo
--Apagar o banco
DROP DATABASE TESTE
GO
--Criar banco com script completo (par�metros default)

--Excluir a trigger
DROP TRIGGER ddl_trig_database  
ON ALL SERVER
GO


--Trigger de Logon que nega a abertura da conex�o se j� tiver uma sess�o aberta
--para um determinado usu�rio
USE master
GO  
CREATE LOGIN usrteste WITH PASSWORD = '123'
GO  
GRANT VIEW SERVER STATE TO usrteste
GO  

--Logar com usu�rio SQL Authentication
--Alterar o modo de autentica��o do SQL

CREATE TRIGGER trg_limitar_conexoes ON ALL SERVER 
FOR LOGON  AS  
BEGIN  
IF	ORIGINAL_LOGIN()= 'usrteste' AND  APP_NAME() LIKE 'Microsoft SQL Server Management Studio%'
	BEGIN
		PRINT 'N�o � permitido logar com este usu�rio diretamente pelo Management Studio';
		ROLLBACK;
	END
END
GO


--Listar as sess�es do usu�rio
SELECT * FROM sysprocesses
WHERE loginame = 'usrteste'

--Desabilitar trigger
DISABLE TRIGGER trg_limitar_conexoes ON ALL SERVER 
GO






