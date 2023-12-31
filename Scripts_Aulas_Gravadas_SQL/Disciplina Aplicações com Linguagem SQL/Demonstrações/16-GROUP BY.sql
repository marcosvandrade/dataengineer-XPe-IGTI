USE AdventureWorks2019
GO

--Agrupar Quantidade de Vendas por Funcion�rio
SELECT SalesPersonID AS ID_do_Vendedor, COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
ORDER BY 2 DESC;

--Agrupar Quantidade de Vendas dos Funcion�rio por Dia (N�o OK - Coluna n�o definida no agrupamento)
SELECT  SalesPersonID AS ID_do_Vendedor, OrderDate AS Data_da_Venda,
		COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID
ORDER BY OrderDate DESC;

--Agrupar Quantidade de Vendas dos Funcion�rio por Dia (OK)
SELECT  SalesPersonID AS ID_do_Vendedor, OrderDate AS Data_da_Venda,
		COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID, OrderDate
ORDER BY OrderDate DESC;


--Fun��o de Agrega��o x Outras Fun��es no SELECT
--Agrupar Quantidade de Vendas dos Funcion�rio por Ano (N�o OK - coluna com fun��o de data n�o definida no agrupamento)
SELECT  SalesPersonID AS ID_do_Vendedor, YEAR(OrderDate) AS Ano_da_Venda,
		COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
ORDER BY YEAR(OrderDate) DESC;

--Agrupar Quantidade de Vendas dos Funcion�rio por Ano (OK)
SELECT  SalesPersonID AS ID_do_Vendedor, YEAR(OrderDate) AS Ano_da_Venda,
		COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID, YEAR(OrderDate)
ORDER BY YEAR(OrderDate) DESC;


--Alias no Group By
--Valor Total de Vendas Por Dia
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_de_Vendas
FROM Sales.SalesOrderHeader
GROUP BY Data_da_Venda
ORDER BY 1 ASC;

--Valor Total de Vendas Por Dia (OK)
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_de_Vendas
FROM Sales.SalesOrderHeader
GROUP BY OrderDate
ORDER BY 1 ASC;




---FILTRANDO AGRUPAMENTOS

--Valor Total de Vendas Por Dia em 2013
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_Di�rio_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY OrderDate
ORDER BY 1 ASC;

--Valor Total de Vendas Por M�s em 2013
SELECT MONTH(OrderDate) AS M�s_da_Venda, SUM(TotalDue) AS Valor_Total_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY MONTH(OrderDate)
ORDER BY 1 ASC;


--Filtrando com Having os dias com vendas superiores a 4 milh�es, no ano de 2013
SELECT OrderDate AS Data_da_Venda, SUM(TotalDue) AS Valor_Total_Di�rio_de_Vendas
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY OrderDate
HAVING SUM(TotalDue)>4000000
ORDER BY 1 ASC;


--Quantidade de Vendas por Funcion�rio com ID maior que 280
--Sem Fun��o de Agrega��o na cl�usula HAVING
--HAVING atuando como WHERE
SELECT SalesPersonID AS ID_do_Vendedor, COUNT(SalesOrderID) AS Total_de_Vendas
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
HAVING SalesPersonID > 280
ORDER BY 2 DESC;

--Lembrar que o WHERE limita as linhas passadas para o GROUP BY, podendo reduzir a quantidade de grupos a serem formados
--Nesse exemplo, como a coluna no WHERE/HAVING e GROUP BY � a mesma, fica semelhante a HAVING SalesPersonID > 280
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


--Colunas na Cl�usula HAVING
SELECT CustomerID AS ID_do_Cliente, COUNT(SalesOrderID) AS Total_de_Compras
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY CustomerID
HAVING SalesOrderID > 10
--HAVING CustomerID > 10
--HAVING COUNT(SalesOrderID) > 10
ORDER BY COUNT(SalesOrderID) DESC


--Clientes que Fizeram mais de 10 compras em 2013:
--Alias n�o permitido no HAVING
SELECT CustomerID AS ID_do_Cliente, COUNT(SalesOrderID) AS Total_de_Compras
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate)='2013'
GROUP BY CustomerID
HAVING Total_de_Compras > 10
ORDER BY COUNT(SalesOrderID) DESC