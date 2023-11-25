USE AdventureWorks2019
GO

--CASE Simples 
SELECT ProductID, Name, ProductSubcategoryID,
CASE ProductSubcategoryID
	WHEN 1 THEN 'Mountain Bikes'
	WHEN 2 THEN 'Road Bikes'
	WHEN 3 THEN 'Touring Bikes'
	ELSE 'Unknown Category'
END AS SubCategoryName
FROM Production.Product
GO



--CASE com Pesquisa Booleana
SELECT ProductNumber AS "Número do Produto", Name AS "Nome do Produto", ListPrice AS "Preço",
  "Faixa de Preço" =   
      CASE   
         WHEN ListPrice =  0 THEN 'Não Disponível para Venda'  
         WHEN ListPrice < 50 THEN 'Abaixo de $50'  
         WHEN ListPrice >= 50 and ListPrice < 250 THEN 'Abaixo de $250'  
         WHEN ListPrice >= 250 and ListPrice < 1000 THEN 'Abaixo $1000'  
         ELSE 'Acima de $1000'  
      END  
FROM Production.Product  
GO