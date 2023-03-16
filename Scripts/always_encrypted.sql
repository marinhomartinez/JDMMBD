use master
go
--Creamos la base de datos.
drop database if exists formula1 
go
create database formula1
go
use formula1
go
--creamos la tabla UsuariosFia
drop table if exists UsuariosFia
go
create table UsuariosFia
(
	id_usuario int identity(1,1) primary key,
	nombre varchar(100)not null,
	contraseña varchar(100)not null,
	num_comisario varchar(20)not null
)
go
insert into UsuariosFia (nombre, contraseña, num_comisario)
values ('Mika Salo', 'abcd1234.', '2792833445'),
		('Charlie Whiting', 'qwerty22', '4589454634'),
		('Derek Warwick', 'asdfg123', '5883988798')
go
--(3 rows affected)
--Comprobamos contenido
select *
from UsuariosFia

--Volvemos a comprobar el contenido
select *
from UsuariosFia
