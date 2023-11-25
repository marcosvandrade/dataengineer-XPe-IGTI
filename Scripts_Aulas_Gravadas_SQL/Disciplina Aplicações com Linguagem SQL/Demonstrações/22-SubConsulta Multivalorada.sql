USE AdventureWorks2019
GO

--Subconsulta Multivalorada
--Subconsulta Independente
--Identifica��o e N�mero da Conta dos Clientes da Austr�lia e Fran�a
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID IN (
						SELECT TerritoryID
						FROM Sales.SalesTerritory
						WHERE Name ='Australia' OR Name = 'France'
					  );

--Evitar Subconsulta Multivalorada que tenha o mesmo prop�sito de um join
--*Join mais perform�tico
SELECT C.CustomerID, C.AccountNumber
FROM Sales.Customer C
JOIN Sales.SalesTerritory T
ON C.TerritoryID  = T.TerritoryID
WHERE T.Name ='Australia' OR T.Name = 'France'


--Identifica��o e N�mero da Conta dos Clientes que N�O S�O da Austr�lia e Fran�a
--NOT IN
SELECT CustomerID, AccountNumber
FROM Sales.Customer
WHERE TerritoryID NOT IN (
						SELECT TerritoryID
						FROM Sales.SalesTerritory
						WHERE Name ='Australia' OR Name = 'France'
					  );


--Subconsulta Multivalorada com HAVING
--Subconsulta Independente
--Venda dos dias, no ano de 2013, que no ano anterior foram os 5 dias com maior valor de vendas
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_Di�rio_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY OrderDate
HAVING CAST (DAY(OrderDate) AS VARCHAR(2)) + '-' + CAST(MONTH(OrderDate) AS VARCHAR(2))
IN (
							SELECT TOP (5) CAST (DAY(OrderDate) AS VARCHAR(2)) + '-' + CAST(MONTH(OrderDate) AS VARCHAR(2))
							FROM Sales.SalesOrderHeader
							WHERE YEAR(OrderDate)='2012'							
							GROUP BY OrderDate
							ORDER BY SUM(TotalDue) DESC
						)
ORDER BY 1 ASC;


