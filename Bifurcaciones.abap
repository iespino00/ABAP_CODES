
*&---------------------------------------------------------------------*
*& Report  ZBIFURCACION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

  REPORT  zbifurcacion.

*  data: numero type i.
*
*  numero = 4.
*
*  if numero eq 4.
*  write: / 'Valor del número= ',numero.
*  endif.

  PARAMETERS par_cod TYPE i.

  IF par_cod EQ 12.
    WRITE 'MONITOR DELL'.
    ELSEIF par_cod EQ 13.
      WRITE 'MONITOR HP'.
    ELSEIF par_cod is initial. "Si el valor de parametro no trae ningun valor. is not initial para cuando tenga algun valor
      WRITE: 'Introduzca un número de material'.
  ELSE.
    WRITE: 'Código de material ', par_cod, ' Desconocido'.
  ENDIF.
