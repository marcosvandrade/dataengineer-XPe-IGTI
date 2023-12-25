USE AdventureWorks2019
GO

--JOIN com Operador de Comparação (Inner Join ANSI SQL-89) 
--Sem Alias
--Listar Categorias e Subcategorias
SELECT	Production.ProductCategory.Name AS Nome_da_Categoria, 
		Production.ProductSubCategory.Name AS Nome_da_SubCategoria
FROM Production.ProductCategory, Production.ProductSubCategory
WHERE Production.ProductCategory.ProductCategoryID = Production.ProductSubCategory.ProductCategoryID
ORDER BY Nome_da_Categoria ASC, Nome_da_SubCategoria ASC;


--Listar Produtos, Categorias e Subcategorias
--Joins com mais de 2 tabelas (ANSI SQL-89)
--Referência FQN às tabelas
--Ordem das tabelas no join / ordem dos joins
SELECT	Production.Product.Name AS Nome_do_Produto,
		Production.ProductSubCategory.Name AS Nome_da_SubCategoria,
		Production.ProductCategory.Name AS Nome_da_Categoria		
FROM Production.Product, Production.ProductCategory, Production.ProductSubCategory
WHERE Production.Product.ProductSubCategoryID = Production.ProductSubCategory.ProductSubcategoryID
AND	  Production.ProductCategory.ProductCategoryID = Production.ProductSubCategory.ProductCategoryID	
ORDER BY Nome_do_Produto ASC;




--Listar Produtos, Categorias e Subcategorias
--Join ANSI SQL-89
--Usando Alias
SELECT	P.Name AS Nome_do_Produto,
		S.Name AS Nome_da_SubCategoria,
		C.Name AS Nome_da_Categoria		
FROM Production.Product P, Production.ProductCategory C, Production.ProductSubCategory S
WHERE P.ProductSubCategoryID = S.ProductSubcategoryID
AND	  C.ProductCategoryID = S.ProductCategoryID	
ORDER BY Nome_do_Produto ASC;


--Produto Cartesiano (ANSI SQL-89)
SELECT	Production.ProductCategory.Name AS Nome_da_Categoria, 
		Production.ProductSubCategory.Name AS Nome_da_SubCategoria
FROM Production.ProductCategory, Production.ProductSubCategory
ORDER BY Nome_da_Categoria ASC, Nome_da_SubCategoria ASC;

