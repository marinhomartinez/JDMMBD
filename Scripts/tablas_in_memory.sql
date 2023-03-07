--creamos el filegroup
	ALTER DATABASE F1_ejemplo
	ADD FILEGROUP F1_mod
	CONTAINS memory_optimized_data
	GO

	--agregamos el contenedor MEMORY_OPTIMIZED_DATA filegroup
	ALTER DATABASE F1_ejemplo
	ADD FILE (NAME='F1_mod1',
	FILENAME='c:\F1_mod1')
	TO FILEGROUP F1_mod
	GO

--Ahora creamos una tabla y la comprobamos.
	USE F1_ejemplo
	GO
	DROP TABLE IF EXISTS Pilotos
	GO
	CREATE TABLE Pilotos (
	id_piloto INT PRIMARY KEY NONCLUSTERED,
	Nombre VARCHAR(50) NOT NULL,
	Apellido VARCHAR(50) NOT NULL,
	Nacionalidad VARCHAR(50) NOT NULL,
	Equipo VARCHAR(50) NOT NULL,
	Campeonatos_ganados INT NOT NULL
	)
	WITH
	(MEMORY_OPTIMIZED = ON,
	DURABILITY = SCHEMA_AND_DATA);
	GO
