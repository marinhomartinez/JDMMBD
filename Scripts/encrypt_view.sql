use master
go
--controlamos existencia
drop database if exists formula1
go
--Creamos la base de datos
CREATE DATABASE formula1;
go
-- Seleccionar la base de datos
USE formula1;
go
-- Crear la tabla "equipos"
CREATE TABLE equipos (
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(255) NOT NULL,
    motor VARCHAR(255) NOT NULL,
    piloto_principal VARCHAR(255) NOT NULL,
);
-- Crear la tabla "carreras"
CREATE TABLE carreras (
    id INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    lugar VARCHAR(255) NOT NULL,
    ganador VARCHAR(255) NOT NULL,
    segundo_puesto VARCHAR(255),
    tercer_puesto VARCHAR(255),
    equipo_id INT FOREIGN KEY REFERENCES equipos(id)
);
-- Insertar datos de prueba
INSERT INTO equipos (nombre, motor, piloto_principal)
VALUES ('Mercedes', 'Mercedes', 'Lewis Hamilton'),
       ('Red Bull Racing', 'Honda', 'Max Verstappen'),
       ('McLaren', 'Mercedes', 'Lando Norris'),
       ('Ferrari', 'Ferrari', 'Charles Leclerc');

INSERT INTO carreras (fecha, lugar, ganador, segundo_puesto, tercer_puesto, equipo_id)
VALUES ('2022-01-01', 'Melbourne', 'Lewis Hamilton', 'Max Verstappen', 'Lando Norris', 1),
       ('2022-01-08', 'Jeddah', 'Max Verstappen', 'Lewis Hamilton', 'Lando Norris', 2),
       ('2022-01-15', 'Abu Dhabi', 'Lando Norris', 'Charles Leclerc', 'Max Verstappen', 3);
--revisamos las tablas
select *
from equipos
select *
from carreras 
-- Crear la vista encriptada
CREATE VIEW dbo.v_carreras_equipos WITH ENCRYPTION AS
SELECT c.id, c.fecha, c.lugar, c.ganador, c.segundo_puesto, c.tercer_puesto, e.nombre AS nombre_equipo
FROM dbo.carreras c
JOIN dbo.equipos e ON c.equipo_id = e.id;
--Comprobamos la vista
SELECT * 
FROM dbo.v_carreras_equipos;
