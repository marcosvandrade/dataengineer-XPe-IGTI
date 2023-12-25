USE AdventureWorks2019
GO

--Procedure sem par�metros
CREATE PROCEDURE SP_Clientes_Australia AS
BEGIN
	SELECT CustomerID, AccountNumber
	FROM Sales.Customer
	WHERE TerritoryID IN (
							SELECT TerritoryID
							FROM Sales.SalesTerritory
							WHERE Name ='Australia'
						 )
	ORDER BY CustomerID DESC
END;
GO

EXEC SP_Clientes_Australia;
GO



--Procedure com par�metros
CREATE PROCEDURE SP_Insere_Departamento 
--Par�metros de entrada e seus tipos de dados
	--@DepartmentID smallint ==> n�o � necess�rio pois a coluna � do tipo IDENTITY
	@Name nvarchar(50),
	@GroupName nvarchar(50)
	--@ModifiedDate datetime ==> possui um default que recuperada getdate()
AS
BEGIN
	--Exibindo no output os valores que ser�o inseridos
	PRINT @Name + ' ' + @GroupName;

	--Inserindo os valores dos par�metros de entrada na tabela
	INSERT INTO HumanResources.Department
	VALUES (@NAme, @GroupName, DEFAULT);
END;
GO

EXEC SP_Insere_Departamento @Name='EAD', @GroupName='Ensino'
GO


--IF / ELSE  (SE / ENT�O)
IF 1=1 
	PRINT 'Verdadeiro'
ELSE
	PRINT 'Falso'
GO

--IF COM SELECT
IF EXISTS (SELECT * FROM HumanResources.Department WHERE Name = 'EAD')
	PRINT 'Registro encontrado'
ELSE
	PRINT 'Registro n�o encontrado'
GO

--IF COM COMANDOS DDL
IF OBJECT_ID ( 'SP_Clientes_Australia', 'P' ) IS NOT NULL   
    DROP PROCEDURE SP_Clientes_Australia
ELSE 
	PRINT 'Objeto inexistente'
GO


--DECLARA��O DE VARI�VEL
DECLARE @VariavelNome varchar(100)
SET @VariavelNome = 'Bootcamp IGTI - Analista de Banco de Dados'
PRINT @VariavelNome
GO


--WHILE
DECLARE @Variavel1 INT
SET @Variavel1 = 0

WHILE @Variavel1 <= 10
BEGIN
	PRINT @Variavel1
	SET @Variavel1 = @Variavel1 + 1
END 
GO


--LOOP INFINITO
DECLARE @Variavel1 INT
SET @Variavel1 = 1

WHILE 1 = 1 OR 1 > 0
BEGIN
	PRINT @Variavel1
	SET @Variavel1 = @Variavel1 + 1
END 
GO


--TRY / CATCH com procedures
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

--Erro de resolu��o de nome tratado no TRY / CATCH
--Erro ocorre em n�vel diferente do TRY / CATCH
CREATE PROCEDURE usp_procteste  
AS  
    SELECT * FROM TabelaInexistente;  
GO  
  
BEGIN TRY  
    EXECUTE usp_procteste
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_NUMBER() AS ErrorNumber,
		ERROR_MESSAGE() AS ErrorMessage  
END CATCH
GO

