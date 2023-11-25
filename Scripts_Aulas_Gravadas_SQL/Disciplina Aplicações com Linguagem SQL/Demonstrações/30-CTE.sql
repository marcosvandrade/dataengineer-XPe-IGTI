USE AdventureWorks2019
GO

--CTE Simples
--Quantidade de vendas dos vendedores por ano
WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)  
AS  
--Define a query da CTE:  
(  
    SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
)  
-- Consulta externa (outer query) referenciando a CTE
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear  
FROM Sales_CTE  
GROUP BY SalesYear, SalesPersonID  
ORDER BY SalesPersonID, SalesYear
GO



--Múltiplas CTEs
--Quantidade e valor total das vendas dos vendedores por ano,
--com a meta e o resultado x meta (se superou a meta ou ficou abaixo)
WITH Sales_CTE (SalesPersonID, TotalSales, SalesYear)  
AS  
-- Define a query da primeira CTE
(  
    SELECT SalesPersonID, SUM(TotalDue) AS TotalSales, YEAR(OrderDate) AS SalesYear  
    FROM Sales.SalesOrderHeader  
    WHERE SalesPersonID IS NOT NULL  
    GROUP BY SalesPersonID, YEAR(OrderDate)  
  
)  
,  -- USAR VÍRGULA (,) PARA SEPARAR A DEFINIÇÃO DAS CTEs
  
-- Define a query da segunda CTE, que pode fazer referência à CTE anterior
Sales_Quota_CTE (BusinessEntityID, SalesQuota, SalesQuotaYear)  
AS  
(  
       SELECT BusinessEntityID, SUM(SalesQuota)AS SalesQuota, YEAR(QuotaDate) AS SalesQuotaYear  
       FROM Sales.SalesPersonQuotaHistory  
       GROUP BY BusinessEntityID, YEAR(QuotaDate)  
)  
  
-- Consulta externa (outer query) retornando colunas de ambas CTEs
SELECT SalesPersonID  
  , SalesYear  
  , FORMAT(TotalSales,'C','en-us') AS TotalSales  
  , SalesQuotaYear  
  , FORMAT (SalesQuota,'C','en-us') AS SalesQuota  
  , FORMAT (TotalSales -SalesQuota, 'C','en-us') AS Amt_Above_or_Below_Quota  
FROM Sales_CTE  
JOIN Sales_Quota_CTE ON Sales_Quota_CTE.BusinessEntityID = Sales_CTE.SalesPersonID  
AND Sales_CTE.SalesYear = Sales_Quota_CTE.SalesQuotaYear  
ORDER BY SalesPersonID, SalesYear
GO



--CTEs Recursivas
WITH CTE_Recursiva (Nivel, Numero) 
AS
(
    -- Âncora (nível 1)
    SELECT 1 AS Nivel, 1 AS Numero
    
    UNION ALL

    -- Níveis recursivos
    SELECT Nivel + 1, Nivel AS "Nível Anterior" 
    FROM CTE_Recursiva
    --WHERE Numero < 100
 )

SELECT *
FROM CTE_Recursiva
GO


--Evitar loops infinitos
WITH CTE_Recursiva (Nivel, Numero) 
AS
(
    -- Âncora (nível 1)
    SELECT 1 AS Nivel, 1 AS Numero
    
    UNION ALL

    -- Níveis recursivos
    SELECT Nivel + 1, Nivel AS "Nível Anterior" 
    FROM CTE_Recursiva    
	--WHERE Numero < 10
 )
SELECT *
FROM CTE_Recursiva
OPTION (MAXRECURSION 50 );  



--CTE Recursiva para listar os funcionários de forma hierárquica
--Tabela de Funcionários
CREATE TABLE dbo.MyEmployees  
(  
EmployeeID smallint NOT NULL,  
FirstName nvarchar(30)  NOT NULL,  
LastName  nvarchar(40) NOT NULL,  
Title nvarchar(50) NOT NULL,  
DeptID smallint NOT NULL,  
ManagerID int NULL,  
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)   
);  

-- Cadastrar os funcionários
INSERT INTO dbo.MyEmployees VALUES   
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)  
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)  
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)  
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)  
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)  
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)  
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)  
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)  
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);


--CTE recursiva para ler os funcionários e os seus chefes imediatos
WITH DirectReports AS   
(  
    SELECT EmployeeID, Title, FirstName, LastName, ManagerID, 0 AS EmployeeLevel  
    FROM dbo.MyEmployees   
    WHERE ManagerID IS NULL  
    UNION ALL  
    SELECT e.EmployeeID, e.Title,e.FirstName, e.LastName, e.ManagerID, EmployeeLevel + 1  
    FROM dbo.MyEmployees AS e  
        INNER JOIN DirectReports AS d  
        ON e.ManagerID = d.EmployeeID   
)  
SELECT *   
FROM DirectReports  
ORDER BY EmployeeLevel;



