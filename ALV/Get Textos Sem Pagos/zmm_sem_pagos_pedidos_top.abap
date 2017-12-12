*&---------------------------------------------------------------------*
*&  Include           ZMM_SEM_PAGOS_PEDIDOS_TOP
*&---------------------------------------------------------------------*

************************************************************************
* TABLAS
************************************************************************
*****************************************************************
type-pools: slis.
tables:ekko,ekpo.


types:begin of ty_salida,
        mandt  type mandt, "Mandante
        ebeln type ebeln,
        txtcab(9500) type c,
        bprei type bprei,
        semana type string,
        fecha type string,
        importe type string,
        end of ty_salida.

************************************************************************
* TABLAS INTERNAS
************************************************************************
data: ti_ekko type standard table of ekko,
      ti_ekpo type standard table of ekpo.
data: ti_salida type standard table of ty_salida.


data:begin of it_ftaxp occurs 50.
     include structure ftaxp.
data: end of it_ftaxp.

data: it_fieldcat type slis_t_fieldcat_alv,
      it_sort type slis_t_sortinfo_alv,
      it_events type slis_t_event,
*declara  2 TABLA UNA PARA la cabecera y OTRA PARA el pie de pagina
      it_header type slis_t_listheader,
      it_footer type slis_t_listheader.


************************************************************************
* ESTRUCTURAS
************************************************************************
data: wa_salida type ty_salida,
      wa_ekko type ekko,
      wa_ekpo type ekpo.

*ESTRUCTURAS PARA ALV
data: wa_fieldcat type slis_fieldcat_alv.
data: wa_sort     type slis_sortinfo_alv.
data: wa_events   type slis_alv_event.
data: st_layout   type slis_layout_alv.
data: wa_heading  type slis_listheader.
data: wa_footer   type slis_listheader.
data: wa_ftaxp    type ftaxp.

************************************************************************
* VARIABLES
************************************************************************
data : t_text like tline occurs 10 with header line,
       nombre_texto like thead-tdname.

************************************************************************
* SELECT-OPTION
************************************************************************
selection-screen begin of block frame1 with frame title text-002.

selection-screen begin of block ekko with frame title text-001.
  select-options: s_bukrs for ekko-bukrs .
  select-options: s_ebeln for ekko-ebeln .
  select-options: s_bedat for ekko-bedat obligatory.
selection-screen end of block ekko.

selection-screen end of block frame1.
