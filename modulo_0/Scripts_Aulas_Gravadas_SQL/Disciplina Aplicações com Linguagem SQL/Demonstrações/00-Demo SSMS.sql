--Servidor e Instância
SELECT @@SERVERNAME, @@SERVICENAME


USE [master]
GO

SELECT *
FROM sysdatabases
GO


--Comentário de uma linha

/*
Comentário de 
blocos de
linhas
*/

--Delimitador de comandos (Terminador de linhas)
CREATE TABLE tabela1 (coluna1 int);
CREATE TABLE tabela2 (coluna2 int);


--Separador batch

--Apenas 1 bloco batch de execução
CREATE TABLE tabela1 (coluna1 int);
CREATE VIEW view1 as SELECT * FROM tabela1;


--Dois blocos batch de execução
CREATE TABLE tabela1 (coluna1 int);
GO
CREATE VIEW view1 as SELECT * FROM tabela1;
GO
