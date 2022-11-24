
CREATE TABLE cierres (
    fecha DATE PRIMARY KEY,
    acciones FLOAT(20,2) NOT NULL,
    préstamos_tit_valores FLOAT(20,2) NOT NULL,
    pase_tomador FLOAT(20,2) NOT NULL,
    pase_colocador FLOAT(20,2) NOT NULL,
    cedears FLOAT(20,2) NOT NULL,
    opciones FLOAT(20,2) NOT NULL,
    futuros FLOAT(20,2) NOT NULL,
    cauciones FLOAT(20,2) NOT NULL,
    titulos_publicos FLOAT(20,2) NOT NULL,
    ejercicios FLOAT(20,2) NOT NULL,
    obligaciones_negociables FLOAT(20,2) NOT NULL
);

CREATE TABLE TRD (
    especie VARCHAR(10) PRIMARY KEY
);

CREATE TABLE TRD_en_cierres (
    fecha DATE NOT NULL,
    especie VARCHAR(10) NOT NULL,
    monto FLOAT(20,2) NOT NULL,
    volumen INT(20) NOT NULL,
    vencimiento DATE NOT NULL,
    precio FLOAT(20,2) NOT NULL,
    FOREIGN KEY FK_fecha(fecha) REFERENCES cierres(fecha),
    FOREIGN KEY FK_especieCierreTRD(especie) REFERENCES TRD(especie),
    PRIMARY KEY (fecha, especie)
);

CREATE TABLE empresa (
    CUIT INT(11) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE accion (
    especie VARCHAR(10) PRIMARY KEY,
    CUIT INT(11) NOT NULL,
    valor_nominal FLOAT(20,2) NOT NULL,
    FOREIGN KEY FK_CUITaccion(CUIT) REFERENCES empresa(CUIT),
    FOREIGN KEY FK_especieAccion(especie) REFERENCES TRD(especie)
);

CREATE TABLE estado (
    ID INT(3) PRIMARY KEY auto_increment,
    nombre VARCHAR(20) NOT NULL
);

CREATE TABLE bono (
    especie VARCHAR(10) PRIMARY KEY,
    ID INT (3) NOT NULL,
    moneda_de_emision VARCHAR(30) NOT NULL,
    fecha_de_vencimiento DATE NOT NULL,
    fecha_de_emision DATE NOT NULL,
    amortizacion TEXT(1000) NOT NULL,
    INTereses TEXT(1000) NOT NULL,
    FOREIGN KEY FK_especieBono(especie) REFERENCES TRD(especie)
);

CREATE TABLE estados_contables (
    fecha DATE NOT NULL,
    CUIT INT(11) NOT NULL,
    ganancia FLOAT(20,2) NOT NULL,
    total_activos FLOAT(20,2) NOT NULL,
    total_pasivos FLOAT(20,2) NOT NULL,
    numero_de_acciones INT(20) NOT NULL,
    pasivos_corrientes FLOAT(20,2) NOT NULL,
    activos_corrientes FLOAT(20,2) NOT NULL,
    PRIMARY KEY (CUIT, fecha),
    FOREIGN KEY FK_CUITestadosContables(CUIT) REFERENCES empresa(CUIT)
);

CREATE  TABLE estados_contables (
    fecha DATE NOT NULL,
    CUIT INT(11) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    ganancia FLOAT(20,2) NOT NULL,
    total_activos FLOAT(20,2) NOT NULL,
    total_pasivos FLOAT(20,2) NOT NULL,
    numero_de_acciones INT(20) NOT NULL,
    pasivos_corrientes FLOAT(20,2) NOT NULL,
    activos_corrientes FLOAT(20,2) NOT NULL,
    PRIMARY KEY (CUIT, fecha),
    FOREIGN KEY FK_CUITestadosContables(CUIT) REFERENCES empresa(CUIT)
)
