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
				idTipoTarea int Identity(1,1) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_TIPOTAREA PRIMARY KEY(idTipoTarea)
)

CREATE TABLE [ABAN_DER_ADOS].Tarea(
				codTarea nvarchar(50) NOT NULL,
				tipoTarea int NOT NULL,
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
				codEstado int Identity(1,1) NOT NULL,
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
				capacidadCarga int,
				capidadTanque int,
				velocidadMax int,
				CONSTRAINT PK_MODELOCAMION PRIMARY KEY(idModelo),
)

CREATE TABLE [ABAN_DER_ADOS].Camion(
				idCamion int identity(1,1),
				patenteCamion nvarchar(255) NOT NULL,
				idModelo int NOT NULL,
				marca int NOT NULL,
				fechaAlta DATE,
				nroMotor nvarchar(255),
				nroChasis nvarchar(255),
				CONSTRAINT PK_CAMION PRIMARY KEY(idCamion),
				CONSTRAINT FK_idModelo FOREIGN KEY(idModelo) REFERENCES [ABAN_DER_ADOS].[ModeloCamion](idModelo),
				CONSTRAINT FK_idMarcaCamin FOREIGN KEY(marca) REFERENCES [ABAN_DER_ADOS].[Marca](idMarca)				
)

CREATE TABLE [ABAN_DER_ADOS].OrdenTrabajo(
				orden_cod int Identity(1,1) NOT NULL,
				orden_fecha datetime2(3),
				orden_patente_camion int FOREIGN KEY REFERENCES [ABAN_DER_ADOS].[Camion](idCamion),
				orde_estado int FOREIGN KEY REFERENCES [ABAN_DER_ADOS].[EstadoOT](codEstado),
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
				idTipo int Identity(1,1) NOT NULL,
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
				tipoPaquete int NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_PAQUETE PRIMARY KEY(idPaquete),
				CONSTRAINT FK_tipoPaquete FOREIGN KEY(tipoPaquete) REFERENCES [ABAN_DER_ADOS].[TipoPaquete](idTipo)
)


CREATE TABLE [ABAN_DER_ADOS].Recorrido(
				idRecorrido int identity(1,1) NOT NULL,
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
				idCamion int,
				idRecorrido int,
				fechaInicio DATE,
				fechaFin DATE,
				litrosCombustible int,
				CONSTRAINT PK_idViaje PRIMARY KEY(idViaje),
				CONSTRAINT FK_legajoChofer FOREIGN KEY(legajoChofer) REFERENCES [ABAN_DER_ADOS].[Chofer](chof_leg), 
				CONSTRAINT FK_patenteCamion FOREIGN KEY(idCamion) REFERENCES [ABAN_DER_ADOS].[Camion](idCamion), 
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

INSERT INTO [ABAN_DER_ADOS].[Material](
		codMaterial,
		descripcion,
		precio
)
SELECT distinct MATERIAL_COD,MATERIAL_DESCRIPCION,MATERIAL_PRECIO from gd_esquema.Maestra 
where MATERIAL_COD is not null

----------Migracion Tipo Tarea-------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[TipoTarea](
				descripcion
)
select distinct TIPO_TAREA from gd_esquema.Maestra
where TIPO_TAREA is not null

----------Migracion Tarea -------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].Tarea(
				codTarea,
				tipoTarea,
				descripcion,
				tiempoTarea
)

SELECT DISTINCT maestra.[TAREA_CODIGO], 
			TipoTarea.[idTipoTarea], 
			maestra.[TAREA_DESCRIPCION], 
			maestra.[TAREA_TIEMPO_ESTIMADO]
from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[TipoTarea] TipoTarea
ON [TIPO_TAREA] = descripcion
WHERE TAREA_CODIGO is not null
GO


----------Migracion Taller -------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Taller](
				nombre,
				codCiudad,
				direccion,
				telefono,
				mail

)

SELECT DISTINCT maestra.[TALLER_NOMBRE], 
			Ciudad.[codCiudad], 
			maestra.[TALLER_DIRECCION], 
			maestra.[TALLER_TELEFONO],
			maestra.[TALLER_MAIL]
from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[Ciudad] Ciudad
ON [TALLER_CIUDAD] = ciudadNombre
WHERE TALLER_NOMBRE is not null
ORDER BY TALLER_NOMBRE
GO

----------Migracion Mecanico -------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Mecanico](
				legajoMecanico,
				idTaller,
				nombre, 
				apellido, 
				DNI,
				direccion,
				mail,
				fechaNac,
				telefono,
				costoHora

)

SELECT DISTINCT maestra.[MECANICO_NRO_LEGAJO], 
			taller.[idTaller], 
			maestra.[MECANICO_NOMBRE], 
			maestra.[MECANICO_APELLIDO],
			maestra.[MECANICO_DNI],
			maestra.[MECANICO_DIRECCION],
			maestra.[MECANICO_MAIL],
			maestra.[MECANICO_FECHA_NAC],
			maestra.[MECANICO_TELEFONO],
			maestra.[MECANICO_COSTO_HORA]
from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[Taller] taller
ON [TALLER_NOMBRE] = nombre
WHERE MECANICO_NRO_LEGAJO is not null
GO


----------Migracion TipoPaquete-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[TipoPaquete](
				pesoMax,
				altoMax,
				anchoMax,
				largoMax,
				descripcion,
				precio
)

SELECT DISTINCT [PAQUETE_PESO_MAX], [PAQUETE_ALTO_MAX], [PAQUETE_ANCHO_MAX], [PAQUETE_LARGO_MAX], [PAQUETE_DESCRIPCION],[PAQUETE_PRECIO]
FROM gd_esquema.Maestra
WHERE PAQUETE_DESCRIPCION is not null


----------Migracion Marca-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Marca](
			descripcion
)

SELECT DISTINCT [MARCA_CAMION_MARCA]
FROM gd_esquema.Maestra
WHERE MARCA_CAMION_MARCA is not null

----------Migracion Modelo Camion-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[ModeloCamion](
				descripcion,
				capacidadCarga,
				capidadTanque,
				velocidadMax
)

SELECT DISTINCT MODELO_CAMION,MODELO_CAPACIDAD_CARGA,MODELO_CAPACIDAD_TANQUE,MODELO_VELOCIDAD_MAX
FROM gd_esquema.Maestra
WHERE MODELO_CAMION is not null
ORDER BY 1

----------Migracion Camion-----------------------------------------------
INSERT INTO [ABAN_DER_ADOS].[Camion](
				patenteCamion,
				idModelo,
				marca,
				fechaAlta,
				nroMotor,
				nroChasis

)

SELECT DISTINCT maestra.[CAMION_PATENTE], [modelo].idModelo, marca.[idMarca], maestra.[CAMION_FECHA_ALTA],maestra.[CAMION_NRO_MOTOR],maestra.[CAMION_NRO_CHASIS]
from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[ModeloCamion] modelo
ON [MODELO_CAMION] = [modelo].descripcion
JOIN [ABAN_DER_ADOS].[Marca] marca
ON [MARCA_CAMION_MARCA] = [marca].descripcion
WHERE CAMION_PATENTE is not null
order by 1

GO


----------Migracion Recorrido-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].Recorrido(
				origen,
				destino,
				cantKm,
				precio
)
SELECT DISTINCT ciudad1.[codCiudad],ciudad2.[codCiudad], maestra.[RECORRIDO_KM], maestra.[RECORRIDO_PRECIO]

from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[Ciudad] ciudad1
ON [RECORRIDO_CIUDAD_ORIGEN] = [ciudad1].ciudadNombre
JOIN [ABAN_DER_ADOS].[Ciudad] ciudad2
ON [RECORRIDO_CIUDAD_DESTINO] = [ciudad2].ciudadNombre
GO
----------Migracion Viaje-----------------------------------------------
INSERT INTO [ABAN_DER_ADOS].Viaje(
				legajoChofer,idCamion,fechaInicio,fechaFin,litrosCombustible,idRecorrido
				
				
				
)
SELECT DISTINCT CHOFER_NRO_LEGAJO,camion.idCamion ,VIAJE_FECHA_INICIO,VIAJE_FECHA_FIN,VIAJE_CONSUMO_COMBUSTIBLE,recorrido.idRecorrido FROM gd_esquema.Maestra
JOIN ABAN_DER_ADOS.Chofer chofer ON (CHOFER_NRO_LEGAJO = chofer.chof_leg)
JOIN ABAN_DER_ADOS.Camion camion ON (CAMION_PATENTE = camion.patenteCamion)
JOIN ABAN_DER_ADOS.Ciudad co ON (RECORRIDO_CIUDAD_ORIGEN = co.ciudadNombre)
JOIN ABAN_DER_ADOS.Ciudad cd ON (RECORRIDO_CIUDAD_DESTINO = cd.ciudadNombre)
JOIN ABAN_DER_ADOS.Recorrido recorrido ON (co.codCiudad = recorrido.origen and cd.codCiudad = recorrido.destino and recorrido.cantKm = RECORRIDO_KM)
WHERE VIAJE_FECHA_INICIO is not null

----------Migracion Orden Trabajo-----------------------------------------------
INSERT INTO [ABAN_DER_ADOS].OrdenTrabajo(
				orden_patente_camion,orde_estado,orden_fecha
				
)
SELECT DISTINCT camion.idCamion, eot.codEstado ,ORDEN_TRABAJO_FECHA FROM gd_esquema.Maestra
JOIN ABAN_DER_ADOS.EstadoOT eot on (eot.descripcion = ORDEN_TRABAJO_ESTADO)
JOIN ABAN_DER_ADOS.Camion camion ON (CAMION_PATENTE = camion.patenteCamion)
WHERE ORDEN_TRABAJO_FECHA is not null

----------Migracion Orden Trabajo-----------------------------------------------