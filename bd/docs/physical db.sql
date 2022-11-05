
Create table cierres (
    fecha date primary key;
    acciones float(20,2) not null;
    préstamos_tit._valores float(20,2) not null;
    pase_tomador float(20,2) not null;
    pase_colocador float(20,2) not null;
    cedears float(20,2) not null;
    opciones float(20,2) not null;
    futuros float(20,2) not null;
    cauciones float(20,2) not null;
    titulos_publicos float(20,2) not null;
    ejercicios float(20,2) not null;
    obligaciones_negociables float(20,2) not null;
)

Create table TRD (
    especie varchar(10) primary key;
)

Create table TRD_en_cierres (
    fecha date not null;
    especie varchar(10) not null;
    monto float(20,2) not null;
    volumen int(20) not null;
    vencimiento date not null;
    precio float(20,2) not null;
    Primary key (fecha,especie)
    Foreign key FK_fecha references cierres(fecha);
    Foreign key FK_especie references TRD(especie);
)

Create table empresa (
    CUIT int(11) primary key;
    nombre varchar(20) not null;
)

Create table accion (
    especie varchar(10) primary key;
    CUIT int (11) not null;
    valor_nominal float(20,2) not null;
    Foreign key FK_CUIT references empresa(CUIT);
    Foreign key FK_especie references TRD(especie);
)

Create table estado (
    ID int(3) primary key auto_increment;
    nombre varchar(20) not null;
)

Create table bono (
    especie varchar(10) primary key;
    ID int (3) not null;
    moneda_de_emision varchar(30) not null;
    fecha de vencimiento date not null;
    fecha de emision date not null;
    amortizacion text(1000) not null;
    intereses text(1000) not null;
)

Create table estados_contables (
    fecha date not null;
    CUIT int(11) not null;
    ganancia float(20,2) not null;
    total_activos float(20,2) not null;
    total_pasivos float(20,2) not null;
    numero_de_acciones int(20) not null;
    pasivos_corrientes float(20,2) not null;
    activos_corrientes float(20,2) not null;
    Primary key (CUIT, fecha);
    Foreign key FK_CUIT references empresa(CUIT);
)