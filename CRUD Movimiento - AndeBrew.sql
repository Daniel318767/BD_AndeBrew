use [Cervezeria AndeBrew]
go

if OBJECT_ID('spListarMovimiento') is not null
	drop proc spListarMovimiento
go
create proc spListarMovimiento
as
begin
	select MovimientoID, ProductoID, TipoMovimiento, Cantidad, FechaMovimiento, Motivo, UsuarioID
	from Movimiento
end
go

exec spListarMovimiento
go

--Agregar un movimiento
if OBJECT_ID('spAgregarMovimiento', 'P') is  not null
	drop proc spAgregarMovimiento
go
create procedure spAgregarMovimiento
@ProductoID INT, @TipoMovimiento NVARCHAR(20), @Cantidad INT, @FechaMovimiento DATETIME, @Motivo NVARCHAR(200), @UsuarioID INT
as
begin
	insert into Movimiento values(@ProductoID, @TipoMovimiento , @Cantidad, @FechaMovimiento, @Motivo, @UsuarioID)
	select CodError = 0, Mensaje = 'Correcto, se inserto movimiento'
end
go

exec spListarMovimiento
go
exec spAgregarMovimiento 6, 'Entrada', 15, '2025-06-13 12:44:11.269', 'Movimiento entrada 1', 7
go

-- Eliminar movimiento
if OBJECT_ID('spEliminarMovimiento', 'P') is not null
	drop proc spEliminarMovimiento
go
create proc spEliminarMovimiento
@MovimientoID INT
as
begin
	-- Debe existir MovimientoID
	if exists(select MovimientoID from Movimiento where MovimientoID=@MovimientoID)
		begin
			delete from Movimiento where MovimientoID=@MovimientoID
			select CodError = 0, Mensaje = 'Correcto, movimiento eliminado'
		end
	else select CodError = 1, Mensaje = 'Error: MovimientoID no existe'
end
go

exec spEliminarMovimiento 101
go

-- Actualizar movimiento
if OBJECT_ID('spActualizarMovimiento', 'P') is not null
	drop proc spActualizarMovimiento
go
create proc spActualizarMovimiento
@MovimientoID INT,	@ProductoID INT, @TipoMovimiento NVARCHAR(20), @Cantidad INT, @FechaMovimiento DATETIME, @Motivo NVARCHAR(200), @UsuarioID INT
as
begin
	-- Debe existir MovimientoID
	if exists(select MovimientoID from Movimiento where MovimientoID=@MovimientoID)
		begin
			update Movimiento set ProductoID=@ProductoID, TipoMovimiento=@TipoMovimiento, Cantidad=@Cantidad, FechaMovimiento=@FechaMovimiento, Motivo=@Motivo, UsuarioID=@UsuarioID where MovimientoID=@MovimientoID
			select CodError = 0, Mensaje = 'Correcto, movimiento actualizado'
		end
	else select CodError = 1, Mensaje = 'Error: MovimientoID no existe'
end
go

exec spActualizarMovimiento 102, 9, 'Salida', 30, '2025-06-06 12:53:11.398', 'Movimiento salida 2', 10
go

-- Buscar en Movimiento
if OBJECT_ID('spBuscarMovimiento', 'P') is not null
	drop proc spBuscarMovimiento
go
create proc spBuscarMovimiento
@Texto VARCHAR(50), @Criterio VARCHAR(20)
as
begin
	if(@Criterio = 'MovimientoID')
		-- Busqueda exacta
		select MovimientoID, ProductoID, TipoMovimiento, Cantidad, FechaMovimiento, Motivo, UsuarioID
		from Movimiento
		where MovimientoID = @Texto
	else if(@Criterio = 'ProductoID')
		-- Busqueda exacta
		select ProductoID, MovimientoID, TipoMovimiento, Cantidad, FechaMovimiento, Motivo, UsuarioID
		from Movimiento
		where ProductoID = @Texto
	else if(@Criterio = 'TipoMovimiento')
		-- Busqueda sensitiva
		select TipoMovimiento, MovimientoID, ProductoID, Cantidad, FechaMovimiento, Motivo, UsuarioID
		from Movimiento
		where TipoMovimiento like '%' + @Texto
	else if(@Criterio = 'Cantidad')
		-- Busqueda exacta
		select Cantidad, MovimientoID, ProductoID, TipoMovimiento, FechaMovimiento, Motivo, UsuarioID
		from Movimiento
		where Cantidad = @Texto
	else if(@Criterio = 'FechaMovimiento')
		-- Busqueda sensitiva
		select FechaMovimiento, MovimientoID, ProductoID, TipoMovimiento, Cantidad, Motivo, UsuarioID
		from Movimiento
		where FechaMovimiento like '%' + @Texto
	else if(@Criterio = 'Motivo')
		-- Busqueda sensitiva
		select Motivo, MovimientoID, ProductoID, TipoMovimiento, Cantidad, FechaMovimiento, UsuarioID
		from Movimiento
		where Motivo like '%' + @Texto
	else if(@Criterio = 'UsuarioID')
		-- Busqueda exacta
		select UsuarioID, MovimientoID, ProductoID, TipoMovimiento, Cantidad, FechaMovimiento, Motivo
		from Movimiento
		where UsuarioID = @Texto
end
go

exec spBuscarMovimiento 'te', 'TipoMovimiento'
go
exec spBuscarMovimiento 102, 'MovimientoID'
go