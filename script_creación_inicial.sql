CREATE PROCEDURE crear_tablas AS
BEGIN 
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ABAN_DER_ADOS')
	EXEC('CREATE SCHEMA ABAN_DER_ADOS')


--------------------- Creacion de Tablas ---------------------------------

CREATE TABLE [ABAN_DER_ADOS].Chofer(
				chof_legajo int NOT NULL,
				chof_nombre nvarchar(255),
				chof_apellido nvarchar(255),
				chof_dni decimal(18,0),
				chof_direccion nvarchar(255),
				chof_mail nvarchar(255),
				chof_telefono nvarchar(255),
				chof_fecha_nacimiento datetime2(3),
				chof_costo_hora decimal(18,0),
				CONSTRAINT PK_CHOFER PRIMARY KEY(chof_legajo)

)

CREATE TABLE [ABAN_DER_ADOS].Ciudad(
				ciudad_codigo int identity(1,1) NOT NULL,
				ciudad_nombre nvarchar(255),
				CONSTRAINT PK_ciudad PRIMARY KEY(ciudad_codigo)

)

CREATE TABLE [ABAN_DER_ADOS].TipoTarea(
				tipo_tarea_codigo int Identity(1,1) NOT NULL,
				tipo_tarea_descripcion nvarchar(50),
				CONSTRAINT PK_TIPOTAREA PRIMARY KEY(tipo_tarea_codigo)
)

CREATE TABLE [ABAN_DER_ADOS].Tarea(
				tarea_codigo nvarchar(50) NOT NULL,
				tarea_tipo int NOT NULL,
				tarea_descripcion nvarchar(50),
				tarea_tiempo int,
				CONSTRAINT PK_tarea PRIMARY KEY(tarea_codigo),
				CONSTRAINT FK_id_TipoTarea FOREIGN KEY(tarea_tipo) REFERENCES [ABAN_DER_ADOS].[TipoTarea](tipo_tarea_codigo)
	
)

CREATE TABLE [ABAN_DER_ADOS].Material(
				material_codigo nvarchar(50) NOT NULL,
				material_descripcion nvarchar(50),
				material_precio int
				CONSTRAINT PK_MATERIAL PRIMARY KEY(material_codigo)
)


CREATE TABLE [ABAN_DER_ADOS].[EstadoOT](
				estado_codigo int Identity(1,1) NOT NULL,
				estado_descripcion nvarchar(50),
				CONSTRAINT PK_ESTADO PRIMARY KEY(estado_codigo)
				
)

CREATE TABLE [ABAN_DER_ADOS].Taller(
				taller_codigo int identity(1,1) NOT NULL,
				taller_nombre nvarchar(50),
				taller_ciudad int NOT NULL,
				taller_direccion nvarchar(50),
				taller_telefono int,
				taller_mail nvarchar(255),
				CONSTRAINT PK_TALLER PRIMARY KEY(taller_codigo),
				CONSTRAINT FK_codCiudad FOREIGN KEY(taller_ciudad) REFERENCES [ABAN_DER_ADOS].[Ciudad](ciudad_codigo)
				
)

CREATE TABLE [ABAN_DER_ADOS].Mecanico(
				mecanico_legajo int NOT NULL,
				mecanico_taller int NOT NULL,
				mecanico_nombre nvarchar(50), 
				mecanico_apellido nvarchar(50), 
				mecanico_dni int NOT NULL,
				mecanico_direccion nvarchar(50),
				mecanico_mail nvarchar(255),
				mecanico_fecha_nacimiento DATE,
				mecanico_telefono int,
				mecanico_costo int
				CONSTRAINT PK_MECANICO PRIMARY KEY(mecanico_legajo),
				CONSTRAINT FK_idTaller FOREIGN KEY(mecanico_taller) REFERENCES [ABAN_DER_ADOS].[Taller](taller_codigo)
)

CREATE TABLE [ABAN_DER_ADOS].Marca(
				marca_codigo int identity(1,1) NOT NULL,
				marca_descripcion nvarchar(50),
				CONSTRAINT PK_MARCA PRIMARY KEY(marca_codigo),
				
)

CREATE TABLE [ABAN_DER_ADOS].ModeloCamion(
				modelo_codigo int identity(1,1) NOT NULL,
				modelo_descripcion nvarchar(50),
				modelo_capacidad_carga int,
				modelo_capidad_tanque int,
				modelo_velocidad_maxima int,
				CONSTRAINT PK_MODELOCAMION PRIMARY KEY(modelo_codigo),
)

CREATE TABLE [ABAN_DER_ADOS].Camion(
				camion_codigo int identity(1,1),
				camion_patente nvarchar(255) NOT NULL,
				camion_modelo int NOT NULL,
				camion_marca int NOT NULL,
				camion_fecha_alta DATE,
				camion_nro_motor nvarchar(255),
				camion_nro_chasis nvarchar(255),
				CONSTRAINT PK_CAMION PRIMARY KEY(camion_codigo),
				CONSTRAINT FK_idModelo FOREIGN KEY(camion_modelo) REFERENCES [ABAN_DER_ADOS].[ModeloCamion](modelo_codigo),
				CONSTRAINT FK_idMarcaCamin FOREIGN KEY(camion_marca) REFERENCES [ABAN_DER_ADOS].[Marca](marca_codigo)				
)

CREATE TABLE [ABAN_DER_ADOS].OrdenTrabajo(
				orden_codigo int Identity(1,1) NOT NULL,
				orden_fecha datetime2(3),
				orden_camion int FOREIGN KEY REFERENCES [ABAN_DER_ADOS].[Camion](camion_codigo),
				orden_estado int FOREIGN KEY REFERENCES [ABAN_DER_ADOS].[EstadoOT](estado_codigo),
				CONSTRAINT PK_OT PRIMARY KEY(orden_codigo)
)

CREATE TABLE [ABAN_DER_ADOS].TareaxOrden(
				tarea_x_orden_codigo int identity(1,1) not null,
				tarea_x_orden_ot int NOT NULL,
				tarea_x_orden_tarea nvarchar(50) NOT NULL,
				tarea_x_orden_mecanico int,
				tarea_x_orden_fecha_inicio DATE,
				tarea_x_orden_fecha_inicio_planificada DATE,
				tarea_x_orden_fecha_fin DATE,
				tarea_x_orden_duracion_real int,
				CONSTRAINT PK_idTareaXOrden PRIMARY KEY(tarea_x_orden_codigo),
				CONSTRAINT FK_idOrdenTrabajo FOREIGN KEY(tarea_x_orden_ot) REFERENCES [ABAN_DER_ADOS].[OrdenTrabajo](orden_codigo),
				CONSTRAINT FK_codTareaOrden FOREIGN KEY(tarea_x_orden_tarea) REFERENCES [ABAN_DER_ADOS].[Tarea](tarea_codigo),
				CONSTRAINT FK_legajoMecanicoOrden FOREIGN KEY(tarea_x_orden_mecanico) REFERENCES [ABAN_DER_ADOS].[Mecanico](mecanico_legajo),
)

CREATE TABLE [ABAN_DER_ADOS].MaterialxTarea(
				material_codigo nvarchar(50) NOT NULL,
				tarea_x_orden int NOT NULL,
				cantidad int,
				CONSTRAINT FK_codMaterial FOREIGN KEY(material_codigo) REFERENCES [ABAN_DER_ADOS].[Material](material_codigo),
				CONSTRAINT FK_codTarea FOREIGN KEY(tarea_x_orden) REFERENCES [ABAN_DER_ADOS].[TareaxOrden](tarea_x_orden_codigo)
				
)

CREATE TABLE [ABAN_DER_ADOS].TipoPaquete(
				tipo_paquete_codigo int Identity(1,1) NOT NULL,
				tipo_paquete_peso_max int,
				tipo_paquete_alto_max int,
				tipo_paquete_ancho_max int,
				tipo_paquete_largo_max int,
				tipo_paquete_descripcion nvarchar(50),
				tipo_paquete_precio int,
				CONSTRAINT PK_TIPOPAQUETE PRIMARY KEY(tipo_paquete_codigo)
)

CREATE TABLE [ABAN_DER_ADOS].Recorrido(
				recorrido_codigo int identity(1,1) NOT NULL,
				recorrido_origen int not null,
				recorrido_destino int not null,
				recorrido_kilometros int,
				recorrido_precio int
				CONSTRAINT PK_idRecorrido PRIMARY KEY(recorrido_codigo),
				CONSTRAINT FK_origen FOREIGN KEY(recorrido_origen) REFERENCES [ABAN_DER_ADOS].[Ciudad](ciudad_codigo), 
				CONSTRAINT FK_destino FOREIGN KEY(recorrido_destino) REFERENCES [ABAN_DER_ADOS].[Ciudad](ciudad_codigo) 
)

CREATE TABLE [ABAN_DER_ADOS].Viaje(
				viaje_codigo int identity(1,1) NOT NULL,
				viaje_chofer int,
				viaje_camion int,
				viaje_recorrido int,
				viaje_fecha_inicio DATE,
				viaje_fecha_fin DATE,
				viaje_litros_combustible int,
				CONSTRAINT PK_idViaje PRIMARY KEY(viaje_codigo),
				CONSTRAINT FK_legajoChofer FOREIGN KEY(viaje_chofer) REFERENCES [ABAN_DER_ADOS].[Chofer](chof_legajo), 
				CONSTRAINT FK_patenteCamion FOREIGN KEY(viaje_camion) REFERENCES [ABAN_DER_ADOS].[Camion](camion_codigo), 
				CONSTRAINT FK_idRecorrido FOREIGN KEY(viaje_recorrido) REFERENCES [ABAN_DER_ADOS].[Recorrido](recorrido_codigo) 
	
)

CREATE TABLE [ABAN_DER_ADOS].PaquetexViaje(
				paquete_codigo int NOT NULL,  --(- ojo preguntar con esto -)
				paquete_viaje int NOT NULL, 
				paquete_cantidad int,
				CONSTRAINT FK_idPaquete FOREIGN KEY(paquete_codigo) REFERENCES [ABAN_DER_ADOS].[TipoPaquete](tipo_paquete_codigo) ,
				CONSTRAINT FK_idViaje FOREIGN KEY(paquete_viaje) REFERENCES [ABAN_DER_ADOS].[Viaje](viaje_codigo)
)
END
GO

CREATE PROCEDURE migrar AS
BEGIN 
----------Migracion EstadoOT--------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[EstadoOT](
		estado_descripcion
)
SELECT DISTINCT[ORDEN_TRABAJO_ESTADO]
FROM gd_esquema.Maestra 
WHERE  TAREA_CODIGO is not null

----------Migracion Chofer--------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Chofer](
		chof_legajo,
		chof_nombre,
		chof_apellido,
		chof_dni,
		chof_direccion,
		chof_mail,
		chof_telefono,
		chof_fecha_nacimiento,
		chof_costo_hora
)
SELECT DISTINCT CHOFER_NRO_LEGAJO, CHOFER_NOMBRE, CHOFER_APELLIDO, CHOFER_DNI, CHOFER_DIRECCION, CHOFER_MAIL, CHOFER_TELEFONO, CHOFER_FECHA_NAC, CHOFER_COSTO_HORA
FROM gd_esquema.Maestra
WHERE  CHOFER_NRO_LEGAJO is not null 



----------Migracion Ciudad--------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Ciudad](
		ciudad_nombre
)

(SELECT DISTINCT RECORRIDO_CIUDAD_DESTINO  AS Ciudad FROM gd_esquema.Maestra 
WHERE RECORRIDO_CIUDAD_DESTINO is not null)
UNION
(SELECT DISTINCT RECORRIDO_CIUDAD_ORIGEN  AS Ciudad FROM gd_esquema.Maestra
WHERE RECORRIDO_CIUDAD_ORIGEN is not null)
UNION
(SELECT DISTINCT TALLER_CIUDAD  AS Ciudad FROM gd_esquema.Maestra
WHERE TALLER_CIUDAD is not null)



-----------Migracion Material-------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Material](
		material_codigo,
		material_descripcion,
		material_precio
)
SELECT distinct MATERIAL_COD,MATERIAL_DESCRIPCION,MATERIAL_PRECIO from gd_esquema.Maestra 
where MATERIAL_COD is not null


----------Migracion Tipo Tarea-------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[TipoTarea](
				tipo_tarea_descripcion
)
select distinct TIPO_TAREA from gd_esquema.Maestra
where TIPO_TAREA is not null

----------Migracion Tarea -------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].Tarea(
				tarea_codigo,
				tarea_tipo,
				tarea_descripcion,
				tarea_tiempo
)

SELECT DISTINCT maestra.[TAREA_CODIGO], 
			TipoTarea.[tipo_tarea_codigo], 
			maestra.[TAREA_DESCRIPCION], 
			maestra.[TAREA_TIEMPO_ESTIMADO]
from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[TipoTarea] TipoTarea
ON [TIPO_TAREA] = tipo_tarea_descripcion
WHERE TAREA_CODIGO is not null


----------Migracion Taller -------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Taller](
				taller_nombre,
				taller_ciudad,
				taller_direccion,
				taller_telefono,
				taller_mail

)

SELECT DISTINCT maestra.[TALLER_NOMBRE], 
			Ciudad.[ciudad_codigo], 
			maestra.[TALLER_DIRECCION], 
			maestra.[TALLER_TELEFONO],
			maestra.[TALLER_MAIL]
from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[Ciudad] Ciudad
ON [TALLER_CIUDAD] = ciudad_nombre
WHERE TALLER_NOMBRE is not null
ORDER BY TALLER_NOMBRE


----------Migracion Mecanico -------------------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Mecanico](
				mecanico_legajo,
				mecanico_taller,
				mecanico_nombre, 
				mecanico_apellido, 
				mecanico_DNI,
				mecanico_direccion,
				mecanico_mail,
				mecanico_fecha_nacimiento,
				mecanico_telefono,
				mecanico_costo

)

SELECT DISTINCT maestra.[MECANICO_NRO_LEGAJO], 
			taller.[taller_codigo], 
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
ON maestra.[TALLER_NOMBRE] = taller.taller_nombre
WHERE MECANICO_NRO_LEGAJO is not null


----------Migracion TipoPaquete-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[TipoPaquete](
				tipo_paquete_peso_max,
				tipo_paquete_alto_max,
				tipo_paquete_ancho_max,
				tipo_paquete_largo_max,
				tipo_paquete_descripcion,
				tipo_paquete_precio
)

SELECT DISTINCT [PAQUETE_PESO_MAX], [PAQUETE_ALTO_MAX], [PAQUETE_ANCHO_MAX], [PAQUETE_LARGO_MAX], [PAQUETE_DESCRIPCION],[PAQUETE_PRECIO]
FROM gd_esquema.Maestra
WHERE PAQUETE_DESCRIPCION is not null


----------Migracion Marca-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[Marca](
			marca_descripcion
)

SELECT DISTINCT [MARCA_CAMION_MARCA]
FROM gd_esquema.Maestra
WHERE MARCA_CAMION_MARCA is not null

----------Migracion Modelo Camion-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].[ModeloCamion](
				modelo_descripcion,
				modelo_capacidad_carga,
				modelo_capidad_tanque,
				modelo_velocidad_maxima
)

SELECT DISTINCT MODELO_CAMION,MODELO_CAPACIDAD_CARGA,MODELO_CAPACIDAD_TANQUE,MODELO_VELOCIDAD_MAX
FROM gd_esquema.Maestra
WHERE MODELO_CAMION is not null


----------Migracion Camion-----------------------------------------------
INSERT INTO [ABAN_DER_ADOS].[Camion](
				camion_patente,
				camion_modelo,
				camion_marca,
				camion_fecha_alta,
				camion_nro_motor,
				camion_nro_chasis

)

SELECT DISTINCT maestra.[CAMION_PATENTE], [modelo].modelo_codigo, marca.[marca_codigo], maestra.[CAMION_FECHA_ALTA],maestra.[CAMION_NRO_MOTOR],maestra.[CAMION_NRO_CHASIS]
from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[ModeloCamion] modelo
ON [MODELO_CAMION] = [modelo].modelo_descripcion AND modelo.modelo_capacidad_carga+modelo.modelo_capidad_tanque+modelo_velocidad_maxima = maestra.MODELO_CAPACIDAD_CARGA+maestra.MODELO_CAPACIDAD_TANQUE+maestra.MODELO_VELOCIDAD_MAX
JOIN [ABAN_DER_ADOS].[Marca] marca
ON [MARCA_CAMION_MARCA] = [marca].marca_descripcion
WHERE CAMION_PATENTE is not null

----------Migracion Recorrido-----------------------------------------------

INSERT INTO [ABAN_DER_ADOS].Recorrido(
				recorrido_origen,
				recorrido_destino,
				recorrido_kilometros,
				recorrido_precio
)
SELECT DISTINCT ciudad1.[ciudad_codigo],ciudad2.[ciudad_codigo], maestra.[RECORRIDO_KM], maestra.[RECORRIDO_PRECIO]

from gd_esquema.Maestra maestra
JOIN [ABAN_DER_ADOS].[Ciudad] ciudad1
ON [RECORRIDO_CIUDAD_ORIGEN] = [ciudad1].ciudad_nombre
JOIN [ABAN_DER_ADOS].[Ciudad] ciudad2
ON [RECORRIDO_CIUDAD_DESTINO] = [ciudad2].ciudad_nombre

----------Migracion Viaje-----------------------------------------------
INSERT INTO [ABAN_DER_ADOS].Viaje(
				viaje_chofer ,
				viaje_camion ,
				viaje_fecha_inicio ,
				viaje_fecha_fin ,
				viaje_litros_combustible,
				viaje_recorrido
)
SELECT DISTINCT CHOFER_NRO_LEGAJO,camion.camion_codigo ,VIAJE_FECHA_INICIO,VIAJE_FECHA_FIN,VIAJE_CONSUMO_COMBUSTIBLE,recorrido.recorrido_codigo FROM gd_esquema.Maestra
JOIN ABAN_DER_ADOS.Camion camion ON (Maestra.CAMION_PATENTE = camion.camion_patente)
JOIN ABAN_DER_ADOS.Ciudad co ON (RECORRIDO_CIUDAD_ORIGEN = co.ciudad_nombre)
JOIN ABAN_DER_ADOS.Ciudad cd ON (RECORRIDO_CIUDAD_DESTINO = cd.ciudad_nombre)
JOIN ABAN_DER_ADOS.Recorrido recorrido ON (co.ciudad_codigo = recorrido.recorrido_origen and cd.ciudad_codigo = recorrido.recorrido_destino)
WHERE VIAJE_FECHA_INICIO is not null



----------Migracion Orden Trabajo-----------------------------------------------
INSERT INTO [ABAN_DER_ADOS].OrdenTrabajo(
				orden_camion
				,orden_estado
				,orden_fecha
				
)
SELECT DISTINCT 
	camion.camion_codigo
	, eot.estado_codigo 
	,ORDEN_TRABAJO_FECHA 
FROM gd_esquema.Maestra
JOIN ABAN_DER_ADOS.EstadoOT eot 
	on (eot.estado_descripcion = ORDEN_TRABAJO_ESTADO)
JOIN ABAN_DER_ADOS.Camion camion 
	ON (Maestra.CAMION_PATENTE = camion.camion_patente)
WHERE TAREA_FECHA_INICIO is not null

----------Migracion TareaXOrden-----------------------------------------------

INSERT INTO ABAN_DER_ADOS.TareaxOrden(
	tarea_x_orden_ot
	,tarea_x_orden_mecanico
	,tarea_x_orden_tarea
	,tarea_x_orden_fecha_inicio
	,tarea_x_orden_fecha_inicio_planificada
	,tarea_x_orden_fecha_fin
	,tarea_x_orden_duracion_real
		
)

SELECT DISTINCt
ot.orden_codigo
,MECANICO_NRO_LEGAJO 
,TAREA_CODIGO
,TAREA_FECHA_INICIO
,TAREA_FECHA_INICIO_PLANIFICADO
,TAREA_FECHA_FIN
,DATEDIFF(DAY,TAREA_FECHA_Inicio,TAREA_FECHA_FIN)
FROM gd_esquema.Maestra
JOIN ABAN_DER_ADOS.Camion c 
	ON c.camion_patente = MAestra.CAMION_PATENTE
JOIN ABAN_DER_ADOS.OrdenTrabajo ot
	ON ot.orden_fecha = ORDEN_TRABAJO_FECHA AND ot.orden_camion = c.camion_codigo
WHERE TAREA_FECHA_INICIO is not null 


--
----------Migracion MaterialxTareax-----------------------------------------------

INSERT INTO ABAN_DER_ADOS.MaterialxTarea(
	material_codigo,tarea_x_orden,cantidad
		
)
SELECT 
	MATERIAL_COD
	,TareaxOrden.tarea_x_orden_codigo
	,COUNT(*) 'cantidad'
FROM gd_esquema.Maestra
	JOIN ABAN_DER_ADOS.Camion c
		ON c.camion_patente = Maestra.CAMION_PATENTE
	JOIN ABAN_DER_ADOS.OrdenTrabajo ot 
		on ot.orden_fecha = Maestra.ORDEN_TRABAJO_FECHA and ot.orden_camion = c.camion_codigo
	JOIN ABAN_DER_ADOS.TareaxOrden
		ON TareaxOrden.tarea_x_orden_tarea = Maestra.TAREA_CODIGO 
			and TareaxOrden.tarea_x_orden_ot = ot.orden_codigo
			and TareaxOrden.tarea_x_orden_mecanico = Maestra.MECANICO_NRO_LEGAJO
GROUP BY MATERIAL_COD,TareaxOrden.tarea_x_orden_codigo


----------Migracion OrdenTrabajo-----------------------------------------------
INSERT INTO ABAN_DER_ADOS.OrdenTrabajo(
	orden_fecha,orden_estado,orden_camion
)
SELECT DISTINCT
	ORDEN_TRABAJO_FECHA
	,eot.estado_codigo
	,c.camion_codigo
FROM gd_esquema.Maestra
JOIN ABAN_DER_ADOS.EstadoOT eot ON (eot.estado_descripcion = Maestra.ORDEN_TRABAJO_ESTADO)
JOIN ABAN_DER_ADOS.Camion c ON (Maestra.CAMION_PATENTE = c.camion_patente)


----------Migracion PaquetexViaje-----------------------------------------------

INSERT INTO ABAN_DER_ADOS.PaquetexViaje(
	paquete_codigo,paquete_viaje,paquete_cantidad
)
SELECT  p.tipo_paquete_codigo,viaje_codigo, PAQUETE_CANTIDAD FROM  gd_esquema.Maestra m
	JOIN ABAN_DER_ADOS.Camion c ON c.camion_patente = m.CAMION_PATENTE
	JOIN ABAN_DER_ADOS.Viaje v 
		ON 
		v.viaje_fecha_inicio = m.Viaje_FECHA_INICIO 
		and v.viaje_fecha_fin=m.VIAJE_FECHA_FIN
		AND v.viaje_chofer = m.CHOFER_NRO_LEGAJO
		AND	v.viaje_camion = c.camion_codigo
	JOIN ABAN_DER_ADOS.TipoPaquete P 
		ON M.PAQUETE_DESCRIPCION = P.tipo_paquete_descripcion
		AND P.tipo_paquete_alto_max = M.PAQUETE_ALTO_MAX
		AND P.tipo_paquete_ancho_max = M.PAQUETE_ANCHO_MAX
		AND P.tipo_paquete_largo_max = M.PAQUETE_LARGO_MAX
		AND P.tipo_paquete_peso_max = M.PAQUETE_PESO_MAX
WHERE M.VIAJE_FECHA_INICIO is not null

END
GO



EXEC dbo.crear_tablas
GO
EXEC dbo.migrar
GO
