*&---------------------------------------------------------------------*
*&  Include           Z_ABAP_NAVEGACION_ALV_TOP
*&---------------------------------------------------------------------*
type-pools: slis.
tables: ekko,itab.
types:begin of ty_salida,
        mandt  type mandt, "Mandante
        ebeln type ebeln,
         end of ty_salida.

data: wa_salida type ty_salida,
      wa_ekko type ekko.

data: ti_ekko type standard table of ekko,
      ti_salida type standard table of ty_salida.

data:begin of it_ftaxp occurs 50.
     include structure ftaxp.
data: end of it_ftaxp.

data: it_fieldcat type slis_t_fieldcat_alv,
      it_sort type slis_t_sortinfo_alv,
      it_events type slis_t_event,
*declara  2 TABLA UNA PARA la cabecera y OTRA PARA el pie de pagina
      it_header type slis_t_listheader,
      it_footer type slis_t_listheader.


*ESTRUCTURAS PARA ALV
data: wa_fieldcat type slis_fieldcat_alv.
data: wa_sort     type slis_sortinfo_alv.
data: wa_events   type slis_alv_event.
data: st_layout   type slis_layout_alv.
data: wa_heading  type slis_listheader.
data: wa_footer   type slis_listheader.
data: wa_ftaxp    type ftaxp.


selection-screen begin of block ekko with frame title text-001.
  select-options: s_ebeln for ekko-ebeln .
selection-screen end of block ekko.
