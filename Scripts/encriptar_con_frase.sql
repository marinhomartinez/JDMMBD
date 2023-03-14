--Controlamos existencia.
use master
go
Drop database if exists F1_db_jdmm
go
--Se crea la base de datos 
create database F1_db_jdmm
go
--Usamos nuestra base de datos.
use F1_db_jdmm
go

--Creamos una nueva tabla llamada coches con la columna motor.
create table dbo.coches
(id_motor int not null identity(1,1),
nombre varchar(100) not null,
numerobastidor varbinary(128))
go

--insertamos valores
insert into dbo.coches (nombre, numerobastidor)
values ('Conventry Climax', ENCRYPTBYPASSPHRASE('frasejdmm', '0KDHW0J3ZY'))
go
--Intento hacer select.
select id_motor, nombre, numerobastidor
from dbo.coches
go

--intento select con frase incorrecta
select id_motor, nombre, CONVERT(varchar(50),
DECRYPTBYPASSPHRASE('frasedmm', numerobastidor))
from dbo.coches
go

--select con la frase buena
select id_motor, nombre, CONVERT(varchar(50),
DECRYPTBYPASSPHRASE('frasejdmm',numerobastidor))
from dbo.coches
go

--vamos a darle mayor seguridad a la info con un atuenticador, 
--este autenticador será cada usuario que guarda la info de esta maneracada usuario tendría 
-- encriptada su información
declare @v_Usuario sysname
set @v_Usuario = SYSTEM_USER
print SYSTEM_USER
insert into dbo.coches (nombre, numerobastidor)
values ('Honda RA621H', ENCRYPTBYPASSPHRASE('frasejdmm', '6XFOJQFWEX',1,@v_Usuario))
go

--intentamos hacer select convencional
select id_motor, nombre, numerobastidor
from dbo.coches
go

--hacemos select con la frase correcta y el autenticador correcto
declare @v_Usuario sysname
set @v_Usuario = SYSTEM_USER
select id_motor, nombre, CONVERT(varchar(50), DECRYPTBYPASSPHRASE('frasejdmm', numerobastidor,1,@v_Usuario))
from dbo.coches
go

--hacemos el select con la frase correcta y con el autenticador incorrecto
declare @v_Usuario sysname
set @v_Usuario = 'Wolff'
select id_motor, nombre, CONVERT(varchar(50), DECRYPTBYPASSPHRASE('frasejdmm', numerobastidor,1,@v_Usuario))
from dbo.coches
go
