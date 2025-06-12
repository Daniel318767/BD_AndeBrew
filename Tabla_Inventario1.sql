--PROCEDIMIENTOS ALMACENADOS para TABLA INVENTARIO
--AUTOR : DANIEL BENJAMIN QUISPIRROCA BENITEZ
--FECHA : 09/06/25

SELECT*
FROM Inventario

--LISTAR TABLA INVENTARIO

USE [Cervezeria AndeBrew]
GO
if OBJECT_ID('spListarIventario') is not null
	DROP PROC spListarIventario
go

CREATE PROC spListarIventario
AS
BEGIN
	SELECT 
		InventarioID,
        ProductoID,
        CantidadDisponible,
        CantidadMinima,
        Ubicacion,
        FechaUltimaActualizacion
	FROM Inventario
END

EXEC spListarIventario
GO

--AGREGAR INVENTARIO

IF OBJECT_ID('spAgregarInventario','P') IS NOT NULL
    DROP PROCEDURE spAgregarInventario
GO

CREATE PROCEDURE spAgregarInventario
    @ProductoID INT,
    @CantidadDisponible INT,
    @CantidadMinima INT = 0,
    @Ubicacion NVARCHAR(100),
    @FechaUltimaActualizacion DATETIME
AS
BEGIN
    -- Validar que el producto existe
    IF EXISTS (SELECT 1 FROM Producto WHERE ProductoID = @ProductoID)
    BEGIN
        INSERT INTO Inventario (ProductoID, CantidadDisponible, CantidadMinima, Ubicacion, FechaUltimaActualizacion)
        VALUES (@ProductoID, @CantidadDisponible, @CantidadMinima, @Ubicacion, @FechaUltimaActualizacion)

        SELECT Codigo = 0, Mensaje = 'Correcto, se insertó en el Inventario.'
    END
    ELSE
    BEGIN
        SELECT Codigo = 1, Mensaje = 'ERROR: ProductoID no existe.'
    END
END
GO


EXEC spAgregarInventario  1, 100, 20, 'Almacén A', '2025-06-12 04:50:26.587';   
GO

--ELIMINAR INVENTARIO
IF OBJECT_ID('spEliminarInventario', 'P') IS NOT NULL
    DROP PROCEDURE spEliminarInventario
GO

CREATE PROCEDURE spEliminarInventario
    @InventarioID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Inventario WHERE InventarioID = @InventarioID)
    BEGIN
        DELETE FROM Inventario WHERE InventarioID = @InventarioID
        SELECT CodError = 0, Mensaje = 'Correcto, Inventario eliminado.'
    END
    ELSE
    BEGIN
        SELECT CodError = 1, Mensaje = 'ERROR: InventarioID no existe.'
    END
END
GO

EXEC spEliminarInventario @InventarioID = 3;

--ACTUALIZAR INVENTARIO

IF OBJECT_ID('spActualizarInventario', 'P') IS NOT NULL
    DROP PROCEDURE spActualizarInventario
GO

CREATE PROCEDURE spActualizarInventario
    @InventarioID INT,
    @ProductoID INT,
    @CantidadDisponible INT,
    @CantidadMinima INT,
    @Ubicacion NVARCHAR(100),
    @FechaUltimaActualizacion DATETIME
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Inventario WHERE InventarioID = @InventarioID)
    BEGIN
        UPDATE Inventario
        SET ProductoID = @ProductoID,
            CantidadDisponible = @CantidadDisponible,
            CantidadMinima = @CantidadMinima,
            Ubicacion = @Ubicacion,
            FechaUltimaActualizacion = @FechaUltimaActualizacion
        WHERE InventarioID = @InventarioID

        SELECT CodError = 0, Mensaje = 'Inventario actualizado correctamente.'
    END
    ELSE
    BEGIN
        SELECT CodError = 1, Mensaje = 'ERROR: InventarioID no existe.'
    END
END
GO

EXEC spActualizarInventario 
    @InventarioID = 1, 
    @ProductoID = 2, 
    @CantidadDisponible = 120, 
    @CantidadMinima = 10, 
    @Ubicacion = 'Almacén Central', 
    @FechaUltimaActualizacion = '2025-06-12'
GO

--BUSCAR INVENTARIO

IF OBJECT_ID('spBuscarInventario') IS NOT NULL
    DROP PROC spBuscarInventario
GO

CREATE PROC spBuscarInventario
@Numero NVARCHAR(100), @Criterio VARCHAR(20)
AS
BEGIN
    IF(@Criterio = 'InventarioID')
        SELECT * FROM Inventario WHERE InventarioID = @Numero
    ELSE IF(@Criterio = 'ProductoID')
        SELECT * FROM Inventario WHERE ProductoID = @Numero
    ELSE IF(@Criterio = 'Ubicacion')
        SELECT * FROM Inventario WHERE Ubicacion LIKE '%' + @Numero + '%'
    ELSE IF(@Criterio = 'Fecha')
        SELECT * FROM Inventario WHERE CONVERT(DATE, FechaUltimaActualizacion) = @Numero
END
GO

EXEC spBuscarInventario '1', 'ProductoID'
GO


