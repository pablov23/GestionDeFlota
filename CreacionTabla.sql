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
				
)

CREATE TABLE [ABAN_DER_ADOS].OrdenTrabajo(
				orden_cod int Identity(1,1) NOT NULL,
				orden_fecha datetime2(3),
				orden_id_camion int FOREIGN KEY REFERENCES [ABAN_DER_ADOS].Camion(cam_patente),
				CONSTRAINT PK_OT PRIMARY KEY(orden_cod)


)

CREATE TABLE [ABAN_DER_ADOS].Mecanico(
)

CREATE TABLE [ABAN_DER_ADOS].Taller(
)

CREATE TABLE [ABAN_DER_ADOS].Marca(
)

CREATE TABLE [ABAN_DER_ADOS].ModeloCamion(
)

CREATE TABLE [ABAN_DER_ADOS].Camion(
)

CREATE TABLE [ABAN_DER_ADOS].TipoPaquete(
)

CREATE TABLE [ABAN_DER_ADOS].Paquete(
)

CREATE TABLE [ABAN_DER_ADOS].PaquetexViaje(
)

CREATE TABLE [ABAN_DER_ADOS].Viaje(
)

CREATE TABLE [ABAN_DER_ADOS].Recorrido(
)



