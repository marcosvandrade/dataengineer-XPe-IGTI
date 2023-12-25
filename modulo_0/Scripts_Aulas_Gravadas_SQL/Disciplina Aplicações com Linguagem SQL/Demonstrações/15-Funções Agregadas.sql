USE AdventureWorks2019
GO

--Funções MIN e MAX com Colunas Numéricas
SELECT MIN(UnitPrice) AS Preço_Mínimo, MAX(UnitPrice) AS Preço_Máximo
FROM Sales.SalesOrderDetail;

--Funções MIN e MAX com Colunas do Tipo Date
SELECT MIN(BirthDate) AS Nascido_Mais_Antigamente, MAX(BirthDate) AS Nascido_Mais_Recentemente
FROM HumanResources.Employee;

--Funções MIN e MAX com Colunas do Tipo String
SELECT MIN(Name) AS Primeiro_Nome_de_Produto, MAX(Name) AS Ultimo_Nome_de_Produto
FROM Production.Product;

--MIN e MAX em Strings => Resultado Semelhante Usando TOP e ORDER BY
SELECT TOP(1) Name
FROM Production.Product
ORDER BY Name ASC;

SELECT MIN(Name)
FROM Production.Product;



--Função COUNT (*) x Função COUNT ( expressão )
SELECT	COUNT(*) AS Total_de_Produtos, 
		COUNT(Color) AS Total_de_Produtos_Com_Cor
FROM Production.Product;


--Funções SUM e AVG
SELECT	SUM(LineTotal) AS Valor_Total_de_Vendas, 
		AVG(LineTotal) AS Valor_Médio_de_Vendas
FROM Sales.SalesOrderDetail;

--Calculando a média sem AVG
SELECT	SUM(LineTotal) / COUNT (LineTotal) AS Valor_Médio_de_Vendas_Sem_AVG, 
		AVG(LineTotal) AS Valor_Médio_de_Vendas_Com_AVG
FROM Sales.SalesOrderDetail;


--Exemplo com Coluna sem Função de Agregação e sem Group By (Erro)
SELECT AVG(UnitPrice) AS Média_Preço, MIN(OrderQty)AS Quantidade_Mínima,
	   MAX(UnitPriceDiscount) AS Disconto_Máximo, ProductID
FROM Sales.SalesOrderDetail;


--Função de Agregação em Conjunto com Outras Funções
SELECT	MIN(YEAR(orderdate)) AS Ano_da_Compra_Mais_Antiga, 
		MAX(YEAR(orderdate)) AS Ano_da_Compra_Mais_Recente 
FROM Sales.SalesOrderHeader;


--DISTINCT com Funções de Agregação
SELECT	COUNT(DISTINCT CustomerID) AS Qtde_Vendas_Para_Clientes_Distintos,
		COUNT(CustomerID) AS Qtde_Vendas_Para_Clientes
FROM Sales.SalesOrderHeader;


--Valores NULOS (<> de branco) e Funções de Agregação
SELECT	AVG(Weight) AS "Peso_Médio_dos_Produtos(Usando AVG - OK)",
SUM(Weight) / COUNT(Weight) AS [Peso_Médio_dos_Produtos(Sem AVG - OK)],
SUM(Weight) / COUNT(*) AS [Peso_Médio_dos_Produtos (Sem AVG - NÃO OK)]
FROM Production.Product;

--Tratando Valores Nulos
SELECT	Weight AS "Sem Peso", COALESCE (Weight,0) AS "Peso Zerado"
FROM Production.Product;