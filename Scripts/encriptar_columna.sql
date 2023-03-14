-- Step 1 - Create MSSQL sample database
USE master
GO
IF DB_ID('F1Db') IS NOT NULL
DROP DATABASE [F1Db]
GO
CREATE DATABASE [F1Db];
GO

-- Step 2 - Create Test Table, init data & verify
USE [F1Db]
GO
IF OBJECT_ID('dbo.DriverInfo', 'U') IS NOT NULL
DROP TABLE dbo.DriverInfo
CREATE TABLE dbo.DriverInfo
(
DriverId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
DriverName VARCHAR(100) NOT NULL,
Team VARCHAR(100) NOT NULL,
Salary VARCHAR(10) NOT NULL
);
-- Init Table
INSERT INTO dbo.DriverInfo
VALUES ('Lewis Hamilton', 'Mercedes','45.5 Mill')
,('Max Verstappen', 'Red Bull', '25.5 Mill')
,('Sergio Perez', 'Red Bull', '15 Mill')
,('Lando Norris', 'McLaren', '8.0 Mill')
GO
-- Verify data
SELECT *
FROM dbo.DriverInfo
GO

-- Step 3 - Create SQL Server Service Master Key
USE master;
GO
IF NOT EXISTS(
SELECT *
FROM sys.symmetric_keys
WHERE name = '##MS_ServiceMasterKey##')
BEGIN
CREATE MASTER KEY ENCRYPTION BY
PASSWORD = 'MSSQLSerivceMasterKey'
END;
GO

--Create Database-Level Master Keys
--Under F1Db in the user database, create Master Keys:

-- Step 4 - Create MSSQL Database level master key
USE [F1Db]
GO
IF NOT EXISTS (SELECT *
FROM sys.symmetric_keys
WHERE name LIKE '%MS_DatabaseMasterKey%')
BEGIN
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Abcd1234.';
END
GO

-- Create Asymmetric Keys
-- Under the user database, create asymmetric keys and encrypt them with a password:

-- Step 5 - Create MSSQL asymmetric Key
USE [F1Db]
GO
CREATE ASYMMETRIC KEY [AsymKey_F1Db]
WITH ALGORITHM = RSA_2048
ENCRYPTION BY PASSWORD = 'Password4@Asy'
GO

-- View Asymmetric Keys
-- You can use the following query statement to view asymmetric keys:

USE [F1Db]
GO
SELECT *
FROM sys.asymmetric_keys
GO

-- Step 6 - Change your table structure
USE [F1Db]
GO
ALTER TABLE DriverInfo
ADD EncryptedSalary varbinary(MAX) NULL
GO

-- Step 7 - Init the encrypted data into the newly column
USE [F1Db]
GO
UPDATE A
SET EncryptedSalary = ENCRYPTBYASYMKEY(ASYMKEY_ID('AsymKey_F1Db'), Salary)
FROM dbo.DriverInfo AS A;
GO

-- Double-check the encrypted data of the new column
SELECT * FROM dbo.DriverInfo
GO

-- Step 8 - Reading the SQL Server encrypted data
USE [F1Db]
GO
SELECT 
    *,
    DecryptedSalary = CONVERT(VARCHAR(50), DECRYPTBYASYMKEY(ASYMKEY_ID('AsymKey_F1Db'), EncryptedSalary, N'Password4@Asy'))
FROM dbo.DriverInfo;
GO
--Bad password
USE [F1Db]
GO
SELECT 
    *,
    DecryptedSalary = CONVERT(VARCHAR(50), DECRYPTBYASYMKEY(ASYMKEY_ID('AsymKey_F1Db'), EncryptedSalary, N'Abcd1234.'))
FROM dbo.DriverInfo;
GO
--Msg 15466, Level 16, State 9, Line 103
--An error occurred during decryption.

--Step 9
INSERT INTO dbo.DriverInfo
VALUES ('Carlos Sainz', 'Ferrari', '8,5 Mill', ENCRYPTBYASYMKEY( ASYMKEY_ID('AsymKey_F1Db'), '8,5 Mill'));  
GO

SELECT * FROM dbo.DriverInfo
GO
-- Step 10 -- Intentamos aztulizar algún sueldo.
USE [F1Db]
GO
UPDATE A
SET EncryptedSalary = ENCRYPTBYASYMKEY( ASYMKEY_ID('AsymKey_F1Db'), '16 Mill')
FROM dbo.DriverInfo AS A
WHERE CONVERT(VARCHAR(50), DECRYPTBYASYMKEY(ASYMKEY_ID('AsymKey_F1Db'), EncryptedSalary, N'Password4@Asy')) = '15 Mill'
GO

SELECT * FROM dbo.DriverInfo
GO

---- Step 11 Eliminar columna vieja.
USE [F1Db]
GO
ALTER TABLE DriverInfo
DROP COLUMN Salary;
GO
SELECT
	*,
	 DecryptedSalary = CONVERT(VARCHAR(50), DECRYPTBYASYMKEY(ASYMKEY_ID('AsymKey_F1Db'), EncryptedSalary, N'Password4@Asy'))
FROM DriverInfo

--Step 12
USE [F1Db]
GO
CREATE LOGIN user_jdmm
    WITH PASSWORD=N'Abcd1234.', CHECK_POLICY = OFF;
GO
CREATE USER user_jdmm FOR LOGIN user_jdmm;
GRANT SELECT ON OBJECT::dbo.DriverInfo TO user_jdmm;
GO


--Impersonamos.
EXECUTE AS USER = 'user_jdmm'
GO
SELECT
	*,
	 DecryptedSalary = CONVERT(VARCHAR(50), DECRYPTBYASYMKEY(ASYMKEY_ID('AsymKey_F1Db'), EncryptedSalary, N'Password4@Asy'))
FROM DriverInfo

--Damos permiso a ese usuario.
USE [F1Db]
GO
GRANT VIEW DEFINITION ON 
    ASYMMETRIC KEY::[AsymKey_F1Db] TO [user_jdmm];
GO
GRANT CONTROL ON 
    ASYMMETRIC KEY::[AsymKey_F1Db] TO [user_jdmm];
GO
-- Vemos ahora si podemos ver los sueldos.
EXECUTE AS USER = 'user_jdmm'
GO
SELECT
	*,
	 DecryptedSalary = CONVERT(VARCHAR(50), DECRYPTBYASYMKEY(ASYMKEY_ID('AsymKey_F1Db'), EncryptedSalary, N'Password4@Asy'))
FROM DriverInfo

SELECT CURRENT_USER usuaro_actual;