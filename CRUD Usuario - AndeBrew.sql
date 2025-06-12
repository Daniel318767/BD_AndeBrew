use [Cervezeria AndeBrew]
go

if OBJECT_ID('spListarUsuario') is not null
	drop proc spListarUsuario
go
create proc spListarUsuario
as
begin
	select UsuarioID, Nombre, Apellido, Email, NombreUsuario, Contrasena, Rol, Activo, FechaOperacion
	from Usuario
end
go

exec spListarUsuario
go

--Agregar un usuario
if OBJECT_ID('spAgregarUsuario', 'P') is  not null
	drop proc spAgregarUsuario
go
create procedure spAgregarUsuario
@Nombre NVARCHAR(100), @Apellido NVARCHAR(100), @Email NVARCHAR(100), @NombreUsuario NVARCHAR(50), @Contrasena NVARCHAR(255), @Rol NVARCHAR(50), @Activo BIT, @FechaOperacion DATETIME
as
begin
	insert into Usuario values(@Nombre, @Apellido , @Email, @NombreUsuario, @Contrasena, @Rol, @Activo, @FechaOperacion)
	select CodError = 0, Mensaje = 'Correcto, se inserto usuario'
end
go

exec spListarUsuario
go
exec spAgregarUsuario 'Juan', 'Perez Ramos', 'jp@gmail.com', 'JuanPeRa12', 'JuPeRa123', 'admin', 1, '2025-06-13 11:34:30.124'
go

-- Eliminar usuario
if OBJECT_ID('spEliminarUsuario', 'P') is not null
	drop proc spEliminarUsuario
go
create proc spEliminarUsuario
@UsuarioID INT
as
begin
	-- Debe existir NroBoleta
	if exists(select UsuarioID from Usuario where UsuarioID=@UsuarioID)
		-- No debe existir NroBoleta en TDetalle
		if not exists(select UsuarioID from Movimiento where UsuarioID=@UsuarioID)
			begin
				delete from Usuario where UsuarioID=@UsuarioID
				select CodError = 0, Mensaje = 'Correcto, usuario eliminada'
			end
		else select CodError = 1, Mensaje = 'Error: UsuarioID existe en Movimiento'
	else select CodError = 1, Mensaje = 'Error: UsuarioID no existe'
end
go

exec spEliminarUsuario 102
go

-- Actualizar usuario
if OBJECT_ID('spActualizarUsuario', 'P') is not null
	drop proc spActualizarUsuario
go
create proc spActualizarUsuario
@UsuarioID INT,	@Nombre NVARCHAR(100), @Apellido NVARCHAR(100), @Email NVARCHAR(100), @NombreUsuario NVARCHAR(50), @Contrasena NVARCHAR(255), @Rol NVARCHAR(50), @Activo BIT, @FechaOperacion DATETIME
as
begin
	-- Debe existir UsuarioID
	if exists(select UsuarioID from Usuario where UsuarioID=@UsuarioID)
		begin
			update Usuario set Nombre=@Nombre, Apellido=@Apellido, Email=@Email, NombreUsuario=@NombreUsuario, Contrasena=@Contrasena, Rol=@Rol, Activo=@Activo, FechaOperacion=@FechaOperacion where UsuarioID=@UsuarioID
			select CodError = 0, Mensaje = 'Correcto, usuario actualizado'
		end
	else select CodError = 1, Mensaje = 'Error: UsuarioID no existe'
end
go

exec spActualizarUsuario 103, 'Raul', 'Gonzalez Flores', 'ragon@gmail.com', 'RaGoFlo45', 'raflogonz189', 'operador', 1, '2025-06-06 11:12:56.126'
go

-- Buscar en Usuario
if OBJECT_ID('spBuscarUsuario', 'P') is not null
	drop proc spBuscarUsuario
go
create proc spBuscarUsuario
@Texto VARCHAR(50), @Criterio VARCHAR(20)
as
begin
	if(@Criterio = 'UsuarioID')
		-- Busqueda exacta
		select UsuarioID, Nombre, Apellido, Email, NombreUsuario, Contrasena, Rol, Activo, FechaOperacion
		from Usuario
		where UsuarioID = @Texto
	else if(@Criterio = 'Nombre')
		-- Busqueda sensitiva
		select Nombre, UsuarioID, Apellido, Email, NombreUsuario, Contrasena, Rol, Activo, FechaOperacion
		from Usuario
		where Nombre like '%' + @Texto
	else if(@Criterio = 'Apellido')
		-- Busqueda sensitiva
		select Apellido, UsuarioID, Nombre, Email, NombreUsuario, Contrasena, Rol, Activo, FechaOperacion
		from Usuario
		where Apellido like '%' + @Texto
	else if(@Criterio = 'Email')
		-- Busqueda sensitiva
		select Email, UsuarioID, Nombre, Apellido, NombreUsuario, Contrasena, Rol, Activo, FechaOperacion
		from Usuario
		where Email like '%' + @Texto
	else if(@Criterio = 'NombreUsuario')
		-- Busqueda sensitiva
		select NombreUsuario, UsuarioID, Nombre, Apellido, Email, Contrasena, Rol, Activo, FechaOperacion
		from Usuario
		where NombreUsuario like '%' + @Texto
	else if(@Criterio = 'Contrasena')
		-- Busqueda sensitiva
		select Contrasena, UsuarioID, Nombre, Apellido, Email, NombreUsuario, Rol, Activo, FechaOperacion
		from Usuario
		where Contrasena like '%' + @Texto
	else if(@Criterio = 'Rol')
		-- Busqueda sensitivia
		select Rol, UsuarioID, Nombre, Apellido, Email, NombreUsuario, Contrasena, Activo, FechaOperacion
		from Usuario
		where Rol like '%' + @Texto
	else if(@Criterio = 'Activo')
		-- Busqueda sensitiva
		select Activo, UsuarioID, Nombre, Apellido, Email, NombreUsuario, Contrasena, Rol, FechaOperacion
		from Usuario
		where Activo like '%' + @Texto
	else if(@Criterio = 'FechaOperacion')
		-- Busqueda sensitiva
		select FechaOperacion, UsuarioID, Nombre, Apellido, Email, NombreUsuario, Contrasena, Rol, Activo
		from Usuario
		where FechaOperacion like '%' + @Texto
end
go

exec spBuscarUsuario 'l', 'Nombre'
go
exec spBuscarUsuario 100, 'UsuarioID'
go