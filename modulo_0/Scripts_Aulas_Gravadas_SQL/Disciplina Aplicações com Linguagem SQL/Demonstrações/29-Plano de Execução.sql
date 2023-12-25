USE AdventureWorks2017
GO

--Plano de Execu��o Estimado
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (9, 7);


--Plano de Execu��o Real (Atual)
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (9, 7);


--Plano de Execu��o com Sugest�o de �ndice
DROP INDEX [IX_Customer_TerritoryID] ON [Sales].[Customer];

SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (9, 7);


--Plano de Execu��o sem �ndice Prim�rio
--Gerar nova tabela
SELECT * 
INTO Sales.Customer_New
FROM Sales.Customer;

--Sem �ndices devido � cria��o com SELECT INTO
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
