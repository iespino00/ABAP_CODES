REPORT  zcalculadora.

DATA: x_value(15) TYPE c.

CALL FUNCTION 'FITRV_CALCULATOR'
* EXPORTING
*   INPUT_VALUE                =
*   CURRENCY                   =
*   START_COLUMN               = '10'
*   START_ROW                  = '10'
  IMPORTING
    output_value               = x_value
  EXCEPTIONS
    invalid_input              = 1
    calculation_canceled       = 2
    OTHERS                     = 3.

IF sy-subrc = 0.  "En este ejemplo imprimimos por pantalla el resultado
  WRITE:/ 'Output Value ', x_value.
ENDIF.
