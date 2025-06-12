--PROCEDIMIENTOS ALMACENADOS para TABLA PROVEDOR
--AUTOR : DANIEL BENJAMIN QUISPIRROCA BENITEZ
--FECHA : 12/06/25

--LISTAR TABLA PROVEDOR 

USE [Cervezeria AndeBrew]
GO
IF OBJECT_ID('spListarProveedor') IS NOT NULL
    DROP PROC spListarProveedor
GO

CREATE PROC spListarProveedor
AS
BEGIN
    SELECT 
        ProveedorID,
        Nombre,
        RUC,
        Direccion,
        Telefono,
        Email,
        ContactoPrincipal,
        TipoProveedor,
        Activo,
        FechaRegistro,
        Notas
    FROM Proveedor
END

EXEC spListarProveedor
GO

--AGREGAR PROVEDOR

IF OBJECT_ID('spAgregarProveedor', 'P') IS NOT NULL
    DROP PROCEDURE spAgregarProveedor
GO

CREATE PROCEDURE spAgregarProveedor
    @Nombre NVARCHAR(100),
    @RUC NVARCHAR(20),
    @Direccion NVARCHAR(200),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100),
    @ContactoPrincipal NVARCHAR(100),
    @TipoProveedor NVARCHAR(50),
    @Activo BIT = 1,
    @Notas NVARCHAR(MAX)
AS
BEGIN
    -- Verificar si ya existe proveedor con el mismo RUC
    IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE RUC = @RUC)
    BEGIN
        INSERT INTO Proveedor (Nombre, RUC, Direccion, Telefono, Email, ContactoPrincipal, TipoProveedor, Activo, Notas)
        VALUES (@Nombre, @RUC, @Direccion, @Telefono, @Email, @ContactoPrincipal, @TipoProveedor, @Activo, @Notas)

        SELECT Codigo = 0, Mensaje = 'Correcto, se insertó el proveedor.'
    END
    ELSE
        SELECT Codigo = 1, Mensaje = 'ERROR: El RUC ya está registrado.'
END
GO

EXEC spAgregarProveedor
    @Nombre = 'Distribuidora Andina',
    @RUC = '98765432100',
    @Direccion = 'Jr. Malta 456',
    @Telefono = '987654321',
    @Email = 'andina@proveedor.com',
    @ContactoPrincipal = 'Sra. Malta',
    @TipoProveedor = 'Importador',
    @Activo = 1,
    @Notas = 'Proveedor confiable del sur';


--ELIMINAR PROVEDOR

IF OBJECT_ID('spEliminarProveedor', 'P') IS NOT NULL
    DROP PROCEDURE spEliminarProveedor
GO

CREATE PROCEDURE spEliminarProveedor
    @ProveedorID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Proveedor WHERE ProveedorID = @ProveedorID)
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE ProveedorID = @ProveedorID)
        BEGIN
            DELETE FROM Proveedor WHERE ProveedorID = @ProveedorID
            SELECT CodError = 0, Mensaje = 'Correcto, Proveedor eliminado.'
        END
        ELSE
        BEGIN
            SELECT CodError = 1, Mensaje = 'ERROR: Proveedor está relacionado con productos.'
        END
    END
    ELSE
    BEGIN
        SELECT CodError = 1, Mensaje = 'ERROR: ProveedorID no existe.'
    END
END
GO

EXEC spEliminarProveedor @ProveedorID = 4;

--ACTUALIZAR PROVEDOR

IF OBJECT_ID('spActualizarProveedor', 'P') IS NOT NULL
    DROP PROCEDURE spActualizarProveedor
GO

CREATE PROCEDURE spActualizarProveedor
    @ProveedorID INT,
    @Nombre NVARCHAR(100),
    @RUC NVARCHAR(20),
    @Direccion NVARCHAR(200),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(100),
    @ContactoPrincipal NVARCHAR(100),
    @TipoProveedor NVARCHAR(50),
    @Activo BIT,
    @Notas NVARCHAR(MAX)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Proveedor WHERE ProveedorID = @ProveedorID)
    BEGIN
        UPDATE Proveedor
        SET Nombre = @Nombre,
            RUC = @RUC,
            Direccion = @Direccion,
            Telefono = @Telefono,
            Email = @Email,
            ContactoPrincipal = @ContactoPrincipal,
            TipoProveedor = @TipoProveedor,
            Activo = @Activo,
            Notas = @Notas
        WHERE ProveedorID = @ProveedorID

        SELECT CodError = 0, Mensaje = 'Proveedor actualizado correctamente.'
    END
    ELSE
    BEGIN
        SELECT CodError = 1, Mensaje = 'ERROR: ProveedorID no existe.'
    END
END
GO

EXEC spActualizarProveedor 
    @ProveedorID = 1,
    @Nombre = 'Lúpulo Andino SAC',
    @RUC = '20345678901',
    @Direccion = 'Av. Los Cerveceros 123',
    @Telefono = '999888777',
    @Email = 'ventas@lupuloandino.com',
    @ContactoPrincipal = 'Ing. Martín Cordero',
    @TipoProveedor = 'Nacional',
    @Activo = 1,
    @Notas = 'Proveedor confiable de lúpulo desde 2019.'
GO

--BUSCAR PROVEDOR

IF OBJECT_ID('spBuscarProveedor') IS NOT NULL
    DROP PROC spBuscarProveedor
GO

CREATE PROC spBuscarProveedor
@Numero NVARCHAR(100), @Criterio VARCHAR(20)
AS
BEGIN
    IF(@Criterio = 'ProveedorID')
        SELECT * FROM Proveedor WHERE ProveedorID = @Numero
    ELSE IF(@Criterio = 'Nombre')
        SELECT * FROM Proveedor WHERE Nombre LIKE '%' + @Numero + '%'
    ELSE IF(@Criterio = 'RUC')
        SELECT * FROM Proveedor WHERE RUC = @Numero
    ELSE IF(@Criterio = 'Activo')
        SELECT * FROM Proveedor WHERE Activo = @Numero
END
GO

EXEC spBuscarProveedor '1', 'Activo'
GO


