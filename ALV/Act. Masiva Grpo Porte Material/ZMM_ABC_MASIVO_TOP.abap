*&---------------------------------------------------------------------*
*&  Include           ZMM_ABC_MASIVO_TOP
*&---------------------------------------------------------------------*
type-pools: truxs.


*&---------------------------------------------------------------------*
*&  Estructuras internas
*&---------------------------------------------------------------------*
types: begin of type_datos,
           matnr type matnr,   "Material
           werks type werks_d, "Centro
           mfrgr type mfrgr,   "Grupo Porte Material (ABC)
       end of type_datos.

types: wa_datos type standard table of type_datos.

*&---------------------------------------------------------------------*
*&  Tablas internas
*&---------------------------------------------------------------------*
data: ti_data type wa_datos.

data: wa_bapimathead like bapimathead,
      wa_bapi_marc like bapi_marc,
      wa_check_update like bapi_marcx,
      status_bapi like bapiret2.

*&---------------------------------------------------------------------*
*&  ESTRUCTURA PARA IR PASANDO A LA FUNCION
*&---------------------------------------------------------------------*
data: wa_abc type type_datos.

*&---------------------------------------------------------------------*
*& DEFINICION DE TABLAS Y ESTRUCTURAS NECESARIAS ALV
*&---------------------------------------------------------------------*
type-pools: slis.
*
** Catálogo de campos: contiene la descripción de los campos de salida
data: gt_fieldcat type slis_t_fieldcat_alv with header line,
      gs_layout            type slis_layout_alv,
      gt_list_top_of_page  type slis_t_listheader,
      gt_events            type slis_t_event,
      gt_sort              type slis_t_sortinfo_alv with header line,
      ls_vari              type disvariant,
      g_repid        like sy-repid.

*&---------------------------------------------------------------------*
*& Parámetros de Selección
*&---------------------------------------------------------------------*
selection-screen begin of block q1 with frame title text-001.
parameters: archivo  type rlgrap-filename obligatory.
selection-screen end of block q1.
