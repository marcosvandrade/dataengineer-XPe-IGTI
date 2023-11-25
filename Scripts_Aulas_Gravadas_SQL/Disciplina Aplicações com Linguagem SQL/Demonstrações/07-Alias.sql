USE AdventureWorks2019
GO

--Alias para colunas
SELECT Name AS Nome_do_Produto, 
ProductNumber AS Número_do_Produto
FROM Production.Product
GO

SELECT Name, Name AS Nome_do_Produto, ProductNumber, ProductNumber AS Número_do_Produto
FROM Production.Product
GO

--Outra forma de criar alias no SQL
SELECT Nome_do_Produto = Name, 
Número_do_Produto = ProductNumber
FROM Production.Product
GO

--Alias com Espaço
SELECT Name AS "Nome do Produto", Name AS [Nome do Produto]
FROM Production.Product
GO


--Alias de Coluna Acidental
SELECT Name ProductNumber
FROM Production.Product
GO


--Alias de Tabela Criado com a Cláusula AS
SELECT Name, ProductNumber
FROM Production.Product AS P
GO
--Alias de Tabela Criado sem a Cláusula AS
SELECT Name, ProductNumber
FROM Production.Product P
GO


--Alias de Tabela
SELECT P.Name, P.ProductNumber
FROM Production.Product P
GO

--Não obrigatoriedade de usar Alias de Tabela nas Colunas
SELECT Name, ProductNumber
FROM Production.Product P
GO

--Alias de Tabela não Definido
SELECT P.Name, P.ProductNumber, C.Name
FROM Production.Product P
GO

--Alias de Tabela + Alias de Coluna
SELECT P.Name AS Nome_do_Produto, P.ProductNumber AS Número_do_Produto
FROM Production.Product P
GO


--Ambiguidade de Colunas
SELECT Name, ProductNumber
FROM Production.Product, Production.Location
GO

SP_HELP [Production.Product];

SP_HELP [Production.Location];


--Alias de Tabelas para Remover Ambiguidade de Nome de Colunas
SELECT P.Name, P.ProductNumber, L.Name
FROM Production.Product P, Production.Location L
GO

--Ou prefixar colunas com nome das tabelas
SELECT Product.Name, ProductNumber, Location.Name
FROM Production.Product, Production.Location
GO