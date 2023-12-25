USE AdventureWorks2019
GO

--Expressão Calculada Multiplicando Duas Colunas
SELECT UnitPrice, OrderQty, (UnitPrice * OrderQty) AS TotalValue
FROM Sales.SalesOrderDetail;


--Expressão Calculada Usando o Operador de Divisão e Multiplicação
SELECT UnitPrice, UnitPriceDiscount, UnitPriceDiscount / UnitPrice * 100 AS DiscountPercentual
FROM Sales.SalesOrderDetail
WHERE UnitPriceDiscount > 0



--Expressão Calculada Usando o Operador de Subtração
SELECT UnitPrice, UnitPriceDiscount, UnitPrice - UnitPriceDiscount AS UnitPriceWithDiscount
FROM Sales.SalesOrderDetail



--Expressão Calculada Usando o Operador de Concatenação
SELECT FirstName AS PrimeiroNome, MiddleName AS NomeDoMeio, LastName AS ÚltimoNome, 
FirstName + ' ' + MiddleName + ' ' + LastName AS NomeCompleto
FROM Person.Person

--Usando o Operador de Concatenação para Gerar Dinamicamente Comandos
SELECT 'DROP TABLE ' + name + ';'
FROM sys.tables


--"Alterando" a Ordem de Avaliação dos Operadores
--Calculando o Valor Total com o Desconto (Errado: multiplicação feita primeiro, antes de calcular o valor unitário com o desconto)
--Ex.: linhas 803 / 805
SELECT UnitPrice, UnitPriceDiscount, OrderQty, UnitPrice - UnitPriceDiscount * OrderQty AS TotalWithDiscount
FROM Sales.SalesOrderDetail

--Calculando o Valor Total com o Desconto (Ok)
SELECT UnitPrice, UnitPriceDiscount, OrderQty, (UnitPrice - UnitPriceDiscount) * OrderQty AS TotalWithDiscount
FROM Sales.SalesOrderDetail
