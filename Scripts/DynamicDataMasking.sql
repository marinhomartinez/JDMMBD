-- Crear una nueva base de datos llamada Formula1Data
use master
go
drop database if exists formula1data
go
create database formula1data;
go
use formula1data;
go
-- Creamos una tabla llamada DriverInfo
create table driverinfo(
    id_driver int primary key,
    firstname nvarchar(50) not null,
    lastname nvarchar(50) masked with (function = 'default()') not null,
    birthdate date masked with (function = 'default()') not null,
    country nvarchar(50) masked with (function = 'default()') not null,
    team nvarchar(50) not null,
    helmet_color nvarchar(20) masked with (function = 'default()') not null,
    points_earned int not null,
    podium_finishes int not null,
    fastest_laps int masked with (function = 'default()') not null,
    worldchampion bit not null
);
go
-- Insertar datos en la tabla DriverInfo
insert into driverinfo
values (1, 'lewis', 'hamilton', '1985-01-07', 'reino unido', 'mercedes', 'rojo', 4081, 175, 59, 7),
(2, 'max', 'verstappen', '1997-09-30', 'países bajos', 'red bull racing', 'amarillo', 1224, 48, 24, 0),
(3, 'sergio', 'pérez', '1990-01-26', 'méxico', 'red bull racing', 'rosa', 1351, 11, 9, 0),
(4, 'valtteri', 'bottas', '1989-08-28', 'finlandia', 'mercedes', 'azul', 1798, 68, 17, 0),
(5, 'charles', 'leclerc', '1997-10-16', 'mónaco', 'ferrari', 'rojo', 747, 13, 7, 0);
go
--(5 rows affected)

--Mostramos los registros de la tabla DriverInfo
select *
from dbo.driverinfo
go
-- Creamos un usuario sin login y le damos permiso de solo lectura en la tabla DriverInfo
use formula1data;
go
create user user1 without login;
grant select on object::dbo.driverinfo to user1;  
go
-- Ejecutamos consulta en la tabla DriverInfo con el user1
execute as user = 'user1';
select *
from driverinfo;
--
revert;
go
--
print user
go
--dbo
-- Damos permiso a user1 para desenmascarar los datos y luego lo revocamos
grant unmask to user1;
go
revoke unmask to user1;  
go
-- Mostramos las columnas enmascaradas de la tabla DriverInfo
select object_name(object_id) tablename, 
    name columnname, 
    masking_function maskfunction
from sys.masked_columns
order by tablename, columnname; 
go

-- Aplicamos una máscara parcial a la columna Country
alter table driverinfo
    alter column country nvarchar(50)
        masked with (function = 'partial(1, "xx", 1)') not null;
go
--Mostramos los registros de la tabla DriverInfo
select  id_driver, country from driverinfo;
go
--Mostramos los registros de la tabla DriverInfo con user1
execute as user = 'user1';
select id_driver, country from driverinfo;
revert;
go

--Aplicamos una máscara random
alter table driverinfo
    alter column fastest_laps int
        masked with (function = 'random(1, 10)') null;
go
--select con dbo
select  id_driver, fastest_laps from driverinfo;
go
--Mostramos ahora el contendio de fastest_laps con user1
execute as user = 'user1';
select id_driver, fastest_laps from driverinfo;
revert;
go

