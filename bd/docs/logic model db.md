
CIERRE (**fecha**, acciones, préstamos tit. valores, pase tomador, pase colocador, cedears, opciones, futuros, cauciones, títulos públicos, ejercicios, obligaciones negociables)

TRD EN CIERRE (**fecha**, **especie**, monto, volumen, vencimiento, precio)
TRD EN CIERRE.fecha es una clave ajena a CIERRE
TRD EN CIERRE.especie es una clave ajena a TRD

TRD (especie)
TRD_ACCION (CUIT, **especie**, valor nominal)
TRD_ACCION.especie es una clave ajena a TRD
TRD_ACCION.CUIT es una clave ajena a EMPRESA
TRD_BONO (ID, **especie**, moneda de emision, fecha de vencimiento, fecha de emision, amortizacion, intereses)
TRD_BONO.especie es una clave ajena a TRD
TRD_BONO.ID es una clave ajena a ESTADO

EMPRESA (**CUIT**, nombre)

ESTADOS CONTABLES (CUIT, **fecha**, ganancia, total activos, total pasivos, numero de acciones, pasivos corrientes, activos corrientes)
ESTADOS CONTABLES.CUIT es una clave ajena a EMPRESA

ESTADO (**ID**, nombre)