USE AdventureWorks2019
GO

--UPDATE
SELECT * FROM dbo.TAB1
GO

UPDATE dbo.TAB1
SET COL2 = 'NÃO'
WHERE COL1 = 10
GO


--UPDATE SEM WHERE
UPDATE dbo.TAB1
SET COL2 = 'NÃO'
GO

SELECT * FROM dbo.TAB1
GO


--UPDATE COM JOIN
UPDATE dbo.TAB1 
SET COL2 = 'SIM'
FROM dbo.TAB1
JOIN dbo.TAB1_COPIA 
ON TAB1.COL1 = TAB1_COPIA.COL1
GO

SELECT * FROM dbo.TAB1
GO
SELECT * FROM dbo.TAB1_COPIA
GO

--UPDATE Referenciando Coluna de Outra Tabela
UPDATE dbo.TAB1 
SET dbo.TAB1.COL2 = dbo.TAB1_COPIA.COL2 
FROM dbo.TAB1
JOIN dbo.TAB1_COPIA 
ON TAB1.COL1 = TAB1_COPIA.COL1
GO

SELECT * FROM dbo.TAB1
GO
SELECT * FROM dbo.TAB1_COPIA
GO


--UPDATE com Função de Data/Hora + Operador Booleano
UPDATE dbo.TAB1
SET COL3 = GETDATE()
WHERE COL1 > 5 AND COL2 <> 'NÃO'
GO

SELECT * FROM dbo.TAB1
GO


UPDATE dbo.TAB1
SET COL3 = GETDATE()
WHERE COL1 > 5
AND (COL2 <> 'NÃO' OR COL2 IS NULL)
GO

SELECT * FROM dbo.TAB1;


--UPDATE em Mais de uma Coluna
UPDATE dbo.TAB1
SET COL2 = 'SIM', COL3 = GETDATE()
WHERE COL1 > 5
GO

SELECT * FROM dbo.TAB1
GO


--UPDATE com Expressão na Cláusula SET
SELECT *
FROM Production.Product
WHERE SellEndDate IS NULL
AND ListPrice <> 0.00
GO

UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
WHERE SellEndDate IS NULL
AND ListPrice <> 0.00
GO


--UPDATE com Funções de Caracteres
SELECT * FROM Person.Person
GO

UPDATE Person.Person
SET Title = UPPER(Title), FirstName = UPPER (FirstName), 
	MiddleName = UPPER (MiddleName), LastName = UPPER (LastName)
GO


--UPDATE com DEFAULT
EXEC SP_HELP 'dbo.TAB1'
GO

SELECT * FROM dbo.TAB1
GO

UPDATE dbo.TAB1
SET COL2 = DEFAULT
GO


--UPDATE com CASE
--UPDATE com OUTPUT dos valores alterados ("backup dos valores antigos")
--COPY WITH HEADERS
UPDATE HumanResources.Employee  
SET VacationHours =   
    ( CASE  
         WHEN ((VacationHours - 10.00) < 0) THEN VacationHours + 40  
         ELSE (VacationHours + 20.00)  
       END  
    )  
OUTPUT Deleted.BusinessEntityID, Deleted.VacationHours AS BeforeValue,   
       Inserted.VacationHours AS AfterValue  
WHERE SalariedFlag = 0
GO


--UPDATE COM INTERFACE GRÁFICA DO CLIENT