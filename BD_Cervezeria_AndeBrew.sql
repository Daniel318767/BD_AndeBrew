-- Creación de la base de datos
CREATE DATABASE [Cervezeria AndeBrew];
GO

USE [Cervezeria AndeBrew];
GO

-- Tabla TipoCerveza (debe crearse primero por las dependencias)
CREATE TABLE TipoCerveza (
    TipoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(500),
    GraduacionAlcoholica DECIMAL(5,2),
    Color NVARCHAR(50),
    FechaCreacion DATETIME DEFAULT GETDATE()
);
GO

-- Tabla Proveedor
CREATE TABLE Proveedor (
    ProveedorID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    RUC NVARCHAR(20) UNIQUE NOT NULL,
    Direccion NVARCHAR(200),
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    ContactoPrincipal NVARCHAR(100),
    TipoProveedor NVARCHAR(50),
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Notas NVARCHAR(MAX)
);
GO

-- Tabla Producto
CREATE TABLE Producto (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    TipoID INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(500),
    PrecioUnitario DECIMAL(10,2),
    UnidadMedida NVARCHAR(20),
    CapacidadML INT,
    ProveedorID INT NOT NULL,
    Activo BIT DEFAULT 1,
    CONSTRAINT FK_Producto_TipoCerveza FOREIGN KEY (TipoID) REFERENCES TipoCerveza(TipoID),
    CONSTRAINT FK_Producto_Proveedor FOREIGN KEY (ProveedorID) REFERENCES Proveedor(ProveedorID)
);
GO

-- Tabla Usuario
CREATE TABLE Usuario (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    NombreUsuario NVARCHAR(50) UNIQUE NOT NULL,
    Contrasena NVARCHAR(255) NOT NULL,
    Rol NVARCHAR(50) NOT NULL,
    Activo BIT DEFAULT 1,
    FechaOperacion DATETIME DEFAULT GETDATE()
);
GO

-- Tabla Produccion
CREATE TABLE Produccion (
    ProduccionID INT PRIMARY KEY IDENTITY(1,1),
    ProductoID INT NOT NULL,
    CantidadProducida INT NOT NULL,
    FechaProduccion DATETIME DEFAULT GETDATE(),
    FechaCaducidad DATE,
    Lote NVARCHAR(50),
    Notas NVARCHAR(MAX),
    CONSTRAINT FK_Produccion_Producto FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID)
);
GO

-- Tabla Inventario (corregido el nombre)
CREATE TABLE Inventario (
    InventarioID INT PRIMARY KEY IDENTITY(1,1),
    ProductoID INT NOT NULL,
    CantidadDisponible INT NOT NULL,
    CantidadMinima INT DEFAULT 0,
    Ubicacion NVARCHAR(100),
    FechaUltimaActualizacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Inventario_Producto FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID)
);
GO

-- Tabla Movimiento (corregido el nombre de la PK)
CREATE TABLE Movimiento (
    MovimientoID INT PRIMARY KEY IDENTITY(1,1),
    ProductoID INT NOT NULL,
    TipoMovimiento NVARCHAR(20) NOT NULL CHECK (TipoMovimiento IN ('Entrada', 'Salida', 'Ajuste')),
    Cantidad INT NOT NULL,
    FechaMovimiento DATETIME DEFAULT GETDATE(),
    Motivo NVARCHAR(200),
    UsuarioID INT NOT NULL,
    CONSTRAINT FK_Movimiento_Producto FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID),
    CONSTRAINT FK_Movimiento_Usuario FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID)
);
GO

-- Tabla Reporte
CREATE TABLE Reporte (
    ReporteID INT PRIMARY KEY IDENTITY(1,1),
    TipoReporte NVARCHAR(50) NOT NULL,
    FechaGeneracion DATETIME DEFAULT GETDATE(),
    UsuarioID INT NOT NULL,
    Parametros NVARCHAR(MAX),
    RutaArchivo NVARCHAR(255),
    CONSTRAINT FK_Reporte_Usuario FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID)
);
GO
