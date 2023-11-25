USE AdventureWorks2017
GO

--Valor Total de Vendas Por Dia em 2013
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_Diário_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY OrderDate
ORDER BY 1 ASC;

--Valor Total de Vendas Por Mês em 2013
SELECT MONTH(OrderDate) AS Mês_da_Venda, SUM(TotalDue) AS Valor_Total_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY MONTH(OrderDate)
ORDER BY 1 ASC;


--Filtrando com Having os dias com vendas superiores a 4 milhões, no ano de 2013
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_Diário_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY OrderDate
HAVING SUM(TotalDue)>4000000
ORDER BY 1 ASC;


--Quantidade de Vendas por Funcionário com ID maior que 280
--Sem Função de Agregação na cláusula HAVING
--HAVING atuando como WHERE
SELECT SalesPersonID AS ID_do_Vendedor, COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
HAVING SalesPersonID > 280
ORDER BY 2 DESC;

--Lembrar que o WHERE limita as linhas passadas para o GROUP BY, podendo reduzir a quantidade de grupos a serem formados
--Nesse exemplo, como a coluna no WHERE/HAVING e GROUP BY é a mesma, fica semelhante a HAVING SalesPersonID > 280
--Resultado igual ao acima
SELECT SalesPersonID AS ID_do_Vendedor, COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
WHERE SalesPersonID > 280
GROUP BY SalesPersonID
ORDER BY 2 DESC;



--Clientes que Fizeram mais de 10 compras em 2013:
--HAVING + WHERE
SELECT CustomerID AS ID_do_Cliente, COUNT(SalesOrderID) AS Total_de_Compras
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 10
ORDER BY COUNT(SalesOrderID) DESC


--Colunas na Cláusula HAVING
SELECT CustomerID AS ID_do_Cliente, COUNT(SalesOrderID) AS Total_de_Compras
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY CustomerID
HAVING SalesOrderID > 10
--HAVING CustomerID > 10
--HAVING COUNT(SalesOrderID) > 10
ORDER BY COUNT(SalesOrderID) DESC


--Clientes que Fizeram mais de 10 compras em 2013:
--Alias não permitido no HAVING
SELECT CustomerID AS ID_do_Cliente, COUNT(SalesOrderID) AS Total_de_Compras
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY CustomerID
HAVING Total_de_Compras > 10
ORDER BY COUNT(SalesOrderID) DESC