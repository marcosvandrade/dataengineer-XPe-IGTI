USE AdventureWorks2019
GO


--INNER JOIN (ANSI SQL-92) 
--Listar Categorias e Subcategorias
SELECT	Production.ProductCategory.Name AS Nome_da_Categoria, 
		Production.ProductSubCategory.Name AS Nome_da_SubCategoria
FROM Production.ProductCategory
INNER JOIN Production.ProductSubCategory
ON Production.ProductCategory.ProductCategoryID = Production.ProductSubCategory.ProductCategoryID
ORDER BY Nome_da_Categoria ASC, Nome_da_SubCategoria ASC;


--INNER JOIN com mais de 2 tabelas (ANSI SQL-92)
--Listar Produtos, Categorias e Subcategorias
SELECT	Production.Product.Name AS Nome_do_Produto,
		Production.ProductSubCategory.Name AS Nome_da_SubCategoria,
		Production.ProductCategory.Name AS Nome_da_Categoria		
FROM Production.Product
INNER JOIN Production.ProductSubCategory
ON Production.Product.ProductSubCategoryID = Production.ProductSubCategory.ProductSubcategoryID
INNER JOIN Production.ProductCategory
ON Production.ProductCategory.ProductCategoryID = Production.ProductSubCategory.ProductCategoryID	
ORDER BY Nome_do_Produto ASC;

--Listar Produtos, Categorias e Subcategorias
--Join ANSI SQL-92
--Usando Alias
SELECT	P.Name AS Nome_do_Produto,
		S.Name AS Nome_da_SubCategoria,
		C.Name AS Nome_da_Categoria		
FROM Production.Product P
INNER JOIN Production.ProductSubCategory S
ON P.ProductSubCategoryID = S.ProductSubcategoryID
INNER JOIN Production.ProductCategory C
ON C.ProductCategoryID = S.ProductCategoryID	
ORDER BY Nome_do_Produto ASC;


--SELF INNER JOIN
CREATE TABLE Employee
(
	ID int primary key,
	Name varchar(50),
	ID_Manager int
);

INSERT INTO Employee(ID,Name,ID_Manager) VALUES (01,'Juliana',NULL); 
INSERT INTO Employee(ID,Name,ID_Manager) VALUES (02,'Gustavo',01);
INSERT INTO Employee(ID,Name,ID_Manager) VALUES (03,'Giovana',02);
INSERT INTO Employee(ID,Name,ID_Manager) VALUES (04,'Davi',02);
INSERT INTO Employee(ID,Name,ID_Manager) VALUES (05,'Pedro',02);
INSERT INTO Employee(ID,Name,ID_Manager) VALUES (06,'Guilherme',01);

SELECT * FROM Employee;

--Listar Funcionário e o Respectivo Gerente
SELECT E1.Name AS Funcionário, E2.Name AS Gerente
FROM Employee E1
INNER JOIN Employee E2
ON E1.ID_Manager = E2.ID
ORDER BY E1.Name


--Produto Cartesiano (ANSI SQL-92)
SELECT	Production.ProductCategory.Name AS Nome_da_Categoria, 
		Production.ProductSubCategory.Name AS Nome_da_SubCategoria
FROM Production.ProductCategory 
CROSS JOIN Production.ProductSubCategory
--WHERE Production.ProductCategory.Name = 'Clothing'
ORDER BY Nome_da_Categoria ASC, Nome_da_SubCategoria ASC;

