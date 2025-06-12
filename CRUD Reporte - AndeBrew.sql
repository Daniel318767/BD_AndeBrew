use [Cervezeria AndeBrew]
go

if OBJECT_ID('spListarReporte') is not null
	drop proc spListarReporte
go
create proc spListarReporte
as
begin
	select ReporteID, TipoReporte, FechaGeneracion, UsuarioID, Parametros, RutaArchivo
	from Reporte
end
go

exec spListarReporte
go

--Agregar un reporte
if OBJECT_ID('spAgregarReporte', 'P') is  not null
	drop proc spAgregarReporte
go
create procedure spAgregarReporte
@TipoReporte NVARCHAR(50), @FechaGeneracion DATETIME, @UsuarioID INT, @Parametros NVARCHAR(MAX), @RutaArchivo NVARCHAR(255)
as
begin
	insert into Reporte values(@TipoReporte, @FechaGeneracion , @UsuarioID, @Parametros, @RutaArchivo)
	select CodError = 0, Mensaje = 'Correcto, se inserto reporte'
end
go

exec spListarReporte
go
exec spAgregarReporte 'Ventas', '2025-12-06 11:02:30.152', 8, 'Parámetros del reporte 101', 'C:\\Reportes\\reporte_1.pdf'
go

-- Eliminar reporte
if OBJECT_ID('spEliminarReporte', 'P') is not null
	drop proc spEliminarReporte
go
create proc spEliminarReporte
@ReporteID INT
as
begin
	-- Debe existir ReporteID
	if exists(select ReporteID from Reporte where ReporteID=@ReporteID)
		begin
			delete from Reporte where ReporteID=@ReporteID
			select CodError = 0, Mensaje = 'Correcto, boleta eliminada'
		end
	else select CodError = 1, Mensaje = 'Error: ReporteID no existe'
end
go

exec spEliminarReporte 101
go

-- Actualizar boleta
if OBJECT_ID('spActualizarReporte', 'P') is not null
	drop proc spActualizarReporte
go
create proc spActualizarReporte
@ReporteID INT, @TipoReporte NVARCHAR(50), @FechaGeneracion DATETIME, @UsuarioID INT, @Parametros NVARCHAR(MAX), @RutaArchivo NVARCHAR(255)
as
begin
	-- Debe existir ReporteID
	if exists(select ReporteID from Reporte where ReporteID=@ReporteID)
		begin
			update Reporte set TipoReporte=@TipoReporte, FechaGeneracion=@FechaGeneracion, UsuarioID=@UsuarioID, Parametros=@Parametros, RutaArchivo=@RutaArchivo where ReporteID=@ReporteID
			select CodError = 0, Mensaje = 'Correcto, reporte actualizado'
		end
	else select CodError = 1, Mensaje = 'Error: ReporteID no existe'
end
go

exec spActualizarReporte 102, 'Stock', '2025-06-06 11:12:56.126', 4, 'Parámetros del reporte 102', 'C:\\Reportes\\reporte_102.pdf'
go

-- Buscar en Reporte
if OBJECT_ID('spBuscarReporte', 'P') is not null
	drop proc spBuscarReporte
go
create proc spBuscarReporte
@Texto VARCHAR(50), @Criterio VARCHAR(20)
as
begin
	if(@Criterio = 'ReporteID')
		-- Busqueda exacta
		select ReporteID, TipoReporte, FechaGeneracion, UsuarioID, Parametros, RutaArchivo
		from Reporte
		where ReporteID = @Texto
	else if(@Criterio = 'TipoReporte')
		-- Busqueda sensitiva
		select TipoReporte, ReporteID, FechaGeneracion, UsuarioID, Parametros, RutaArchivo
		from Reporte
		where TipoReporte like '%' + @Texto
	else if(@Criterio = 'FechaGeneracion')
		-- Busqueda sensitiva
		select FechaGeneracion, ReporteID, TipoReporte, UsuarioID, Parametros, RutaArchivo
		from Reporte
		where FechaGeneracion like '%' + @Texto
	else if(@Criterio = 'UsuarioID')
		-- Busqueda exacta
		select UsuarioID, ReporteID, TipoReporte, FechaGeneracion, Parametros, RutaArchivo
		from Reporte
		where UsuarioID = @Texto
	else if(@Criterio = 'Parametros')
		-- Busqueda sensitiva
		select Parametros, ReporteID, TipoReporte, FechaGeneracion, UsuarioID, RutaArchivo
		from Reporte
		where Parametros like '%' + @Texto
	else if(@Criterio = 'RutaArchivo')
		-- Busqueda sensitiva
		select RutaArchivo, ReporteID, TipoReporte, FechaGeneracion, UsuarioID, Parametros
		from Reporte
		where RutaArchivo like '%' + @Texto
end
go

exec spBuscarReporte 'K', 'TipoReporte'
go
exec spBuscarReporte 102, 'ReporteID'
go