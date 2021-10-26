USE GD2C2021

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ABAN_DER_ADOS')
	EXEC('CREATE SCHEMA ABAN_DER_ADOS')


--------------------- Creacion de Tablas ---------------------------------

CREATE TABLE [ABAN_DER_ADOS].Chofer(
				chof_leg int NOT NULL,
				chof_nombre nvarchar(255),
				chof_apellido nvarchar(255),
				chof_dni decimal(18,0),
				chof_dire nvarchar(255),
				chof_mail nvarchar(255),
				chof_telef nvarchar(255),
				chof_fecha_nacimiento datetime2(3),
				chof_costo_hora decimal(18,0),
				CONSTRAINT PK_CHOFER PRIMARY KEY(chof_leg)

)

CREATE TABLE [ABAN_DER_ADOS].Ciudad(
				codCiudad int identity(1,1) NOT NULL,
				ciudadNombre nvarchar(255),
				CONSTRAINT PK_ciudad PRIMARY KEY(codCiudad)

)


CREATE TABLE [ABAN_DER_ADOS].TipoTarea(
				idTipoTarea nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_TIPOTAREA PRIMARY KEY(idTipoTarea)
)

CREATE TABLE [ABAN_DER_ADOS].Tarea(
				codTarea nvarchar(50) NOT NULL,
				tipoTarea nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				descripcion nvarchar(50),
				tiempoTarea int,
				CONSTRAINT PK_tarea PRIMARY KEY(codTarea),
				CONSTRAINT FK_idTipoTarea FOREIGN KEY(tipoTarea) REFERENCES [ABAN_DER_ADOS].[TipoTarea](idTipoTarea)
	
)

CREATE TABLE [ABAN_DER_ADOS].Material(
				codMaterial nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				precio int
				CONSTRAINT PK_MATERIAL PRIMARY KEY(codMaterial)
)

CREATE TABLE [ABAN_DER_ADOS].MaterialxTarea(
				codMaterial nvarchar(50) NOT NULL,
				codTarea nvarchar(50) NOT NULL,
				cantidad int,
				CONSTRAINT FK_codMaterial FOREIGN KEY(codMaterial) REFERENCES [ABAN_DER_ADOS].[Material](codMaterial),
				CONSTRAINT FK_codTarea FOREIGN KEY(codTarea) REFERENCES [ABAN_DER_ADOS].[Tarea](codTarea)
				
)



CREATE TABLE [ABAN_DER_ADOS].EstadoOT(
				int Identity(1,1) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_ESTADO PRIMARY KEY(codEstado)
				
)

CREATE TABLE [ABAN_DER_ADOS].Taller(
				idTaller int identity(1,1) NOT NULL,
				nombre nvarchar(50),
				codCiudad int NOT NULL,
				direccion nvarchar(50),
				telefono int,
				mail nvarchar(255),
				CONSTRAINT PK_TALLER PRIMARY KEY(idTaller),
				CONSTRAINT FK_codCiudad FOREIGN KEY(codCiudad) REFERENCES [ABAN_DER_ADOS].[Ciudad](codCiudad)
				
)

CREATE TABLE [ABAN_DER_ADOS].Mecanico(
				legajoMecanico int NOT NULL,
				idTaller int NOT NULL,
				nombre nvarchar(50), 
				apellido nvarchar(50), 
				DNI int NOT NULL,
				direccion nvarchar(50),
				mail nvarchar(255),
				fechaNac DATE,
				telefono int,
				costoHora int
				CONSTRAINT PK_MECANICO PRIMARY KEY(legajoMecanico),
				CONSTRAINT FK_idTaller FOREIGN KEY(idTaller) REFERENCES [ABAN_DER_ADOS].[Taller](idTaller)
)



CREATE TABLE [ABAN_DER_ADOS].Marca(
				idMarca int identity(1,1) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_MARCA PRIMARY KEY(idMarca),
				
)

CREATE TABLE [ABAN_DER_ADOS].ModeloCamion(
				idModelo int identity(1,1) NOT NULL,
				descripcion nvarchar(50),
				idMarca int NOT NULL,
				capacidadCarga int,
				capidadTanque int,
				velocidadMax int,
				CONSTRAINT PK_MODELOCAMION PRIMARY KEY(idModelo),
				CONSTRAINT FK_idMarca FOREIGN KEY(idMarca) REFERENCES [ABAN_DER_ADOS].[Marca](idMarca)
)

CREATE TABLE [ABAN_DER_ADOS].Camion(
				patenteCamion nvarchar(255) NOT NULL,
				idModelo int NOT NULL,
				marca int NOT NULL,
				fechaAlta DATE,
				nroMotor int,
				nroChasis int,
				patente int,   -- (- ojo con esto -)
				CONSTRAINT PK_CAMION PRIMARY KEY(patenteCamion),
				CONSTRAINT FK_idModelo FOREIGN KEY(idModelo) REFERENCES [ABAN_DER_ADOS].[ModeloCamion](idModelo),
				CONSTRAINT FK_idMarcaCamin FOREIGN KEY(marca) REFERENCES [ABAN_DER_ADOS].[Marca](idMarca)				
)

CREATE TABLE [ABAN_DER_ADOS].OrdenTrabajo(
				orden_cod int Identity(1,1) NOT NULL,
				orden_fecha datetime2(3),
				orden_patente_camion nvarchar(255) FOREIGN KEY REFERENCES [ABAN_DER_ADOS].[Camion](patenteCamion),
				orde_estado FOREIGN KEY REFERENCES [ABAN_DER_ADOS].[EstadoOT](codEstado),
				CONSTRAINT PK_OT PRIMARY KEY(orden_cod)
)

CREATE TABLE [ABAN_DER_ADOS].TareaxOrden(
				idOrdenTrabajo int Identity(1,1) NOT NULL,
				codTarea nvarchar(50) NOT NULL,
				legajoMecanico int,
				duracionEstimada int,
				fechaInicio DATE,
				fechaFin DATE,
				duracionReal int,
				CONSTRAINT FK_idOrdenTrabajo FOREIGN KEY(idOrdenTrabajo) REFERENCES [ABAN_DER_ADOS].[OrdenTrabajo](orden_cod),
				CONSTRAINT FK_codTareaOrden FOREIGN KEY(codTarea) REFERENCES [ABAN_DER_ADOS].[Tarea](codTarea),
				CONSTRAINT FK_legajoMecanicoOrden FOREIGN KEY(legajoMecanico) REFERENCES [ABAN_DER_ADOS].[Mecanico](legajoMecanico),
)
CREATE TABLE [ABAN_DER_ADOS].TipoPaquete(
				idTipo nvarchar(50) NOT NULL,
				pesoMax int,
				altoMax int,
				anchoMax int,
				largoMax int,
				descripcion nvarchar(50),
				precio int,
				CONSTRAINT PK_TIPOPAQUERE PRIMARY KEY(idTipo)
)

CREATE TABLE [ABAN_DER_ADOS].Paquete(
				idPaquete nvarchar(50) NOT NULL,
				tipoPaquete nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_PAQUETE PRIMARY KEY(idPaquete),
				CONSTRAINT FK_tipoPaquete FOREIGN KEY(tipoPaquete) REFERENCES [ABAN_DER_ADOS].[TipoPaquete](idTipo)
)


CREATE TABLE [ABAN_DER_ADOS].Recorrido(
				idRecorrido nvarchar(50) NOT NULL,
				origen int not null,
				destino int not null,
				cantKm int,
				precio int
				CONSTRAINT PK_idRecorrido PRIMARY KEY(idRecorrido),
				CONSTRAINT FK_origen FOREIGN KEY(origen) REFERENCES [ABAN_DER_ADOS].[Ciudad](codCiudad), 
				CONSTRAINT FK_destino FOREIGN KEY(destino) REFERENCES [ABAN_DER_ADOS].[Ciudad](codCiudad) 
)

CREATE TABLE [ABAN_DER_ADOS].Viaje(
				idViaje int identity(1,1) NOT NULL,
				legajoChofer int,
				patenteCamion nvarchar(255),
				idRecorrido nvarchar(50),
				fechaInicio DATE,
				fechaFin DATE,
				litrosCombustible int,
				CONSTRAINT PK_idViaje PRIMARY KEY(idViaje),
				CONSTRAINT FK_legajoChofer FOREIGN KEY(legajoChofer) REFERENCES [ABAN_DER_ADOS].[Chofer](chof_leg), 
				CONSTRAINT FK_patenteCamion FOREIGN KEY(patenteCamion) REFERENCES [ABAN_DER_ADOS].[Camion](patenteCamion), 
				CONSTRAINT FK_idRecorrido FOREIGN KEY(idRecorrido) REFERENCES [ABAN_DER_ADOS].[Recorrido](idRecorrido) 
	
)

CREATE TABLE [ABAN_DER_ADOS].PaquetexViaje(
				idPaquete nvarchar(50) NOT NULL,  --(- ojo preguntar con esto -)
				idViaje int NOT NULL, 
				cantidad int,
				CONSTRAINT FK_idPaquete FOREIGN KEY(idPaquete) REFERENCES [ABAN_DER_ADOS].[Paquete](idPaquete) ,
				CONSTRAINT FK_idViaje FOREIGN KEY(idViaje) REFERENCES [ABAN_DER_ADOS].[Viaje](idViaje)
)

----------Migracion EstadoOT--------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[EstadoOT](
		descripcion
)
SELECT DISTINCT[ORDEN_TRABAJO_ESTADO]
FROM gd_esquema.Maestra 
WHERE  TAREA_CODIGO is not null
GO

----------Migracion Chofer--------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Chofer](
		chof_leg,
		chof_nombre,
		chof_apellido,
		chof_dni,
		chof_dire,
		chof_mail,
		chof_telef,
		chof_fecha_nacimiento,
		chof_costo_hora
)
SELECT DISTINCT CHOFER_NRO_LEGAJO, CHOFER_NOMBRE, CHOFER_APELLIDO, CHOFER_DNI, CHOFER_DIRECCION, CHOFER_MAIL, CHOFER_TELEFONO, CHOFER_FECHA_NAC, CHOFER_COSTO_HORA
FROM gd_esquema.Maestra
WHERE  CHOFER_NRO_LEGAJO is not null 
GO


----------Migracion Ciudad--------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Ciudad](
		ciudadNombre
)

(SELECT DISTINCT RECORRIDO_CIUDAD_DESTINO  AS Ciudad FROM gd_esquema.Maestra 
WHERE RECORRIDO_CIUDAD_DESTINO is not null)
UNION
(SELECT DISTINCT RECORRIDO_CIUDAD_ORIGEN  AS Ciudad FROM gd_esquema.Maestra
WHERE RECORRIDO_CIUDAD_ORIGEN is not null)
UNION
(SELECT DISTINCT TALLER_CIUDAD  AS Ciudad FROM gd_esquema.Maestra
WHERE TALLER_CIUDAD is not null)

GO


-----------Migracion Material-------------------------------------------------------

USE GD2C2021
INSERT INTO [ABAN_DER_ADOS].[Material](
		codMaterial,
		descripcion,
		precio
)
SELECT distinct MATERIAL_COD,MATERIAL_DESCRIPCION,MATERIAL_PRECIO from gd_esquema.Maestra 
where MATERIAL_COD is not null


