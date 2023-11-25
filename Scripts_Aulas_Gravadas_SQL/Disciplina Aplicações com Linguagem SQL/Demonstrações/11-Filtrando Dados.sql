USE AdventureWorks2019
GO

--Exemplos de Filtros com Operadores de Comparação 

--Listar Produtos da Cor Preta (Black)
SELECT Name,Color
FROM Production.Product
WHERE Color = 'Black'
ORDER BY Name;

--Listar Produtos que Não Sejam da Cor Preta
SELECT Name,Color
FROM Production.Product
WHERE Color <> 'Black' 
ORDER BY Name;

--Listar Produtos com Valor de Venda Superior a 1.000
SELECT Name AS Produto, Color AS Cor, ListPrice AS "Preço de Lista"
FROM Production.Product
WHERE ListPrice > 1000
ORDER BY Name;


--Exemplos de Filtros com Operadores Lógicos

--Operador LIKE + %
--Listar Produtos com Nome que Iniciam com 'Chain'
SELECT Name,Color
FROM Production.Product
WHERE Name LIKE 'Chain%'
ORDER BY Name;

--Listar Produtos com Nome que Tenham 'Chainring' no Nome (em qualquer posição)
SELECT Name,Color
FROM Production.Product
WHERE Name LIKE '%Chainring%'
ORDER BY Name;


--Operador LIKE + _
--Listar Produtos cujo Nome possua a letra "a" como segunda letra
SELECT Name,Color
FROM Production.Product
WHERE Name LIKE '_a%'
ORDER BY Name;

--Listar Produtos da Cor Preta (Black) ou Prata (Silver)
SELECT Name,Color
FROM Production.Product
WHERE Color = 'Black' 
OR Color = 'Silver'
ORDER BY Name;


--Ordem de Avaliação de Operadores

--Listar Produtos com Nome que Iniciam com 'Chain' e que Sejam da Cor Preta ou Prata 
SELECT Name,Color
FROM Production.Product
WHERE Name LIKE 'Chain%'
AND (Color = 'Black' OR Color = 'Silver')
ORDER BY Name;

--Se não tivesse o parênteses "forçando a ordem de avaliação" seria:
--Listar Produtos com Nome que Iniciam com 'Chain' e que Sejam da Cor Preta (AND avaliado primeiro que o OR)
--ou Todos Produtos da Cor Prata 
SELECT Name,Color
FROM Production.Product
WHERE Name LIKE 'Chain%'
AND Color = 'Black' OR Color = 'Silver'
ORDER BY Color;

--Mesmo resultado acima pois o AND foi processado primeiramente
SELECT Name,Color
FROM Production.Product
WHERE (Name LIKE 'Chain%'
AND Color = 'Black') OR Color = 'Silver'
ORDER BY Color;


--Alias de Coluna na Cláusula WHERE (Error)
SELECT Name AS Nome_Produto, Color AS Cor
FROM Production.Product
WHERE Nome_Produto like 'Chain%'
ORDER BY Nome_Produto, Cor;






--Próxima Demonstração

--Uso de TOP para Retornar os 5 Primeiros Produtos 
SELECT TOP (5) Name AS Nome_Produto
FROM Production.Product
ORDER BY Nome_Produto;

--Impacto do ORDER BY na Cláusula TOP 
SELECT TOP (5) Name AS Nome_Produto
FROM Production.Product
ORDER BY Nome_Produto DESC;

--Uso de TOP para Retornar 10% do Total de Produtos 
SELECT TOP (10) PERCENT Name AS Nome_Produto
FROM Production.Product
ORDER BY Nome_Produto;



--Uso do OFFSET-FETCH para "Paginar" Dados

--Retornar os 50 primeiros produtos
SELECT Name AS Nome_Produto
FROM Production.Product
ORDER BY Nome_Produto
OFFSET 0 ROWS FETCH FIRST 50 ROWS ONLY;

--Retornar do 51º ao 100º produto
SELECT Name AS Nome_Produto
FROM Production.Product
ORDER BY Nome_Produto
OFFSET 50 ROWS FETCH NEXT 50 ROWS ONLY;



--Uso de DISTINCT para Retornar as Cores Existentes de Produtos Eliminando as Repetidas 
SELECT DISTINCT Color AS Cores_de_Produtos
FROM Production.Product
WHERE Color IS NOT NULL
ORDER BY Cores_de_Produtos;

--Sem o DISTINCT
SELECT Color AS Cores_de_Produtos
FROM Production.Product
WHERE Color IS NOT NULL
ORDER BY Cores_de_Produtos;



--Uso de DISTINCT em Múltiplas Colunas
SELECT DISTINCT Name AS Nome_Produto, Color AS Cores_de_Produtos
FROM Production.Product
WHERE Color IS NOT NULL
ORDER BY Nome_Produto, Cores_de_Produtos;

SELECT DISTINCT FirstName, MiddleName, LastName 
FROM Person.Person
ORDER BY FirstName, MiddleName, LastName;