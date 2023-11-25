USE AdventureWorks2019
GO

--Separando Dia, Mês e Ano da Data
SELECT DISTINCT DueDate AS Data_e_Hora_Vencimento, 
	   DAY(DueDate) AS Dia_Vencimento,
	   MONTH(DueDate) AS Mês_Vencimento,
	   YEAR(DueDate) AS Ano_Vencimento
FROM Purchasing.PurchaseOrderDetail
ORDER BY DueDate DESC
GO

--Data e Hora do Sistema (ANSI / SQL)
SELECT CURRENT_TIMESTAMP AS Data_Hora_Sistema, 
       GETDATE() AS Data_Hora_Sistema
GO

SELECT DAY (CURRENT_TIMESTAMP) AS Dia_de_Hoje,
	   MONTH (CURRENT_TIMESTAMP) AS Mês_Atual,
	   YEAR (CURRENT_TIMESTAMP) AS Ano_Atual
GO

--DATENAME
SELECT DATENAME (weekday,GETDATE()) AS Dia_da_Semana,
	   DATENAME (hh,GETDATE()) AS Hora,
	   DATENAME (minute,GETDATE()) AS Minutos
GO

SET LANGUAGE Português
GO
SELECT @@LANGUAGE
GO
SELECT DATENAME (weekday,GETDATE()) AS Dia_da_Semana,
	   DATENAME (hh,GETDATE()) AS Hora,
	   DATENAME (minute,GETDATE()) AS Minutos
GO


--Funções de Data e Hora com Operador de Concatenação
SELECT DATENAME(weekday,GETDATE()) + ', ' + DATENAME(day,GETDATE()) + ' de ' + 
	   DATENAME(month,GETDATE()) + ' de ' + DATENAME (yyyy,GETDATE()) + 
	   ' às ' + DATENAME(hh,GETDATE()) + ':' + DATENAME(n,GETDATE()) AS "Data e Hora Por Extenso"
GO



--DATEDIFF ( datepart , Data_Inicial , Data_Final )

--Calcular diferença em dias entre duas datas
SELECT DATEDIFF(day, '31/12/2018 23:59:59', '01/01/2019 00:00:00');
SELECT DATEDIFF(day, '31-12-2018', '07-01-2019');
SELECT DATEDIFF(day, '2018', '2019');

--Calcular diferença em horas entre duas datas
SELECT DATEDIFF(hour, '31/12/2018 23:59:59', '01/01/2019 00:00:00');
SELECT DATEDIFF(hour, '31-12-2018', '07-01-2019');
SELECT DATEDIFF(hour, '2018', '2019');

--Calcular diferença em minutos entre duas datas
SELECT DATEDIFF(minute, '31/12/2018 23:59:59', '01/01/2019 00:00:00');
SELECT DATEDIFF(minute, '31-12-2018', '07-01-2019');
SELECT DATEDIFF(minute, '2018', '2019');


--DATEADD ( datepart , Quantidade , Data )

--Adicionar 1 hora à uma data
SELECT DATEADD (hour, 1, '01/01/2019 00:30:00');
	
--Adicionar 2 horas à uma data
SELECT DATEADD (hour, 2, '01/01/2019 22:30:00');

--Adicionar 6 meses à uma data
SELECT DATEADD (month, 6, '15/01/2019');


--ISDATE para testar uma expressão datetime válida

IF ISDATE('12-01-2019 08:23:45.655') = 1  
    PRINT 'VALID'  
ELSE  
    PRINT 'INVALID';


IF ISDATE('12-01-2019 08:63:45.65555') = 1  
    PRINT 'VALID'  
ELSE  
    PRINT 'INVALID';


SELECT ISDATE ('09/09/2019'), ISDATE ('09/092019'), ISDATE ('09/09-2019')