use F1_ejemplo
go
-- Creamos una tabla para los pilotos de F1
drop table if exists pilotos_f1
go
create table pilotos_f1(
id_piloto int Primary Key Clustered,
nombre varchar(50),
apellido varchar(50),
fecha_nacimiento date,
nacionalidad varchar(50),
equipo_actual varchar(50),
SysStartTime datetime2 generated always as row start not null,
SysEndTime datetime2 generated always as row end not null,
period for System_time (SysStartTime,SysEndTime)
)
with (System_Versioning = ON (History_Table = dbo.pilotos_f1_historico)
)
Go
-- Insertamos algunos datos en la tabla "pilotos_f1"
INSERT INTO pilotos_f1 (id_piloto, nombre, apellido, fecha_nacimiento, nacionalidad, equipo_actual)
VALUES
(1, 'Lewis', 'Hamilton', '1985-01-07', 'Británica', 'Mercedes'),
(2, 'Max', 'Verstappen', '1997-09-30', 'Neerlandesa', 'Red Bull Racing'),
(3, 'Valtteri', 'Bottas', '1989-08-28', 'Finlandesa', 'Mercedes'),
(4, 'Charles', 'Leclerc', '1997-10-16', 'Monegasca', 'Ferrari'),
(5, 'Lando', 'Norris', '1999-11-13', 'Británica', 'McLaren');
--ahora hacemos un select para ver el resultao
SELECT * FROM pilotos_f1
GO
--Consultamos la tabla de historico y vemos que está vacía
SELECT * FROM [pilotos_f1_historico]
GO
--Modifico el equipo actual de Bottas de Mercedes a Alpha Romeo
UPDATE pilotos_f1
SET equipo_actual = 'Alpha Romeo'
WHERE id_piloto = '3'
select * from pilotos_f1
GO
--Podemos ver que en el histórico no se ve el cambio.
select * from pilotos_f1_historico.
go
Delete
--Delete
delete from pilotos_f1
where id_piloto = '3'
go
--Vemos que se borra el id 3
select * from pilotos_f1
GO
--Pero en el historico nos aparece
select * from pilotos_f1_historico
go
Insert
--Insert
INSERT INTO pilotos_f1 (id_piloto, nombre, apellido, fecha_nacimiento, nacionalidad, equipo_actual)
VALUES
(6, 'Sergio', 'Pérez', '1990-01-26', 'Mexicana', 'Red Bull Racing');
SELECT * FROM pilotos_f1;
--Vemos el historico 
select * from pilotos_f1_historico
go
--Ver todas las operaciones realizadas en la tabla
select *
from pilotos_f1
for system_time all
go
--Ver la tabla en un momento determinado del tiempo 
select *
from pilotos_f1
for system_time as of '2023-02-26 13:02:25.2224217'
go
--Ver los cambios en la tabla entre dos fechas determinadas
select *
from pilotos_f1
for system_time from '2023-02-24 21:47:17.3701080' to '2023-02-26 13:02:25.2224217'
go
--Between
--Ver los cambios entre dos fechas determinadas, pero tomando como referencia SysStartTime
select *
from pilotos_f1
for system_time between '2023-02-24 21:47:17.3701080' and '2023-02-26 13:02:25.2224217'
go
--Contained
--Ver los registros que hemos dado de alta en un intervalo de tiempo determinado
--Insertamos un nuevo registro y lo vemos.
INSERT INTO pilotos_f1 (id_piloto, nombre, apellido, fecha_nacimiento, nacionalidad, equipo_actual)
VALUES
(7, 'Esteban', 'Ocon', '1996-09-17', 'Francesa', 'Alpine');
GO
select *
from pilotos_f1
for system_time contained in ('2023-03-01 11:00:16.3280456','9999-12-31 23:59:59.9999999')
go
