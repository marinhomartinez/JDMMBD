use master
go
--controlar la existencia de la base de datos 
drop database if exists F1DB
go
--crear base de datos 
CREATE DATABASE F1DB;
go
--
USE F1DB;
GO
--creamos la tabla 
CREATE TABLE Resultados (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Piloto VARCHAR(50),
    Equipo VARCHAR(50),
    Circuito VARCHAR(50),
    Fecha DATE,
    Posicion INT
);
GO
--creamos trigger
--Este trigger actualiza el campo "Fecha" con la fecha y hora actuales cada vez que se inserta una nueva fila en la tabla "Resultados"
CREATE TRIGGER ActualizarFecha
ON Resultados
WITH ENCRYPTION
AFTER INSERT

AS
BEGIN
    UPDATE Resultados
    SET Fecha = GETDATE()
    WHERE Id IN (SELECT Id FROM inserted)
END
GO
--insertamos contenido a la tabla 
INSERT INTO Resultados (Piloto, Equipo, Circuito, Fecha, Posicion)
VALUES ('Lewis Hamilton', 'Mercedes', 'Circuito de Monza', '2022-03-13', 1),
       ('Max Verstappen', 'Red Bull Racing', 'Circuito de Monza', '2022-03-13', 2),
       ('Valtteri Bottas', 'Mercedes', 'Circuito de Monza', '2022-03-13', 3),
       ('Sergio Perez', 'Red Bull Racing', 'Circuito de Monza', '2022-03-13', 4),
       ('Lando Norris', 'McLaren', 'Circuito de Monza', '2022-03-13', 5);
GO
--hacemos un select 
select *
from Resultados
go