USE AdventureWorks2019
GO

--Express�o Calculada Multiplicando Duas Colunas
SELECT UnitPrice, OrderQty, (UnitPrice * OrderQty) AS TotalValue
FROM Sales.SalesOrderDetail;


--Express�o Calculada Usando o Operador de Divis�o e Multiplica��o
SELECT UnitPrice, UnitPriceDiscount, UnitPriceDiscount / UnitPrice * 100 AS DiscountPercentual
FROM Sales.SalesOrderDetail
WHERE UnitPriceDiscount > 0



--Express�o Calculada Usando o Operador de Subtra��o
SELECT UnitPrice, UnitPriceDiscount, UnitPrice - UnitPriceDiscount AS UnitPriceWithDiscount
FROM Sales.SalesOrderDetail



--Express�o Calculada Usando o Operador de Concatena��o
SELECT FirstName AS PrimeiroNome, MiddleName AS NomeDoMeio, LastName AS �ltimoNome, 
FirstName + ' ' + MiddleName + ' ' + LastName AS NomeCompleto
FROM Person.Person

--Usando o Operador de Concatena��o para Gerar Dinamicamente Comandos
SELECT 'DROP TABLE ' + name + ';'
FROM sys.tables


--"Alterando" a Ordem de Avalia��o dos Operadores
--Calculando o Valor Total com o Desconto (Errado: multiplica��o feita primeiro, antes de calcular o valor unit�rio com o desconto)
--Ex.: linhas 803 / 805
SELECT UnitPrice, UnitPriceDiscount, OrderQty, UnitPrice - UnitPriceDiscount * OrderQty AS TotalWithDiscount
FROM Sales.SalesOrderDetail

--Calculando o Valor Total com o Desconto (Ok)
SELECT UnitPrice, UnitPriceDiscount, OrderQty, (UnitPrice - UnitPriceDiscount) * OrderQty AS TotalWithDiscount
FROM Sales.SalesOrderDetail
