USE AdventureWorks2019
GO

--Retornar os itens vendidos na última venda realizada
--Subconsulta independente
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID =	(	SELECT MAX(SalesOrderID) AS Última_Venda
							FROM Sales.SalesOrderHeader
						)
GO

--Na prática:
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID =75123
GO


--Retornar todos os itens vendidos,exceto os da última venda realizada
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID !=	(	SELECT MAX(SalesOrderID) AS Última_Venda
							FROM Sales.SalesOrderHeader
						)
GO


--Erro de Subconsulta retornando mais de um valor
--(Operadores =, !=, <, <=, > e >=)
SELECT SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, LineTotal
FROM Sales.SalesOrderDetail 
WHERE SalesOrderID =	(	SELECT TOP(5) SalesOrderID AS Últimas_Cinco_Vendas
							FROM Sales.SalesOrderHeader
							ORDER BY SalesOrderID DESC
						)
GO


--Subconsulta Escalar com HAVING
--Vendas diárias de 2013 com valores inferiores à média de vendas do ano anterior
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_Diário_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY OrderDate
HAVING SUM(TotalDue) < (
							SELECT AVG(TotalDue) 
							FROM Sales.SalesOrderHeader --*Subconsulta recursiva
							WHERE YEAR(OrderDate)='2012'							
						)
ORDER BY 1 ASC;
