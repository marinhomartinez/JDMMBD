--Creamos una base de datos de ejemplo
use master
go
--Controlamos existencia 
drop database if exists Formula1
go
create database Formula1
go
--usuamos nuestra db
use Formula1
go
--creamos una tabla 
create table cars (
    carid int primary key,
    teamname varchar(50),
    drivername varchar(50),
    chassis varchar(50),
    engine varchar(50),
    tyrebrand varchar(50)
);

--insertamos datos
insert into cars (carid, teamname, drivername, chassis, engine, tyrebrand)
values (1, 'mercedes', 'lewis hamilton', 'mercedes-amg f1 w12', 'mercedes', 'pirelli');

insert into cars (carid, teamname, drivername, chassis, engine, tyrebrand)
values (2, 'red bull racing', 'max verstappen', 'red bull racing rb16b', 'honda', 'pirelli');

insert into cars (carid, teamname, drivername, chassis, engine, tyrebrand)
values (3, 'ferrari', 'charles leclerc', 'ferrari sf21', 'ferrari', 'pirelli');
--hacemos select para comprobar 
select *
from dbo. cars
go
--creamos procedimiento alamcenado para añadir coche.
use formula1;
go
create procedure addcar
    @carid int,
    @teamname varchar(50),
    @drivername varchar(50),
    @chassis varchar(50),
    @engine varchar(50),
    @tyrebrand varchar(50)
as
begin
    insert into cars (carid, teamname, drivername, chassis, engine, tyrebrand)
    values (@carid, @teamname, @drivername, @chassis, @engine, @tyrebrand);
end;

--los procedimientos almacenados los podemos ver por GUI o con un simple select
use formula1;
go
select *
from sys.procedures;
--select más detallado
select definition
from sys.sql_modules
where object_id = object_id('addcar');

--probando procedimeinto alamcenado
exec addcar 4, 'mclaren', 'lando norris', 'mclaren mcl35m', 'mercedes', 'pirelli';
--select
select *
from dbo. cars
go
--Encriptado del procedimiento almacenado
use formula1;
go
alter procedure addcar
    @carid int,
    @teamname varchar(50),
    @drivername varchar(50),
    @chassis varchar(50),
    @engine varchar(50),
    @tyrebrand varchar(50)
with encryption
as
begin
    insert into cars (carid, teamname, drivername, chassis, engine, tyrebrand)
    values (@carid, @teamname, @drivername, @chassis, @engine, @tyrebrand);
end;

--Ver si el procedimeinto almacenado está encriptado
sp_helptext addcar;
--The text for object 'addcar' is encrypted.
