use master
go

--Creaci�n de la clave maestra de encriptaci�n
--La opci�n ENCRYPTION BY PASSWORD se utiliza para especificar una contrase�a.
create master key encryption by password = 'Abcd1234.'


--A continuaci�n, se crea un certificado de encriptaci�n.
create certificate JDMMBackupEncryptCert
WITH SUBJECT = 'Backup Encryption Certificate'
GO

select name, pvt_key_encryption_type, subject
from sys.certificates
go

--Copia de seguridad de la clave maestra y el certificado de encriptaci�n.
backup certificate JDMMBackupEncryptCert
to file = 'C:\Backup\Backup_JDMMBackupEncryptCert.cert'
with private key
(
file = 'C:\Backup\BackupCert.pvk',
encryption by password = 'Abcd1234.'
)
go

backup master key to file ='C:\Backup\BackupMasterKey.key'
encryption by password = 'Abcd1234.'
go
--Commands completed successfully.

--Backup de la base de datos con la opci�n de encryptado y el algoritmo requerido.
backup  database F1_ejemplo
to disk = 'C:\Backup\BackupF1_ejemplo_Encrypt.bak'
with
encryption
(
algorithm = AES_256,
server certificate = JDMMBackupEncryptCert
),
stats = 10
go
--BACKUP DATABASE successfully processed 529 pages in 0.172 seconds (23.991 MB/sec).

sp_who2
go