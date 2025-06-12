--PROCEDIMIENTOS ALMACENADOS para TABLA PRODUCTO
--AUTOR : DANIEL BENJAMIN QUISPIRROCA BENITEZ
--FECHA : 12/06/25

--LISTAR TABLA PRODUCTO

USE [Cervezeria AndeBrew]
GO
IF OBJECT_ID('spListarProducto') IS NOT NULL
    DROP PROC spListarProducto
GO

CREATE PROC spListarProducto
AS
BEGIN
    SELECT 
        ProductoID,
        TipoID,
        Nombre,
        Descripcion,
        PrecioUnitario,
        UnidadMedida,
        CapacidadML,
        ProveedorID,
        Activo
    FROM Producto
END

EXEC spListarProducto
GO

--AGREGAR PRODUCTO

IF OBJECT_ID('spAgregarProducto', 'P') IS NOT NULL
    DROP PROCEDURE spAgregarProducto
GO

CREATE PROCEDURE spAgregarProducto
    @TipoID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(500),
    @PrecioUnitario DECIMAL(10,2),
    @UnidadMedida NVARCHAR(20),
    @CapacidadML INT,
    @ProveedorID INT,
    @Activo BIT = 1
AS
BEGIN
    -- Verificar si el producto ya existe por nombre
    IF NOT EXISTS (SELECT 1 FROM Producto WHERE Nombre = @Nombre)
    BEGIN
        INSERT INTO Producto (TipoID, Nombre, Descripcion, PrecioUnitario, UnidadMedida, CapacidadML, ProveedorID, Activo)
        VALUES (@TipoID, @Nombre, @Descripcion, @PrecioUnitario, @UnidadMedida, @CapacidadML, @ProveedorID, @Activo)

        SELECT Codigo = 0, Mensaje = 'Correcto, se insertó el producto.'
    END
    ELSE
        SELECT Codigo = 1, Mensaje = 'ERROR: El nombre del producto ya existe.'
END
GO

EXEC spAgregarProducto 
    @TipoID = 1, 
    @Nombre = 'Cerveza Dorada Especial',
    @Descripcion = 'Cerveza ligera de temporada',
    @PrecioUnitario = 8.50,
    @UnidadMedida = 'Botella',
    @CapacidadML = 500,
    @ProveedorID = 1,  
    @Activo = 1;

--ELIMINAR PRODUCTO

IF OBJECT_ID('spEliminarProducto', 'P') IS NOT NULL
    DROP PROCEDURE spEliminarProducto
GO

CREATE PROCEDURE spEliminarProducto
    @ProductoID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Producto WHERE ProductoID = @ProductoID)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Inventario WHERE ProductoID = @ProductoID)
            AND NOT EXISTS (SELECT 1 FROM Produccion WHERE ProductoID = @ProductoID)
            AND NOT EXISTS (SELECT 1 FROM Movimiento WHERE ProductoID = @ProductoID)
        BEGIN
            DELETE FROM Producto WHERE ProductoID = @ProductoID
            SELECT CodError = 0, Mensaje = 'Correcto, Producto eliminado.'
        END
        ELSE
        BEGIN
            SELECT CodError = 1, Mensaje = 'ERROR: Producto está relacionado y no se puede eliminar.'
        END
    END
    ELSE
    BEGIN
        SELECT CodError = 1, Mensaje = 'ERROR: ProductoID no existe.'
    END
END
GO

EXEC spEliminarProducto @ProductoID = 2;

--ACTUALIZAR PRODUCTO

IF OBJECT_ID('spActualizarProducto', 'P') IS NOT NULL
    DROP PROCEDURE spActualizarProducto
GO

CREATE PROCEDURE spActualizarProducto
    @ProductoID INT,
    @TipoID INT,
    @Nombre NVARCHAR(100),
    @Descripcion NVARCHAR(500),
    @PrecioUnitario DECIMAL(10,2),
    @UnidadMedida NVARCHAR(20),
    @CapacidadML INT,
    @ProveedorID INT,
    @Activo BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Producto WHERE ProductoID = @ProductoID)
    BEGIN
        UPDATE Producto
        SET TipoID = @TipoID,
            Nombre = @Nombre,
            Descripcion = @Descripcion,
            PrecioUnitario = @PrecioUnitario,
            UnidadMedida = @UnidadMedida,
            CapacidadML = @CapacidadML,
            ProveedorID = @ProveedorID,
            Activo = @Activo
        WHERE ProductoID = @ProductoID

        SELECT CodError = 0, Mensaje = 'Producto actualizado correctamente.'
    END
    ELSE
    BEGIN
        SELECT CodError = 1, Mensaje = 'ERROR: ProductoID no existe.'
    END
END
GO

EXEC spActualizarProducto 
    @ProductoID = 2,
    @TipoID = 4,
    @Nombre = 'CERVEZA PARA NINOS',
    @Descripcion = 'Cerveza con nuevo perfil de sabor',
    @PrecioUnitario = 12.50,
    @UnidadMedida = 'Botella',
    @CapacidadML = 500,
    @ProveedorID = 1,
    @Activo = 1
GO

--BUSCAR PRODUCTO

IF OBJECT_ID('spBuscarProducto') IS NOT NULL
    DROP PROC spBuscarProducto
GO

CREATE PROC spBuscarProducto
@Numero NVARCHAR(100), @Criterio VARCHAR(20)
AS
BEGIN
    IF(@Criterio = 'ProductoID')
        SELECT * FROM Producto WHERE ProductoID = @Numero
    ELSE IF(@Criterio = 'Nombre')
        SELECT * FROM Producto WHERE Nombre LIKE '%' + @Numero + '%'
    ELSE IF(@Criterio = 'TipoID')
        SELECT * FROM Producto WHERE TipoID = @Numero
    ELSE IF(@Criterio = 'ProveedorID')
        SELECT * FROM Producto WHERE ProveedorID = @Numero
END
GO

EXEC spBuscarProducto '1', 'ProductoID'
GO
