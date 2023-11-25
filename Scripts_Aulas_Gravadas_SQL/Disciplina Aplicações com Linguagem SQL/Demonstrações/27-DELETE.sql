USE AdventureWorks2019
GO

--DELETE com WHERE Simples
SELECT * FROM dbo.TAB1
GO

DELETE dbo.TAB1
WHERE COL1 = 13
GO

SELECT * FROM dbo.TAB1
GO


--DELETE Com WHERE Composto
DELETE dbo.TAB1
WHERE COL1 BETWEEN 9 AND 12  --IDÊNTICO A COL1 >=9 AND COL1 <=12;
GO

SELECT * FROM dbo.TAB1
GO


--DELETE "ALEATÓRIO"
DELETE TOP(2) dbo.TAB1
GO


--DELETE sem WHERE
DELETE FROM dbo.TAB1
GO

SELECT COUNT(*) FROM dbo.TAB1
GO


--DELETE sem WHERE x TRUNCATE
SELECT *
INTO SalesOrderDetail_DELETE
FROM Sales.SalesOrderDetail
GO

SELECT *
INTO SalesOrderDetail_TRUNCATE
FROM Sales.SalesOrderDetail
GO

SELECT COUNT(*) FROM SalesOrderDetail_DELETE
GO
SELECT COUNT(*) FROM SalesOrderDetail_TRUNCATE
GO

--Client Statistics
DELETE SalesOrderDetail_DELETE
GO
TRUNCATE TABLE SalesOrderDetail_TRUNCATE
GO



--DELETE com Funções
SELECT * FROM dbo.TAB1_COPIA
GO

DELETE FROM dbo.TAB1_COPIA
WHERE COL3 <= GETDATE()-7
GO


--DELETE com Subconsultas 
DELETE FROM Sales.SalesPersonQuotaHistory   
WHERE BusinessEntityID IN (
							SELECT BusinessEntityID   
		    				FROM Sales.SalesPerson   
							WHERE SalesYTD > 2500000
						  ) 
GO
  

--DELETE com JOIN 
DELETE FROM Sales.SalesPersonQuotaHistory   
FROM Sales.SalesPersonQuotaHistory AS spqh  
INNER JOIN Sales.SalesPerson AS sp  
ON spqh.BusinessEntityID = sp.BusinessEntityID  
WHERE sp.SalesYTD > 2000000
GO


--DELETE x Integridade Referencial (CASCADE)
--Default é o RESTRICT (NO ACTION), que não deixa apagar registros pais que tenham filhos
CREATE TABLE dbo.Socios_Titulares
(
	NUM_COTA int NOT NULL PRIMARY KEY,
	NOME	 varchar(255) NOT NULL
)
GO

CREATE TABLE dbo.Socios_Dependentes
(
	ID_Dependente int NOT NULL,
	NUM_COTA_FK int NOT NULL,
	NOME	 varchar(255) NOT NULL
)
GO


ALTER TABLE dbo.Socios_Dependentes 
ADD CONSTRAINT	FK_Titular FOREIGN KEY
(
	NUM_COTA_FK
) REFERENCES dbo.Socios_Titulares
(
	NUM_COTA
)
ON DELETE  CASCADE
GO

INSERT INTO dbo.Socios_Titulares
VALUES (1, 'Gustavo')
GO

INSERT INTO dbo.Socios_Dependentes
VALUES	(1, 1, 'Juliana'),
		(2, 1, 'Pedro'),
		(3, 1, 'Giovana'),
		(4, 1, 'Davi')
GO

SELECT * FROM dbo.Socios_Titulares
GO
SELECT * FROM dbo.Socios_Dependentes
GO

EXEC SP_HELP 'dbo.Socios_Dependentes'
GO

DELETE FROM dbo.Socios_Titulares
WHERE NUM_COTA = 1
GO

SELECT * FROM dbo.Socios_Titulares
GO
SELECT * FROM dbo.Socios_Dependentes
GO


--DELETE x Integridade Referencial (SET NULL)
ALTER TABLE dbo.Socios_Dependentes
DROP CONSTRAINT FK_Titular
GO

ALTER TABLE dbo.Socios_Dependentes 
ADD CONSTRAINT	FK_Titular FOREIGN KEY
(
	NUM_COTA_FK
) REFERENCES dbo.Socios_Titulares
(
	NUM_COTA
)
ON DELETE  SET NULL
GO

ALTER TABLE dbo.Socios_Dependentes ALTER COLUMN NUM_COTA_FK int NULL
GO

INSERT INTO dbo.Socios_Titulares
VALUES (1, 'Gustavo')
GO

INSERT INTO dbo.Socios_Dependentes
VALUES	(1, 1, 'Juliana'),
		(2, 1, 'Pedro'),
		(3, 1, 'Giovana'),
		(4, 1, 'Davi')
GO

SELECT * FROM dbo.Socios_Titulares
GO
SELECT * FROM dbo.Socios_Dependentes
GO

EXEC SP_HELP 'dbo.Socios_Dependentes'
GO

DELETE FROM dbo.Socios_Titulares
WHERE NUM_COTA = 1
GO

SELECT * FROM dbo.Socios_Titulares
GO
SELECT * FROM dbo.Socios_Dependentes
GO


--DELETE COM SCRIPT DA INTERFACE GRÁFICA DO CLIENT
--DELETE COM INTERFACE GRÁFICA DO CLIENT