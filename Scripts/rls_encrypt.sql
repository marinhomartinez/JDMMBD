USE master;
GO
DROP DATABASE IF EXISTS RLS_F1
GO
CREATE DATABASE RLS_F1;
GO
USE RLS_F1;
GO
CREATE USER Manzoni  WITHOUT LOGIN;
CREATE USER Riccobon WITHOUT LOGIN;
CREATE USER Perrone WITHOUT LOGIN;
GO
DROP TABLE IF EXISTS Department
GO
CREATE TABLE Department(
      DepartmentName varchar(100) NULL,
       DepartmentEmail varchar(100) NULL,
       DepartmentHeadUserName varchar(20) NULL
);  
GO
GRANT SELECT ON dbo.Department TO Manzoni;
GRANT SELECT ON dbo.Department TO Riccobon;
GRANT SELECT ON dbo.Department TO Perrone;
GO
 
INSERT INTO Department VALUES 
   ('Electrical Dptm','electric@ferrari.com','Manzoni'),
   ('Chassis Dptm','chassis@ferrari.com','Manzoni'),
   ('Engine Dptm','engine@ferrari.com','Riccobon'),
   ('Technical Dptm','technical@ferrari.com','Riccobon'),
   ('aerodynamic Dptm','aerodynamic@ferrari.com','Manzoni'),
   ('RRHH Dptm','rrhh@ferrari.com','Perrone');
GO
PRINT USER
GO
-- dbo
-- VER TODOS LOS REGISTROS
SELECT * FROM Department
GO
-- FUNCTION RLS IN-LINE TABLE
CREATE OR ALTER FUNCTION fn_RowLevelSecurity (@FilterColumnName sysname)
RETURNS TABLE
WITH SCHEMABINDING
as
	RETURN SELECT 1 as fn_SecureDepartmentData
	-- filter out records based on database user name 
	where @FilterColumnName = user_name() OR user_name()='dbo';
GO

CREATE SECURITY POLICY FilterDepartment
ADD FILTER PREDICATE dbo.fn_RowLevelSecurity(DepartmentHeadUserName)
ON dbo.Department
WITH (STATE = ON); 
GO 

PRINT USER
GO
-- dbo

-- DEMOSTRACIÓN PROBLEMA NO SELECT PERO SI INSERT
GRANT UPDATE, INSERT ON dbo.Department TO Manzoni;
GRANT UPDATE, INSERT ON dbo.Department TO Riccobon;
GRANT UPDATE, INSERT ON dbo.Department TO Perrone;
GO

EXECUTE AS USER = 'Riccobon';
GO
SELECT * FROM Department
GO

PRINT USER
GO
-- Riccobon
REVERT
GO

PRINT USER
GO
-- dbo

-- SELECT CON Manzoni
EXECUTE AS USER = 'Manzoni';
GO
SELECT * FROM Department
GO

PRINT USER
GO
-- Manzoni

--  PUEDE ACTUALIZAR FILAS CAMBIANDO DepartmentHeadUserName A OTRO USUARIO (Riccobon)
UPDATE Department 
SET DepartmentEmail = 'transmission@ferrari', 
    DepartmentHeadUserName = 'Riccobon' 
WHERE DepartmentName = 'Electrical Dptm';
GO
--(1 row affected)
-- esto no lo puede hacer porque no puede select
UPDATE Department 
SET DepartmentEmail = 'Riccobon@ABC.COM', 
    DepartmentHeadUserName = 'Riccobon' 
WHERE DepartmentName = 'Engine Dptm';
GO
--(0 rows affected)
--NO PUEDE VER LA FILA QUE ACTUALIZO
SELECT * FROM Department
GO

--TB PUEDE INSERT FILAS QUE NO SON SUYAS
PRINT USER
GO
-- Manzoni
-- INSERT new Department para DepartmentHeadUserName Perrone
INSERT INTO Department VALUES 
   ('EcoFin Dptm','ecofin@ferrari.com','Perrone');
GO
--(1 row affected)
--NO PUEDE VER LO QUE INSERTA PERO SI INSERTARLO
SELECT DepartmentName, DepartmentEmail, DepartmentHeadUserName
FROM Department;
GO
--
REVERT;
GO
EXECUTE AS USER = 'Perrone';
GO
SELECT * FROM Department
GO
--
REVERT;
GO
--BLOQUEAR PREDICADOS
ALTER SECURITY POLICY FilterDepartment
ADD BLOCK PREDICATE dbo.fn_RowLevelSecurity(DepartmentHeadUserName)
ON dbo.Department AFTER UPDATE, 
ADD BLOCK PREDICATE dbo.fn_RowLevelSecurity(DepartmentHeadUserName)
ON dbo.Department AFTER INSERT;
GO 

--Actualizar el registro del Departamento
EXECUTE AS USER = 'Manzoni';
GO
-- ESTO ES LO QUE Manzoni VE CON FILTER PREDICATE
SELECT DepartmentName, DepartmentEmail, DepartmentHeadUserName
FROM Department;
GO
-- Manzoni CON BLOCK PREDICATE
-- DepartmentHeadUserName = 'Riccobon'
UPDATE Department 
SET DepartmentEmail = 'bloquear@ABC.COM', 
    DepartmentHeadUserName = 'Riccobon' 
WHERE DepartmentName = 'ABC Company';
GO
-- (0 rows affected)

-- INSERT new Department
INSERT INTO Department VALUES 
   ('EcoFin Dptm','ecofin@ferrari.com','Perrone');
go
--Msg 33504, Level 16, State 1, Line 157
--The attempted operation failed because the target object 'RLS_F1.dbo.Department' has a block predicate that conflicts with this operation. If the operation is performed on a view, the block predicate might be enforced on the underlying table. Modify the operation to target only the rows that are allowed by the block predicate.
--The statement has been terminated.

PRINT 'Manzoni''s Departments after UPDATE and INSERT';
SELECT DepartmentName, DepartmentEmail, DepartmentHeadUserName
FROM Department;
GO
--
REVERT;
GO 
--
SELECT DepartmentName, DepartmentEmail, DepartmentHeadUserName
FROM Department;
GO
--
EXECUTE AS USER = 'Riccobon';
GO
print user
go
-- Riccobon
SELECT DepartmentName, DepartmentEmail, DepartmentHeadUserName
FROM Department;
GO

-- Riccobon NO TIENE PERMISO PARA BORRAR
DELETE FROM Department WHERE Departmentname ='Electrical Dptm'
GO
--Msg 229, Level 14, State 5, Line 186
--The DELETE permission was denied on the object 'Department', database 'RLS_F1', schema 'dbo'.
REVERT
GO

GRANT DELETE ON dbo.Department TO Manzoni;
GRANT DELETE ON dbo.Department TO Riccobon;
GRANT DELETE ON dbo.Department TO Perrone;
GO

EXECUTE AS USER = 'Riccobon';
GO
DELETE FROM Department WHERE Departmentname ='Electrical Dptm'
GO
-- (1 row affected)
SELECT DepartmentName, DepartmentEmail, DepartmentHeadUserName
FROM Department;
GO
--
REVERT
GO
-- SE AÑADE POLITICA PARA PREVENIR BORRADO
ALTER SECURITY POLICY FilterDepartment
ADD BLOCK PREDICATE dbo.fn_RowLevelSecurity(DepartmentHeadUserName)
ON dbo.Department BEFORE DELETE 
GO 
EXECUTE AS USER = 'Riccobon';
GO
DELETE FROM Department WHERE Departmentname ='aerodynamic Dptm'
GO

SELECT DepartmentName, DepartmentEmail, DepartmentHeadUserName
FROM Department;
GO
--
REVERT
GO