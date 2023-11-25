USE AdventureWorks2019
GO

--Criar tabela de Luvas (Gloves) com o Wizard de Export Data
SELECT ProductModelID, Name  
FROM Production.ProductModel  
WHERE ProductModelID IN (3, 4);  

--Nova tabela 
SELECT *
FROM Production.Gloves  
ORDER BY Name; 
  

--UNION: elimina as linhas duplicadas (*Erro do ORDER BY na subconsulta)
SELECT ProductModelID, Name  
FROM Production.ProductModel  
ORDER BY Name
UNION  
SELECT ProductModelID, Name  
FROM Production.Gloves  
ORDER BY Name;  


--UNION: elimina as linhas duplicadas (*OK, com ORDER BY consulta geral)
SELECT ProductModelID, Name  
FROM Production.ProductModel  
UNION  
SELECT ProductModelID, Name  
FROM Production.Gloves  
ORDER BY Name;  


--UNION: quantidade de colunas diferentes (*Error)
SELECT ProductModelID, Name  
FROM Production.ProductModel  
UNION  
SELECT ProductModelID  
FROM Production.Gloves  
ORDER BY Name;  


--UNION ALL: NÃO elimina as linhas duplicadas
SELECT ProductModelID, Name  
FROM Production.ProductModel  
UNION ALL  
SELECT ProductModelID, Name  
FROM Production.Gloves  
ORDER BY Name;  
  

--INTERSECT
SELECT ProductModelID, Name  
FROM Production.ProductModel  
INTERSECT  
SELECT ProductModelID, Name  
FROM Production.Gloves  
ORDER BY Name;  


--EXCEPT: todos os produtos, exceto Full-Finger Gloves e Half-Finger Gloves
SELECT ProductModelID, Name  
FROM Production.ProductModel  
EXCEPT  
SELECT ProductModelID, Name  
FROM Production.Gloves  
ORDER BY Name; 


--EXCEPT: ordem dos conjuntos altera o resultado (operação de subtração / diferença)
SELECT ProductModelID, Name  
FROM Production.Gloves 
EXCEPT
SELECT ProductModelID, Name  
FROM Production.ProductModel  
ORDER BY Name; 
--Nenhum produto que esteja em Production.Gloves e que não esteja em Production.ProductModel 
--Atualizar Production.Gloves com Editor