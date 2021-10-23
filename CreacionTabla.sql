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
)

CREATE TABLE [ABAN_DER_ADOS].Tarea(
)

CREATE TABLE [ABAN_DER_ADOS].Material(
)

CREATE TABLE [ABAN_DER_ADOS].MaterialxTarea(
)

CREATE TABLE [ABAN_DER_ADOS].TareaxOrden(
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



