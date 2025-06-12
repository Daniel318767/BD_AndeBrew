-- ANDEBREW_Grupo_Woody
-- PROCEDIMIENTOS ALMACENADOS para Produccion
-- Autor: Nahum Saldivar
-- Fecha: 10 / 06 / 2025

-- spListarProduccion

IF OBJECT_ID('spListarProduccion', 'P') Is not null
    DROP PROCEDURE spListarProduccion;
GO
CREATE PROCEDURE spListarProduccion
AS
BEGIN
    SELECT ProduccionID, ProductoID, CantidadProducida, FechaProduccion, FechaCaducidad, Lote, Notas
    FROM Produccion;
END;
GO

EXEC spListarProduccion;
GO


-- spAgregarProduccion

IF OBJECT_ID('spAgregarProduccion', 'P') IS NOT NULL
    DROP PROCEDURE spAgregarProduccion;
GO

CREATE PROCEDURE spAgregarProduccion
    -- Parámetros Obligatorios
    @ProductoID INT,
    @CantidadProducida INT,
    
    -- Parámetros Opcionales
    @FechaCaducidad DATE = NULL,
    @Lote NVARCHAR(50) = NULL,
    @Notas NVARCHAR(MAX) = NULL,
    @FechaProduccion DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validación: Verificar que el ProductoID existe
        IF NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE ProductoID = @ProductoID)
        BEGIN
            RAISERROR('Error: El ProductoID %d no existe en la tabla de Productos.', 16, 1, @ProductoID);
            RETURN;
        END

        -- Asignar la fecha actual si el parámetro es NULL
        IF @FechaProduccion IS NULL
        BEGIN
            SET @FechaProduccion = GETDATE();
        END

        -- Inserción de los datos en la tabla Produccion
        -- La cláusula OUTPUT devuelve los datos de la fila recién insertada
        INSERT INTO dbo.Produccion (
            ProductoID,
            CantidadProducida,
            FechaProduccion,
            FechaCaducidad,
            Lote,
            Notas
        )
        OUTPUT 
            inserted.ProduccionID, 
            inserted.ProductoID, 
            inserted.CantidadProducida, 
            inserted.FechaProduccion, 
            inserted.FechaCaducidad, 
            inserted.Lote, 
            inserted.Notas
        VALUES (
            @ProductoID,
            @CantidadProducida,
            @FechaProduccion,
            @FechaCaducidad,
            @Lote,
            @Notas
        );

    END TRY
    BEGIN CATCH
        THROW;
    END CATCH

    SET NOCOUNT OFF;
END
GO

-- Ejecutamos el procedimiento
EXEC spAgregarProduccion
    @ProductoID = 15,
    @CantidadProducida = 800,
    @Lote = 'LOTE-VISUAL-001',
    @Notas = 'Prueba con visualización de resultado.';
GO

-- spEliminarProduccion

IF OBJECT_ID('spEliminarProduccion', 'P') IS NOT NULL
    DROP PROCEDURE spEliminarProduccion;
GO
CREATE PROCEDURE spEliminarProduccion
    @ProduccionID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Produccion WHERE ProduccionID = @ProduccionID)
    BEGIN
        DELETE FROM Produccion WHERE ProduccionID = @ProduccionID;
        SELECT CodError = 0, Mensaje = 'Producción eliminada correctamente.';
    END
    ELSE
        SELECT CodError = 1, Mensaje = 'Error: ProduccionID no existe.';
END;
GO

EXEC spEliminarProduccion 15;
GO


-- spActualizarProduccion

IF OBJECT_ID('spActualizarProduccion', 'P') IS NOT NULL
    DROP PROCEDURE spActualizarProduccion;
GO

CREATE PROCEDURE spActualizarProduccion
    -- Parámetro Obligatorio para identificar el registro
    @ProduccionID INT,
    
    -- Parámetros Opcionales para la actualización
    -- Si se envían como NULL, no se actualizará el campo correspondiente
    @ProductoID INT = NULL,
    @CantidadProducida INT = NULL,
    @FechaProduccion DATETIME = NULL,
    @FechaCaducidad DATE = NULL,
    @Lote NVARCHAR(50) = NULL,
    @Notas NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1. Validación: Verificar que el ProduccionID a actualizar existe
        IF NOT EXISTS (SELECT 1 FROM dbo.Produccion WHERE ProduccionID = @ProduccionID)
        BEGIN
            RAISERROR('Error: El ProduccionID %d no existe. No se puede actualizar.', 16, 1, @ProduccionID);
            RETURN;
        END

        -- 2. Validación (Opcional pero recomendada): Si se provee un nuevo ProductoID, verificar que exista
        IF @ProductoID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Producto WHERE ProductoID = @ProductoID)
        BEGIN
            RAISERROR('Error: El nuevo ProductoID %d no existe en la tabla de Productos.', 16, 1, @ProductoID);
            RETURN;
        END

        -- 3. Actualización de los datos
        -- Se utiliza ISNULL(parametro, campo_actual) para actualizar solo los campos
        -- que no se enviaron como NULL.
        UPDATE dbo.Produccion
        SET 
            ProductoID = ISNULL(@ProductoID, ProductoID),
            CantidadProducida = ISNULL(@CantidadProducida, CantidadProducida),
            FechaProduccion = ISNULL(@FechaProduccion, FechaProduccion),
            FechaCaducidad = ISNULL(@FechaCaducidad, FechaCaducidad),
            Lote = ISNULL(@Lote, Lote),
            Notas = ISNULL(@Notas, Notas)
        WHERE 
            ProduccionID = @ProduccionID;

        PRINT 'Registro de producción con ID ' + CAST(@ProduccionID AS NVARCHAR(10)) + ' actualizado exitosamente.';

    END TRY
    BEGIN CATCH
        -- Relanzar el error para su manejo externo
        THROW;
    END CATCH

    SET NOCOUNT OFF;
END
GO

-- Ejemplo 1: Actualizar solo la cantidad y las notas de un registro de producción
-- Asumimos que existe un registro con ProduccionID = 3
EXEC spActualizarProduccion
    @ProduccionID = 3,
    @CantidadProducida = 125,
    @Notas = 'Ajuste de cantidad post-producción por control de calidad.';
GO

-- Ejemplo 2: Actualizar el lote y la fecha de caducidad del registro con ProduccionID = 7
EXEC spActualizarProduccion
    @ProduccionID = 7,
    @FechaCaducidad = '2024-12-31',
    @Lote = 'LOTE-CORREGIDO-007';
GO

-- Para verificar los cambios, puedes ejecutar:
SELECT * FROM Produccion WHERE ProduccionID IN (3, 7);


-- spBuscarProduccion

IF OBJECT_ID('spBuscarProduccion', 'P') IS NOT NULL
    DROP PROCEDURE spBuscarProduccion;
GO
CREATE PROCEDURE spBuscarProduccion
    @Texto NVARCHAR(50),
    @Criterio NVARCHAR(20)
AS
BEGIN
    IF @Criterio = 'Lote'
    BEGIN
        SELECT ProduccionID, ProductoID, CantidadProducida, FechaProduccion, FechaCaducidad, Lote, Notas
        FROM Produccion
        WHERE Lote LIKE '%' + @Texto + '%';
    END
    ELSE IF @Criterio = 'Notas'
    BEGIN
        SELECT ProduccionID, ProductoID, CantidadProducida, FechaProduccion, FechaCaducidad, Lote, Notas
        FROM Produccion
        WHERE Notas LIKE '%' + @Texto + '%';
    END
    ELSE IF @Criterio = 'ProductoID'
    BEGIN
        SELECT ProduccionID, ProductoID, CantidadProducida, FechaProduccion, FechaCaducidad, Lote, Notas
        FROM Produccion
        WHERE ProductoID = TRY_CAST(@Texto AS INT);
    END
    ELSE
    BEGIN
        SELECT CodError = 1, Mensaje = 'Error: Criterio de búsqueda no válido.';
    END
END;
GO

EXEC spBuscarProduccion 'Lote-010', 'Lote';
GO

