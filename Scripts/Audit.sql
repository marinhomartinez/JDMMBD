USE F1_ejemplo
GO

DROP TABLE IF EXISTS [F1_ejemplo].[dbo].[Circuit]
GO

-- Creamos la tabla Circuit
CREATE TABLE [F1_ejemplo].[dbo].[Circuit]
(
CircuitID int PRIMARY KEY,
Name varchar(50) NOT NULL,
Country varchar(50) NOT NULL,
Length float NOT NULL,
Turns int NOT NULL
)
GO
-- Insertamos datos de ejemplo en la tabla Circuit
INSERT INTO [F1_ejemplo].[dbo].[Circuit] VALUES
(1, 'Circuit de Barcelona-Catalunya', 'Spain', 4.655, 16),
(2, 'Circuit Paul Ricard', 'France', 5.842, 15),
(3, 'Silverstone Circuit', 'United Kingdom', 5.891, 18)
GO
--Comprobamos contenido
select *
from [F1_ejemplo].[dbo].[Circuit]
go

-- Creamos una especificación de auditoría de base de datos para la tabla Circuit
CREATE DATABASE AUDIT SPECIFICATION [Auditoria Circuit de F1_ejemplo]
FOR SERVER AUDIT [Filelog_audits_jdmm]
ADD (SELECT ON OBJECT::[F1_ejemplo].[dbo].[Circuit] BY [dbo]),
ADD (INSERT ON OBJECT::[F1_ejemplo].[dbo].[Circuit] BY [dbo]),
ADD (UPDATE ON OBJECT::[F1_ejemplo].[dbo].[Circuit] BY [dbo]),
ADD (DELETE ON OBJECT::[F1_ejemplo].[dbo].[Circuit] BY [dbo])
GO

-- Activamos la especificación de auditoría de base de datos
ALTER DATABASE AUDIT SPECIFICATION [Auditoria Circuit de F1_ejemplo] WITH (STATE = ON)
GO

-- Realizamos algunas operaciones en la tabla Circuit para probar la auditoría
SELECT * FROM [F1_ejemplo].[dbo].[Circuit]

UPDATE [F1_ejemplo].[dbo].[Circuit]
SET Turns = 20
WHERE CircuitID = 1

DELETE [F1_ejemplo].[dbo].[Circuit]
WHERE CircuitID = 2

-- Para ver los registros de la auditoría con salida a un archivo
SELECT * FROM sys.fn_get_audit_file ('C:\Audits\*',default,default);
GO

-- Desactivamos y eliminamos la especificación de auditoría de base de datos
ALTER DATABASE AUDIT SPECIFICATION [Auditoria Circuit de F1_ejemplo] WITH (STATE = OFF)
GO

DROP DATABASE AUDIT SPECIFICATION [Auditoria Circuit de F1_ejemplo]
GO