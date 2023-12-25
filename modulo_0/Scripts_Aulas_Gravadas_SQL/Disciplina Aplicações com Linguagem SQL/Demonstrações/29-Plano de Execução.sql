USE AdventureWorks2017
GO

--Plano de Execução Estimado
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (9, 7);


--Plano de Execução Real (Atual)
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (9, 7);


--Plano de Execução com Sugestão de Índice
DROP INDEX [IX_Customer_TerritoryID] ON [Sales].[Customer];

SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (9, 7);


--Plano de Execução sem Índice Primário
--Gerar nova tabela
SELECT * 
INTO Sales.Customer_New
FROM Sales.Customer;

--Sem índices devido à criação com SELECT INTO
SP_HELP 'Sales.Customer_New';

SELECT CustomerID, AccountNumber
FROM Sales.Customer_New
WHERE TerritoryID IN (9, 7);

CREATE NONCLUSTERED INDEX [IX_Customer_TerritoryID] ON [Sales].[Customer_New]
(
	[TerritoryID]
);

SELECT TerritoryID
FROM Sales.Customer_New
WHERE TerritoryID IN (9, 7);
