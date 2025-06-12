--Procedimientos Almacenados Para TipoCerveza
--Autor: Steve Yunior Huaman Peña
--Fecha: 12/06/2025

USE [Cervezeria AndeBrew]
GO

-- Procedimiento para Listar Tipos de Cerveza
IF OBJECT_ID('spListarTipoCerveza') IS NOT NULL
	DROP PROC spListarTipoCerveza
GO
CREATE PROC spListarTipoCerveza
AS
BEGIN
	SELECT TipoID, Nombre, Descripcion, GraduacionAlcoholica, Color, FechaCreacion
	FROM TipoCerveza
END
GO

EXEC spListarTipoCerveza
GO

-- Procedimiento para Agregar un Tipo de Cerveza
IF OBJECT_ID('spAgregarTipoCerveza', 'P') IS NOT NULL
	DROP PROCEDURE spAgregarTipoCerveza
GO
CREATE PROCEDURE spAgregarTipoCerveza
@Nombre NVARCHAR(100), @Descripcion NVARCHAR(500), @GraduacionAlcoholica DECIMAL(5,2), @Color NVARCHAR(50)
AS
BEGIN

-- Verificar que el nombre no esté duplicado
	IF NOT EXISTS (SELECT Nombre FROM TipoCerveza WHERE Nombre = @Nombre)
	BEGIN
		INSERT INTO TipoCerveza (Nombre, Descripcion, GraduacionAlcoholica, Color)
		VALUES (@Nombre, @Descripcion, @GraduacionAlcoholica, @Color)
		
		SELECT CodError = 0, Mensaje = 'Correcto: Tipo de cerveza agregado'
	END
	ELSE 
		SELECT CodError = 1, Mensaje = 'Error: Nombre de tipo de cerveza ya existe'
END
GO

EXEC spAgregarTipoCerveza 'Porter', 'Cerveza oscura con sabores a chocolate y café', 5.5, 'Marrón oscuro'
GO

-- Procedimiento para Eliminar un Tipo de Cerveza
IF OBJECT_ID('spEliminarTipoCerveza', 'P') IS NOT NULL
	DROP PROCEDURE spEliminarTipoCerveza
GO
CREATE PROC spEliminarTipoCerveza
@TipoID INT
AS
BEGIN
	-- Verificar que el TipoID exista
	IF EXISTS (SELECT TipoID FROM TipoCerveza WHERE TipoID = @TipoID)
	BEGIN
		-- Verificar que no esté siendo usado en la tabla Producto
		IF NOT EXISTS (SELECT TipoID FROM Producto WHERE TipoID = @TipoID)
		BEGIN
			DELETE FROM TipoCerveza WHERE TipoID = @TipoID
			SELECT CodError = 0, Mensaje = 'Correcto: Tipo de cerveza eliminado'
		END
		ELSE 
			SELECT CodError = 1, Mensaje = 'Error: El tipo de cerveza está siendo usado en productos'
	END
	ELSE 
		SELECT CodError = 1, Mensaje = 'Error: TipoID no existe'
END
GO

EXEC spEliminarTipoCerveza 4
GO

-- Procedimiento para Actualizar un Tipo de Cerveza
IF OBJECT_ID('spActualizarTipoCerveza', 'P') IS NOT NULL
	DROP PROCEDURE spActualizarTipoCerveza
GO
CREATE PROCEDURE spActualizarTipoCerveza
@TipoID INT, @Nombre NVARCHAR(100), @Descripcion NVARCHAR(500), @GraduacionAlcoholica DECIMAL(5,2), @Color NVARCHAR(50)
AS
BEGIN
	-- Verificar que el TipoID exista
	IF EXISTS (SELECT TipoID FROM TipoCerveza WHERE TipoID = @TipoID)
	BEGIN
	-- Verificar que el nuevo nombre no esté duplicado (excepto para este registro)
	IF NOT EXISTS (SELECT Nombre FROM TipoCerveza WHERE Nombre = @Nombre AND TipoID <> @TipoID)
	BEGIN
	UPDATE TipoCerveza 
	SET Nombre = @Nombre,Descripcion = @Descripcion,GraduacionAlcoholica = @GraduacionAlcoholica,Color = @Color
	WHERE TipoID = @TipoID
			
	SELECT CodError = 0, Mensaje = 'Correcto: Tipo de cerveza actualizado'
	END
	ELSE
	SELECT CodError = 1, Mensaje = 'Error: El nuevo nombre ya existe para otro tipo de cerveza'
	END
	ELSE 
	SELECT CodError = 1, Mensaje = 'Error: TipoID no existe'
END
GO

EXEC spActualizarTipoCerveza 1, 'Pilsen', 'Cerveza rubia clásica estilo checo', 4.8, 'Dorado claro'
GO

-- Procedimiento para Buscar Tipos de Cerveza
IF OBJECT_ID('spBuscarTipoCerveza') IS NOT NULL
	DROP PROC spBuscarTipoCerveza
GO
CREATE PROCEDURE spBuscarTipoCerveza
@Texto NVARCHAR(100), @Criterio NVARCHAR(20)
AS
BEGIN
	IF (@Criterio = 'TipoID')
		SELECT TipoID, Nombre, Descripcion, GraduacionAlcoholica, Color, FechaCreacion
		FROM TipoCerveza
		WHERE CAST(TipoID AS NVARCHAR) = @Texto
	ELSE IF (@Criterio = 'Nombre')
		SELECT TipoID, Nombre, Descripcion, GraduacionAlcoholica, Color, FechaCreacion
		FROM TipoCerveza
		WHERE Nombre LIKE '%' + @Texto + '%'
	ELSE IF (@Criterio = 'Graduacion')
		SELECT TipoID, Nombre, Descripcion, GraduacionAlcoholica, Color, FechaCreacion
		FROM TipoCerveza
		WHERE CAST(GraduacionAlcoholica AS NVARCHAR) LIKE '%' + @Texto + '%'
	ELSE IF (@Criterio = 'Color')
		SELECT TipoID, Nombre, Descripcion, GraduacionAlcoholica, Color, FechaCreacion
		FROM TipoCerveza
		WHERE Color LIKE '%' + @Texto + '%'
	ELSE
		SELECT TipoID, Nombre, Descripcion, GraduacionAlcoholica, Color, FechaCreacion
		FROM TipoCerveza
		WHERE Nombre LIKE '%' + @Texto + '%' OR 
			  Descripcion LIKE '%' + @Texto + '%' OR
			  Color LIKE '%' + @Texto + '%'
END
GO

EXEC spBuscarTipoCerveza 'IPA', 'Nombre'
GO
EXEC spBuscarTipoCerveza '5', 'Graduacion'
GO