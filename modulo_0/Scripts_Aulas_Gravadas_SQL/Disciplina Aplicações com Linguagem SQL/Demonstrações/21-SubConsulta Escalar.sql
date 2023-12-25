USE AdventureWorks2019
GO

--Retornar os itens vendidos na �ltima venda realizada
--Subconsulta independente
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID =	(	SELECT MAX(SalesOrderID) AS �ltima_Venda
							FROM Sales.SalesOrderHeader
						)
GO

--Na pr�tica:
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID =75123
GO


--Retornar todos os itens vendidos,exceto os da �ltima venda realizada
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID !=	(	SELECT MAX(SalesOrderID) AS �ltima_Venda
							FROM Sales.SalesOrderHeader
						)
GO


--Erro de Subconsulta retornando mais de um valor
--(Operadores =, !=, <, <=, > e >=)
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID =	(	SELECT TOP(5) SalesOrderID AS �ltimas_Cinco_Vendas
							FROM Sales.SalesOrderHeader
							ORDER BY SalesOrderID DESC
						)
GO


--Subconsulta Escalar com HAVING
--Vendas di�rias de 2013 com valores inferiores � m�dia de vendas do ano anterior
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_Di�rio_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY OrderDate
HAVING SUM(TotalDue) < (
							SELECT AVG(TotalDue) 
							FROM Sales.SalesOrderHeader --*Subconsulta recursiva
							WHERE YEAR(OrderDate)='2012'							
						)
ORDER BY 1 ASC;
