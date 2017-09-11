*Concatenar variables respetando espacio
CONCATENATE v1 ' ' v2 into resultado RESPECTING BLANKS.
CONCATENATE v1 space v2 into resultado RESPECTING BLANKS.

*Longitud de una cadena
longitud = strleng(variable).

*Conversión a mayusculas (cadena de caracteres).
TRANSLATE variable TO UPPER CASE.

*Conversión a minúsculas (Cadena de caracteres).
TRANSLATE nombre_soc TO LOWER CASE.
