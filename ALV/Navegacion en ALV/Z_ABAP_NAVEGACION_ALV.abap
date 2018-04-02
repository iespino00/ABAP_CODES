*&---------------------------------------------------------------------*
*& Report  Z_ABAP_NAVEGACION_ALV
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  z_abap_navegacion_alv.
"4500021105

include z_abap_navegacion_alv_top.
include z_abap_navegacion_alv_form.

start-of-selection.
perform obteniendo_datos.
perform match.
perform llena_catalogo_alv.
perform llena_layout.
perform cal_alv.
