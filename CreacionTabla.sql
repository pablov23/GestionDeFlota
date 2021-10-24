USE GD2C2021

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'ABAN_DER_ADOS')
	EXEC('CREATE SCHEMA ABAN_DER_ADOS')


--------------------- Creacion de Tablas ---------------------------------

CREATE TABLE [ABAN_DER_ADOS].Chofer(
				chof_leg nvarchar(50) NOT NULL,
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
				ciudad_cod nvarchar(50) NOT NULL,
				ciudad_nombre nvarchar(255),
				CONSTRAINT PK_CHOFER PRIMARY KEY(ciudad_cod)

)


CREATE TABLE [ABAN_DER_ADOS].TipoTarea(
				idTipoTarea nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAIN PK_TIPOTAREA PRIMARY KEY(idTipoTarea)
)

CREATE TABLE [ABAN_DER_ADOS].Tarea(
				codTarea nvarchar(50) NOT NULL,
				tipoTarea nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				descripcion nvarchar(50),
				tiempoTarea int,
				CONSTRAIN PK_TAREA PRIMARY KEY(codTarea),
				CONSTRAIN FK_TAREA FOREING KEY(tipoTarea) REFERENCES TipoTarea(idTipoTarea)
	
)

CREATE TABLE [ABAN_DER_ADOS].Material(
				idMaterial nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				precio int
				CONSTRAIN PK_MATERIAL PRIMARY KEY(idMaterial)
)

CREATE TABLE [ABAN_DER_ADOS].MaterialxTarea(
				idMaterial nvarchar(50) NOT NULL,
				codTarea nvarchar(50) NOT NULL,
				cantidad int,
				CONSTRAIN FK_MATERIALXTAREA FOREING KEY(idMaterial) REFERENCES Material(idMaterial),
				CONSTRAIN FK_MATERIALXTAREA FOREING KEY(codTarea) REFERENCES Tarea(codTarea)
				
)

CREATE TABLE [ABAN_DER_ADOS].TareaxOrden(
				idOrdenTrabajo int Identity(1,1) NOT NULL,
				codTarea nvarchar(50) NOT NULL,
				legajoMecanico int,
				duracionEstimada int,
				fechaInicio DATE,
				fechaFin DATE,
				duracionReal int,
				CONSTRAIN FK_TAREAXORDEN FOREING KEY(idOrdenTrabajo) REFERENCES OrdenTrabajo(orden_cod),
				CONSTRAIN FK_TAREAXORDEN FOREING KEY(codTarea) REFERENCES Tarea(codTarea),
				CONSTRAIN FK_TAREAXORDEN FOREING KEY(legajoMecanico) REFERENCES Mecanico(legajoMecanico),
)

CREATE TABLE [ABAN_DER_ADOS].EstadoOT(
				codEstado nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAIN PK_ESTADO PRIMARY KEY(codEstado)
				
)

CREATE TABLE [ABAN_DER_ADOS].OrdenTrabajo(
				orden_cod int Identity(1,1) NOT NULL,
				orden_fecha datetime2(3),
				orden_id_camion int FOREIGN KEY REFERENCES [ABAN_DER_ADOS].Camion(cam_patente),
				CONSTRAINT PK_OT PRIMARY KEY(orden_cod)


)

CREATE TABLE [ABAN_DER_ADOS].Mecanico(
				legajoMecanico int NOT NULL,
				idTaller nvarchar(50) NOT NULL,
				nombre nvarchar(50), 
				apellido nvarchar(50), 
				DNI int NOT NULL,
				direccion nvarchar(50),
				mail nvarchar(255),
				fechaNac DATE,
				telefono int,
				costoHora int
				CONSTRAINT PK_MECANICO PRIMARY KEY(legajoMecanico),
				CONSTRAINT FK_MECANICO FOREING KEY(idTaller) REFERENCES Taller(idTaller)
)

CREATE TABLE [ABAN_DER_ADOS].Taller(
				idTaller nvarchar(50) NOT NULL,
				nombre nvarchar(50),
				cod_cuidad nvarchar(50) NOT NULL,
				direccion nvarhar(50),
				telefono int,
				mail nvarchar(255)
				CONSTRAINT PK_TALLER PRIMARY KEY(idTaller),
				CONSTRAINT FK_TALLER FOREING KEY(codCuidad) REFERENCES Cuidad(codCuidad)
				
)

CREATE TABLE [ABAN_DER_ADOS].Marca(
				idMarca nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				CONSTRAINT PK_MARCA PRIMARY KEY(idMarca),
				
)

CREATE TABLE [ABAN_DER_ADOS].ModeloCamion(
				idModelo nvarchar(50) NOT NULL,
				descripcion nvarchar(50),
				idMarca nvarchar(50) NOT NULL,
				capacidadCarga int,
				capidadTanque int,
				velocidadMax int,
				CONSTRAINT PK_MODELOCAMION PRIMARY KEY(idModelo),
				CONSTRAINT FK_MODELOCAMION FOREING KEY(idMarca) REFERENCES Marca(idMarca)
)

CREATE TABLE [ABAN_DER_ADOS].Camion(
				patenteCamion nvarchar(7) NOT NULL,
				idModelo nvarchar(50) NOT NULL,
				marca nvarchar(50) NOT NULL,
				fechaAlta DATE,
				nroMotor int,
				nroChasis int,
				patente int,   (- ojo con esto -)
				CONSTRAINT PK_CAMION PRIMARY KEY(patenteCamion),
				CONSTRAINT FK_CAMION FOREING KEY(idModelo) REFERENCES Modelo(idModelo)
				CONSTRAINT FK_CAMION FOREING KEY(marca) REFERENCES Marca(idMarca)				
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
				CONSTRAINT FK_PAQUETE FOREING KEY(tipoPaquete) REFERENCES TipoPaquete(idTipo)
)

CREATE TABLE [ABAN_DER_ADOS].PaquetexViaje(
				idPaquete nvarchar(50) NOT NULL,  (- ojo preguntar con esto -)
				idViaje nvarchar(50) NOT NULL, 
				cantidad int,
				CONSTRAINT FK_PAQUETEXVIAJE FOREING KEY(idPaquete) REFERENCES Paquete(idPaquete) ,
				CONSTRAINT FK_PAQUETEXVIAJE FOREING KEY(idViaje) REFERENCES Viaje(idViaje)
)

CREATE TABLE [ABAN_DER_ADOS].Viaje(
				idViaje nvarchar(50) NOT NULL,
				legajoChofer int 
				patenteCamion nvarchar(7),
				idRecorrido nvarchar(50),
				fechaInicio DATE,
				fechaFin DATE,
				litrosCombustible int,
				CONSTRAINT FK_VIAJE FOREING KEY(legajoChofer) REFERENCES Chofer(legajoChofer) 
				CONSTRAINT FK_VIAJE FOREING KEY(patenteCamion) REFERENCES Camion(patenteCamion) 
				CONSTRAINT FK_VIAJE FOREING KEY(idRecorrido) REFERENCES Recorrido(idRecorrido) 
	
)

CREATE TABLE [ABAN_DER_ADOS].Recorrido(
				idRecorrido nvarchar(50) NOT NULL,
				origen nvarchar(50),
				destino nvarcvhar(50),
				cantKm int
				precio int
				CONSTRAINT FK_RECORRIDO FOREING KEY(origen) REFERENCES Ciudad(ciudad_cod), 
				CONSTRAINT FK_RECORRIDO FOREING KEY(destino) REFERENCES Ciudad(ciudad_cod) 
)

-------------------- Migracion --------------------------------------

INSERT INTO [ABAN_DER_ADOS].Chofer (
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
SELECT DISTINCT maestra.[CHOFER_NRO_LEGAJO],
		maestra.[CHOFER_NOMBRE],
		maestra.[CHOFER_APELLIDO],
		maestra.[CHOFER_DNI],
		maestra.[CHOFER_DIRECCION],
		maestra.[CHOFER_MAIL],
		maestra.[CHOFER_TELEFONO],
		maestra.[CHOFER_FECHA_NAC],
		maestra.[CHOFER_COSTO_HORA]						
FROM GD2C2021.gd_esquema.Maestra maestra


INSERT INTO [ABAN_DER_ADOS].Ciudad(
				ciudad_cod,     -- ANDA A SABER COMO CARGO ESTO
				ciudad_nombre 
)

INSERT INTO  [ABAN_DER_ADOS].TipoTarea(
				idTipoTarea, 
				descripcion
)
SELECT DISTINCT maestra.[TIPO_TAREA],
		maestra.[TAREA_DESCRIPCION]
FROM GD2C2021.gd_esquema.Maestra maestra

INSERT INTO [ABAN_DER_ADOS].Tarea(
				codTarea,
				tipoTarea,
				nombre,
				descripcion,               -- ojo aca descripcion se repite preguntar
				tiempoTarea,	
)
SELECT DISTINCT maestra.[TAREA_CODIGO],
		maestra.[TIPO_TAREA],
		maestra.
		maestra.[TAREA_DESCRIPCION],
		maestra.[TAREA_TIEMPO_ESTIMADO]


FROM GD2C2021.gd_esquema.Maestra maestra

INSERT INTO [ABAN_DER_ADOS].Material(
				idMaterial,
				nombre,
				precio,
)
SELECT DISTINCT maestra.

FROM GD2C2021.gd_esquema.Maestra maestra

INSERT INTO [ABAN_DER_ADOS].OrdenTrabajo(
				orden_fecha,
				orden_id_camion
)
SELECT DISTINCT maestra.[ORDEN_TRABAJO_FECHA],
		maestra.[CHOFER_NRO_LEGAJO],
FROM GD2C2021.gd_esquema.Maestra maestra

INSERT INTO [ABAN_DER_ADOS].Mecanico(
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
		maestra.
		maestra.[MECANICO_NOMBRE],
		maestra.[MECANICO_APELLIDO],
		maestra.[MECANICO_DNI],
		maestra.[MECANICO_DIRECCION],
		maestra.[MECANICO_MAIL],
		maestra.[MECANICO_FECHA_NAC],
		maestra.[MECANICO_TELEFONO],
		maestra.[MECANICO_COSTO_HORA]


FROM GD2C2021.gd_esquema.Maestra maestra

INSERT INTO [ABAN_DER_ADOS].Taller(
				idTaller,
				nombre,
				cod_cuidad,
				direccion,
				telefono,
				mail
)
SELECT DISTINCT maestra.
		maestra.[TALLER_NOMBRE],
		maestra.[TALLER_CIUDAD],
		maestra.[TALLER_DIRECCION],
		maestra.[TALLER_TELEFONO],
		maestra.[TALLER_MAIL] 
		
FROM GD2C2021.gd_esquema.Maestra maestra


INSERT INTO [ABAN_DER_ADOS].Marca(
				idMarca,
				descripcion			
)

SELECT DISTINCT maestra.[MARCA_CAMION_MARCA],
		maestra.
		
FROM GD2C2021.gd_esquema.Maestra maestra


INSERT INTO [ABAN_DER_ADOS].ModeloCamion(
				idModelo,
				descripcion,
				idMarca,
				capacidadCarga,
				capidadTanque,
				velocidadMax
)
SELECT DISTINCT maestra.[MODELO_CAMION],
		maestra.
		maestra.[MARCA_CAMION_MARCA],
		maestra.[MODELO_CAPACIDAD_CARGA],
		maestra.[MODELO_CAPACIDAD_TANQUE],
		maestra.[MODELO_VELOCIDAD_MAX]
		
FROM GD2C2021.gd_esquema.Maestra maestra


INSERT INTO [ABAN_DER_ADOS].Camion(
				patenteCamion,
				idModelo,
				marca,
				fechaAlta,
				nroMotor,
				nroChasis			
)
SELECT DISTINCT maestra.[CAMION_PATENTE],
		maestra.[MODELO_CAMION],
		maestra.[MARCA_CAMION_MARCA],
		maestra.[CAMION_FECHA_ALTA],
		maestra.[CAMION_NRO_MOTOR],
		maestra.[CAMION_NRO_CHASIS]
FROM GD2C2021.gd_esquema.Maestra maestra


INSERT INTO [ABAN_DER_ADOS].TipoPaquete(
				idTipo,
				pesoMax,
				altoMax,
				anchoMax,
				largoMax,
				descripcion,
				precio
)
SELECT DISTINCT maestra.
		maestra.[PAQUETE_PESO_MAX],
		maestra.[PAQUETE_ALTO_MAX],
		maestra.[PAQUETE_ANCHO_MAX],
		maestra.[PAQUETE_LARGO_MAX],
		maestra.[PAQUETE_DESCRIPCION],
		maestra.[PAQUETE_PRECIO]
FROM GD2C2021.gd_esquema.Maestra maestra

INSERT INTO [ABAN_DER_ADOS].PaquetexViaje(
				idPaquete,
				idViaje,
				cantidad
)
SELECT DISTINCT maestra.
		maestra.
		maestra.[PAQUETE_CANTIDAD]
		
FROM GD2C2021.gd_esquema.Maestra maestra

INSERT INTO [ABAN_DER_ADOS].Viaje(
				idViaje,
				legajoChofer,
				patenteCamion,
				idRecorrido,
				fechaInicio,
				fechaFin,
				litrosCombustible
)

SELECT DISTINCT maestra.
		maestra.[CHOFER_NRO_LEGAJO],
		maestra.[CAMION_PATENTE],
		maestra.
		maestra.[VIAJE_FECHA_INICIO],
		maestra.[VIAJE_FECHA_FIN],
		maestra.[VIAJE_CONSUMO_COMBUSTIBLE]
		
FROM GD2C2021.gd_esquema.Maestra maestra


CREATE TABLE [ABAN_DER_ADOS].Recorrido(
				idRecorrido,
				origen,
				destino,
				cantKm,
				precio
)
SELECT DISTINCT maestra.
		maestra.[RECORRIDO_CIUDAD_ORIGEN], 
		maestra.[RECORRIDO_CIUDAD_DESTINO], 
		maestra.[RECORRIDO_KM], 
		maestra.[RECORRIDO_PRECIO]
FROM GD2C2021.gd_esquema.Maestra maestra









	
	
	
	
	
	
	
	
	
	
	
	
	

