USE AdventureWorks2019
GO

--View Simples
CREATE VIEW VW_Clientes_Australia AS
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (
						SELECT TerritoryID
						FROM Sales.SalesTerritory
						WHERE Name ='Australia'
					 )
GO

SELECT *
FROM VW_Clientes_Australia
GO


--Filtrando Views
SELECT *
FROM VW_Clientes_Australia
WHERE CustomerID BETWEEN 1 AND 100
GO


--View com Cláusula ORDER BY (*Error)
CREATE VIEW VW_Clientes_Australia_Ordenada AS
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN	(
							SELECT TerritoryID
							FROM Sales.SalesTerritory
							WHERE Name ='Australia'
						)
ORDER BY CustomerID
GO

CREATE VIEW VW_Clientes_Australia_Ordenada AS
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN	(
							SELECT TerritoryID
							FROM Sales.SalesTerritory
							WHERE Name ='Australia'
						)
GO


--View com SELECT *
CREATE VIEW VW_Clientes_Australia_All_Info AS
SELECT *
FROM Sales.Customer
WHERE TerritoryID IN (
						SELECT TerritoryID
						FROM Sales.SalesTerritory
						WHERE Name ='Australia'
					 )
GO

--Ordenando Dados Retornados pela View (OK)
SELECT *
FROM VW_Clientes_Australia_All_Info
ORDER BY CustomerID DESC
GO

--Atenção para views definidas com SELECT * !!!
ALTER TABLE Sales.Customer ADD Ind_Status bit NULL
GO

SELECT *
FROM Sales.Customer
GO

SELECT *
FROM VW_Clientes_Australia_All_Info
GO

EXEC SP_HELP 'VW_Clientes_Australia_All_Info'
GO

EXEC SP_HELPTEXT 'VW_Clientes_Australia_All_Info'
GO

--"Recompilar view"
EXEC SP_REFRESHVIEW VW_Clientes_Australia_All_Info
GO
--Ou executar ALTER VIEW com o mesmo código

EXEC SP_HELP 'VW_Clientes_Australia_All_Info'
GO
EXEC SP_HELPTEXT 'VW_Clientes_Australia_All_Info'
GO

SELECT *
FROM VW_Clientes_Australia_All_Info
GO





