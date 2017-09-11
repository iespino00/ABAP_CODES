
*&---------------------------------------------------------------------*
*& Report  ZCADENAS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

  REPORT  zcadenas.

  DATA: sociedad TYPE c LENGTH 6,
        tipo TYPE c LENGTH 4,
        nombre_soc TYPE string,
        longitud TYPE i.

  sociedad = 'Mexico'.
  tipo = 'S.A.'.
*  CONCATENATE sociedad ' ' tipo INTO nombre_soc RESPECTING BLANKS.
  CONCATENATE sociedad space tipo INTO nombre_soc RESPECTING BLANKS.

  WRITE nombre_soc.

  longitud = STRLEN( nombre_soc ).
  WRITE: / 'La longitud de nombre de sociedad es :', longitud.

  TRANSLATE nombre_soc   TO UPPER CASE.
  WRITE: / 'Conversión a Mayúsculas: ',nombre_soc.

  TRANSLATE nombre_soc TO LOWER CASE.
  WRITE: / 'Conversión a Minusculas: ',nombre_soc.

  CONSTANTS: CENTRO type c LENGTH 10 VALUE 'MEXICO',
             ALMACEN type c LENGTH 10 VALUE 'MONTERREY'.
  data texto type string.

  CONCATENATE centro space almacen into texto RESPECTING BLANKS.
  TRANSLATE texto TO LOWER CASE.
  WRITE: /'Ejercicio', TEXTO.
