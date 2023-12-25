USE AdventureWorks2019
GO

--Convers�o Impl�cita de Inteiro para String
DECLARE @Texto varchar(10);
SET @Texto = 10;
SELECT @Texto + ' foi convertido implicitamente para string.'


--Erro de Convers�o Impl�cita
DECLARE @Nao_Texto int;
SET @Nao_Texto = 10;
SELECT @Nao_Texto + ' TEXTO QUALQUER'


-- Convers�o Impl�cita de String para Inteiro
DECLARE @Nao_Texto int;
SET @Nao_Texto = '10';
SELECT @Nao_Texto + '5'



--Convertendo Explicitamente Tipo de Dados MONEY para VARCHAR
SELECT CAST ( $1090.50 AS VARCHAR(10) ) AS VALOR

SELECT Name AS Produto, CAST ( ListPrice AS VARCHAR(10) ) AS Pre�o_de_Lista
FROM Production.Product
ORDER BY 1


--Convers�o Impl�cita de Tipos de Dados nas Fun��es de Caracteres
SELECT LOWER (123)
GO


