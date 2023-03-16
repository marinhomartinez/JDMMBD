use master
go
--controlamos existencia
drop database if exists Formula1Stats
go
--creamos la db
create database Formula1Stats
go
-- nos ubicamos en la db
use Formula1Stats
go
--creamos la tabla 
CREATE TABLE Circuitos (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Pais VARCHAR(50) NOT NULL,
    Longitud DECIMAL(5,2) NOT NULL,
    Curvas INT NOT NULL,
    Vueltas INT NOT NULL,
    Record VARCHAR(50)
);

--insertamos contenido 
INSERT INTO Circuitos (Id, Nombre, Pais, Longitud, Curvas, Vueltas, Record)
VALUES (1, 'Circuito de Spa-Francorchamps', 'Bélgica', 7.00, 19, 44, '1:41.252'),
       (2, 'Circuito de Silverstone', 'Reino Unido', 5.89, 18, 52, '1:27.097'),
       (3, 'Circuito de Suzuka', 'Japón', 5.81, 18, 53, '1:30.983'),
       (4, 'Circuito de Monza', 'Italia', 5.79, 11, 53, '1:18.380'),
       (5, 'Circuito de Interlagos', 'Brasil', 4.31, 15, 71, '1:10.540');
--select para ver la tabla 
select *
from Circuitos
--creamos la función,(esta función toma un valor récord del circuito 
--y lo convierte en una cadena encriptada utilizando una clave fija.
CREATE FUNCTION EncriptarRecord (@record VARCHAR(50))
RETURNS VARCHAR(50)
WITH ENCRYPTION
AS
BEGIN
    DECLARE @clave VARCHAR(10) = '134679';
    DECLARE @resultado VARCHAR(50);

    SET @resultado = @record;

    IF @resultado IS NOT NULL
    BEGIN
        SET @resultado = REPLACE(@resultado, '1', @clave);
        SET @resultado = REPLACE(@resultado, '2', @clave + '2');
        SET @resultado = REPLACE(@resultado, '3', @clave + '3');
        SET @resultado = REPLACE(@resultado, '4', @clave + '4');
        SET @resultado = REPLACE(@resultado, '5', @clave + '5');
    END

    RETURN @resultado;
END;
--Probamos la función.
SELECT Id, Nombre, Pais, Longitud, Curvas, Vueltas, dbo.EncriptarRecord(Record) AS RecordEncriptado
FROM Circuitos;
--select para obtener una lista de todos los objetos llamados FUNCTION
SELECT name, type_desc
FROM sys.objects
WHERE type_desc LIKE '%FUNCTION%'

