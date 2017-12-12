*&---------------------------------------------------------------------*
*&  Include           ZMM_REQUIS_PEDIDOS_TOP
*&---------------------------------------------------------------------*

************************************************************************
* TABLAS
************************************************************************

*****************************************************************
type-pools: slis.

data: lt_color     type lvc_t_scol,
        wa_color  type lvc_s_scol.


types: begin of ty_eban,
         mandt  type mandt, "Mandante
         banfn  type banfn, "Número de la solicitud de pedido
         bnfpo  type bnfpo, "Número de posición de la solicitud de pedido
         loekz  type eloek, "Indicador de borrado en el documento de compras
         statu  type banst, "Status de tratamiento de la solicitud de pedido
         ekgrp  type ekgrp, "Grupo de compras
         afnam  type afnam, "Nombre del solicitante
         txz01  type txz01, "Texto breve
         matnr  type matnr, "Número de material
         werks  type ewerk, "Centro
         bednr  type eban-bednr,
         matkl  type matkl, "Grupo de artículos
         menge  type bstmg, "Cantidad solicitud de pedido
         meins  type bamei, "Unidad de medida de solicitud pedido
         badat  type badat, "Fecha de solicitud
         mengea type bstmg, "ACUMULADO DE LAS ENTRADAS
         ebeln  type ebeln, "Número del documento de compras
         ebelp  type ebelp, "Número de posición del documento de compras
         ebakz  type ebakz, "Concluida
         packno type packno,
       end of ty_eban.

types: begin of ty_ekpo,
         mandt  type mandt, "Mandante
         ebeln  type ebeln, "Número del documento de compras
         ebelp  type ebelp, "Número de posición del documento de compras
         loekz  type eloek, "Indicador de borrado en el documento de compras
         txz01  type txz01, "Texto breve
         matnr  type matnr, "Número de material
         status	type epstatu,	"Status de la posición del documento de compras
         menge  type bstmg, "Cantidad de pedido
         netwr  type bwert, "Valor neto de pedido en moneda de pedido
         netwri type bwert, "Valor neto de pedido en moneda de pedido
         mwskz  type mwskz,  "Indicador IVA
         netpr  type bprei, " CURR  EKKO  WAERS Precio neto en doc.compras moneda documento
         netpri type bprei, " CURR  EKKO  WAERS Precio neto en doc.compras moneda documento
         pstyp  type pstyp, " Tipo de posición del documento de compras
         knttp  type knttp, " Tipo de imputación
         afnam  type afnam,
         banfn  type banfn, "Número de la solicitud de pedido
         bnfpo  type bnfpo, "Número de posición de la solicitud de pedido
       end of ty_ekpo.

types: begin of ty_ekko,
         mandt  type mandt, "Mandante
         ebeln  type ebeln, "Número del documento de compras
         lifnr  type elifn, "Número de cuenta del proveedor
         spras  type spras, "Clave de idioma
         zterm  type dzterm, "Clave de condiciones de pago
         aedat  type erdat,  "Fecha de creación del registro
         waers  type waers, "moneda"
         unsez  type unsez, "nuestra referencia (cuadro)
       end of ty_ekko.

types: begin of ty_eket,
         mandt  type mandt, "Mandante
         ebeln  type ebeln, "Número del documento de compras
         ebelp  type ebelp, "Número de posición del documento de compras
         etenr  type eeten, "Contador de repartos
         eindt  type eindt, "Fecha de entrega de posición
         menge  type etmen, "Cantidad de reparto
         ameng  type vomng, "Cantidad anterior en repartos
         wemng  type weemg, "Cantidad entrada de mercancías
         wamng  type wamng, "Cantidad de salida
       end of ty_eket.

types: begin of ty_eketr,
         ebeln  type ebeln, "Número del documento de compras
         ebelp  type ebelp, "Número de posición del documento de compras
         wemng  type etmen, "Cantidad de reparto
       end of ty_eketr.

types: begin of ty_eketo,
         ebeln  type ebeln, "Número de peticion de oferta
         bedat type etbdt, "fecha de peticion de oferta
end of ty_eketo.

types: begin of ty_ekbe,
         ebeln  type ebeln, "Número del documento de compras
         ebelp  type ebelp, "Número de posición del documento de compras
         bwart  type bwart, "Clase de Movimiento (1= entrada de mercancia)
         budat  type budat, "Fecha de entrega de posición
       end of ty_ekbe.

types: begin of ty_t023t,
       matkl type matkl,      "Grupo de articulos
       wgbez type wgbez,      "Denominacion corta de grupo de articulos
       wgbez60 type wgbez60,  "denominacion larga de grupo de articulos
       end of ty_t023t.

types: begin of ty_esll,
       packno     type packno,
       introw     type introw,
       extrow     type extrow,
       sub_packno type sub_packno,
       ktext1     type ktext1,
       end of ty_esll.



types: begin of ty_ekkn,
         mandt  type mandt, " Mandante
         ebeln  type ebeln, " Número del documento de compras
         ebelp  type ebelp, " Número de posición del documento de compras
         sakto  type saknr, " Número de la cuenta de mayor
         kostl  type kostl, " Centro de coste
         anln1  type anln1, " Número principal de activo fijo
         anln2  type anln2, " Subnúmero de activo fijo
*PAOBJNR  type NUMeric , "Número para objetos PA (CO-PA)
  end of ty_ekkn.

*tipo para la tabla de la salida

types: begin of ty_salida,
*EBAN
         mandt  type mandt, "Mandante
         banfn  type banfn, "Número de la solicitud de pedido
         bnfpo  type bnfpo, "Número de posición de la solicitud de pedido
         loekz  type eloek, "Indicador de borrado en el documento de compras
         statu  type banst, "Status de tratamiento de la solicitud de pedido
         ekgrp  type ekgrp, "Grupo de compras
         afnam  type afnam, "Nombre del solicitante
         txz01  type txz01, "Texto breve
         matnr  type matnr, "Número de material
         werks  type ewerk, "Centro
         bednr type bednr,
         matkl  type matkl, "Grupo de artículos
         menge  type bamng, "Cantidad solicitud de pedido
         meins  type bamei, "Unidad de medida de solicitud pedido
         badat  type badat, "Fecha de solicitud
         mengea type bamng, "Cantidad solicitud de pedido
         ebakz  type ebakz, "Concluida
         packno type packno,

*ekpo
         ebelp  type ebelp, "Número de posición del documento de compras
         loekzp type eloek, "Indicador de borrado en el documento de compras
         txz01p type txz01, "Texto breve
         matnrp type matnr, "Número de material
         status	type epstatu,	"Status de la posición del documento de compras
         mengep type bstmg, "Cantidad de pedido
         netwr  type bwert, "Valor neto de pedido en moneda de pedido
         netwri type bwert, "Valor neto de pedido en moneda de pedido
         mwskz  type mwskz,  "Indicador IVA
         netpr  type bprei, " CURR  EKKO  WAERS Precio neto en doc.compras moneda documento
         netpri type bprei, " CURR  EKKO  WAERS Precio neto en doc.compras moneda documento
         pstyp  type pstyp, " Tipo de posición del documento de compras
         knttp  type knttp, " Tipo de imputación
*ekko
         ebeln type ebeln, "Número del documento de compras
         lifnr type elifn, "Número de cuenta del proveedor
         spras type spras, "Clave de idioma
         zterm type dzterm, "Clave de condiciones de pago
         budat type budat,
         aedat type erdat, "Fecha de creación del registro
         waers type waers,
*eket
         etenr  type eeten, "Contador de repartos
         eindt  type eindt, "Fecha de entrega de posición
         mengee type etmen, "Cantidad de reparto
         ameng  type vomng, "Cantidad anterior en repartos
         wemng  type weemg, "Cantidad entrada de mercancías
         wamng  type wamng, "Cantidad de salida
         pendt  type weemg,
         pendtr type weemg,
*ekkn
         sakto  type saknr, " Número de la cuenta de mayor
         kostl  type kostl, " Centro de coste
         anln1  type anln1, " Número principal de activo fijo
         anln2  type anln2, " Subnúmero de activo fijo
         name1  type char100,
         unsez  type unsez,
         txtcab(1500) type c,
         txtcab1(150) type c,
         txtcab2(150) type c,
         txtcab3(150) type c,
         txtcab4(150) type c,
         txtcab5(150) type c,
         txtcab6(150) type c,
         txtcab7(150) type c,
         txtcab8(150) type c,
         txtcab9(150) type c,
         txtnota_posicion(1500) type c,
         vencida type i,
         graff type lvc_t_scol,
         extrow type extrow,

*T023T  Denominacion de grupo de compras.
        wgbez60 type wgbez60,

         end of ty_salida.

types: begin of ty_lfa1,
         mandt type mandt,
         lifnr type lifnr,
         land1 type land1_gp,
         name1 type name1_gp,
         name2 type name2_gp,
       end of ty_lfa1.

************************************************************************
* TABLAS
************************************************************************


************************************************************************
* ESTRUCTURAS
************************************************************************
data: wa_eban   type ty_eban,
      wa_ekko   type ty_ekko,
      wa_ekpo   type ty_ekpo,
      wa_eket   type ty_eket,
      wa_eketr  type ty_eketr,
      wa_salida type ty_salida,
      wa_salida2 type ty_salida,
      wa_ekkn   type ty_ekkn,
      wa_lfa1   type ty_lfa1,
      wa_ekbe   type ty_ekbe,
      wa_ekber  type ty_ekbe,
      wa_oferta type ty_eketo,
      wa_t023t  type ty_t023t,
      wa_esll   type ty_esll.

*ESTRUCTURAS PARA ALV
data: wa_fieldcat type slis_fieldcat_alv.
data: wa_sort     type slis_sortinfo_alv.
data: wa_events   type slis_alv_event.
data: st_layout   type slis_layout_alv.
data: wa_heading  type slis_listheader.
data: wa_footer   type slis_listheader.
data: wa_ftaxp    type ftaxp.

************************************************************************
* TABLAS INTERNAS
************************************************************************
tables:ekko, eket, ekbe, ekpo, eban.
data:begin of it_ftaxp occurs 50.
  include structure ftaxp.
data: end of it_ftaxp.

data: it_ekpo   type standard table of ty_ekpo,
      it_ekpot  type standard table of ty_ekpo,
      it_ekko   type standard table of ty_ekko,
      it_eban   type standard table of ty_eban,
      it_ebann  type standard table of ty_eban,
      it_lfa1   type standard table of ty_lfa1,
      it_salida type standard table of ty_salida,
      it_salida2 type standard table of ty_salida,
      it_eketr  type standard table of ty_eketr,
      it_eket   type standard table of ty_eket,
      it_ekkn   type standard table of ty_ekkn,
      it_ekbe   type standard table of ty_ekbe,
      it_ekber  type standard table of ty_ekbe,
      it_oferta  type standard table of ty_eketo,
      it_t023t  type standard table of ty_t023t,
      it_esll type standard table of ty_esll.

data: it_fieldcat type slis_t_fieldcat_alv.
data: it_sort type slis_t_sortinfo_alv.
data: it_events type slis_t_event.
*declara  2 TABLA UNA PARA la cabecera y OTRA PARA el pie de pagina
data: it_header type slis_t_listheader.
data: it_footer type slis_t_listheader.



************************************************************************
* VARIABLES
************************************************************************

************************************************************************
* CONSTANTES
************************************************************************

************************************************************************
* PARAMETERS
************************************************************************

************************************************************************
* SELECT-OPTION
************************************************************************
selection-screen begin of block frame1 with frame title titulo.
select-options: s_werks for ekpo-werks obligatory.
select-options: s_ebeln for ekko-ebeln.
select-options: s_afnam for eban-afnam.
select-options: s_banfn for eban-banfn.
select-options: s_ekgrp for eban-ekgrp.

*select-options: s_unsez for ekko-unsez.
select-options: s_lifnr for ekko-lifnr.
select-options s_badat for eban-badat.
select-options s_aedat for ekko-aedat.
selection-screen end of block frame1.
