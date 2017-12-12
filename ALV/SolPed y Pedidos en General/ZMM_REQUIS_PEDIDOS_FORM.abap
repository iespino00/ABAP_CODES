**&---------------------------------------------------------------------*
**&  Include           ZMM_REQUIS_PEDIDOS_FORM
**&---------------------------------------------------------------------*
*
*************************************************************
data:
lc_name   type thead-tdname.
data: v_acum type i.

form get_data.
 refresh it_ekko.
 refresh it_ekpo.
 refresh it_ekpot.
 refresh it_eban.
 refresh it_eket.
 refresh it_eketr.
 refresh it_salida.

if s_afnam is not initial or s_badat is not initial  or  s_ebeln is initial and s_aedat is initial and s_lifnr is initial.
   "EBAN=SOLICITUDES DE PEDIDO.
   select mandt banfn bnfpo loekz statu ekgrp afnam txz01 matnr werks bednr matkl menge meins badat ebeln ebelp ebakz packno
   from eban into corresponding fields of table it_eban
   where werks in s_werks and badat in s_badat and afnam in s_afnam and banfn in s_banfn and ekgrp in s_ekgrp and ebeln in s_ebeln.

   if it_eban is not initial.

        select matkl wgbez wgbez60
       from t023t into corresponding fields of table it_t023t
        for all entries in it_eban
          where matkl = it_eban-matkl.

      "EKKO= LEE EL ENCABEZADO DE LOS PEDIDOS
      select mandt ebeln lifnr spras zterm aedat waers bedat unsez from ekko
      into corresponding fields of table it_ekko
      for all entries in it_eban
      where ebeln = it_eban-ebeln.
      if it_ekko is not initial.
         "EKPO=LEE EL DETALLE DE POSICION DE LOS PEDIDOS PARA TODAS LAS SOLICITUDES EN IT_EBAN.
         select mandt ebeln ebelp loekz matnr txz01 menge netwr banfn bnfpo status netpr mwskz pstyp knttp afnam pstyp knttp
         from ekpo into corresponding fields of table it_ekpot
         for all entries in it_ekko
         where werks in s_werks and ebeln = it_ekko-ebeln.
         "EKKN=IMPUTACION EN EL DOC DE COMPRAS PARA CADA POSICION DE LA IT_EKPO.
         select mandt ebeln ebelp sakto kostl anln1 anln2 from ekkn into corresponding fields of table it_ekkn
         for all entries in it_ekpot
         where ebeln in s_ebeln and ebeln = it_ekpot-ebeln and ebelp = it_ekpot-ebelp.
         "LEE LAS ENTREGAS DEL PEDIDO PARA CADA POSICION DE IT_EKPO
         select ebeln ebelp eindt wemng from eket into corresponding fields of table it_eket
         for all entries in it_ekpot
         where ebeln in s_ebeln and ebeln = it_ekpot-ebeln and ebelp = it_ekpot-ebelp.

         "LIFA1= DATOS MAESTRO DE PROVEEDORES DE LOS PEDIDOS.
         select lifnr land1 name1 name2 from lfa1 into corresponding fields of table it_lfa1
         for all entries in it_ekko
         where lifnr in s_lifnr  and lifnr = it_ekko-lifnr.
      endif.
    endif.
 else.
   select mandt ebeln lifnr spras zterm aedat waers bedat unsez
   from ekko into corresponding fields of table it_ekko
   where ekgrp in s_ekgrp and bukrs in s_werks and ebeln in s_ebeln and lifnr in s_lifnr and aedat in s_aedat.
   if it_ekko is not initial.
      select mandt ebeln ebelp loekz matnr txz01 menge netwr banfn bnfpo status netpr mwskz pstyp knttp afnam
      from ekpo into corresponding fields of table it_ekpot
      for all entries in it_ekko
      where ebeln = it_ekko-ebeln."

      select mandt ebeln ebelp sakto kostl anln1 anln2
      from ekkn into corresponding fields of table it_ekkn
      for all entries in it_ekpot
      where ebeln = it_ekpot-ebeln and ebelp = it_ekpot-ebelp.

      select ebeln ebelp eindt wemng from eket into corresponding fields of table it_eket
      for all entries in it_ekpot
      where ebeln in s_ebeln and ebeln = it_ekpot-ebeln and ebelp = it_ekpot-ebelp.

      select mandt banfn bnfpo loekz statu ekgrp afnam txz01 matnr werks bednr bednr matkl menge meins badat ebeln ebelp packno
      from eban into corresponding fields of table it_eban
      for all entries in it_ekpot
      where ( banfn = it_ekpot-banfn and bnfpo = it_ekpot-bnfpo ).

         select matkl wgbez wgbez60
       from t023t into corresponding fields of table it_t023t.

      select lifnr land1 name1 name2 from lfa1 into corresponding fields of table it_lfa1
      for all entries in it_ekko
      where lifnr in s_lifnr  and lifnr = it_ekko-lifnr  .
   endif.



endif.



clear wa_ekpo.
sort it_eban by banfn bnfpo.
loop at it_ekpot into wa_ekpo.
     clear wa_eban.
     read table it_eban into wa_eban with key banfn = wa_ekpo-banfn bnfpo = wa_ekpo-bnfpo.
     if wa_eban is not initial.
        append wa_ekpo to it_ekpo.
        clear wa_ekpo.
      endif.
endloop.

clear wa_eket.
loop at it_eket into wa_eket.
     move-corresponding wa_eket to wa_eketr.
     collect wa_eketr into it_eketr.
     clear wa_eket.
endloop.
sort it_ekpo by banfn bnfpo.
sort it_eketr by ebeln ebelp.
loop at it_eban into wa_eban where ebeln ne ''.
     v_acum = 0.
     clear wa_ekpo.
     loop at it_ekpo into wa_ekpo where banfn = wa_eban-banfn and bnfpo = wa_eban-bnfpo.
          clear wa_eketr.
          loop at it_eketr into wa_eketr where ebeln = wa_ekpo-ebeln and ebelp = wa_ekpo-ebelp.
               v_acum = v_acum + wa_eketr-wemng. "18/08/14 eketr por eket y wemngt por wemng
          endloop.
     endloop.
     wa_eban-mengea = v_acum.
     modify table it_eban from wa_eban.
endloop.
endform.

form match.
data: v_acum type i.
data: porcentaje type   kbetr.


sort it_ekpo by ebeln ebelp.
sort it_ekko by ebeln.
sort it_lfa1 by lifnr.
sort it_eban by banfn bnfpo.
*loop at it_ekpo into wa_ekpo.
sort it_eket by ebeln ebelp eindt.
sort it_ekbe by ebeln ebelp.
*    read table it_eket into wa_eket with key ebeln = wa_ekko-ebeln ebelp = wa_ekpo-ebelp.
*    loop at it_eket into wa_eket.
*         move-corresponding wa_eket to wa_eketr.
*         wa_eketr-wemngt = wa_eket-wemng.
*         append wa_eketr to it_eketr.
*    endloop.
*endloop.

*clear wa_eban.
*loop at it_eban  into wa_eban.
*     v_acum = 0.
*     clear wa_ekpo.
*     loop at it_ekpo into wa_ekpo where banfn = wa_eban-banfn and bnfpo = wa_eban-bnfpo.
*          clear wa_eket.
*          loop at it_eket into wa_eket where ebeln = wa_ekpo-ebeln and ebelp = wa_ekpo-ebelp.
*               v_acum = v_acum + wa_eket-wemng. "18/08/14 eketr por eket y wemngt por wemng
*          endloop.
*     endloop.
*     wa_eban-mengea = v_acum.
*     modify table it_eban from wa_eban.
*endloop.

clear wa_ekpo.

if it_ekko is not initial.
   loop at it_ekpo into wa_ekpo.
        clear wa_ekko.
        read table it_ekko into wa_ekko with key ebeln = wa_ekpo-ebeln.
        if wa_ekko is not initial.
           call function 'GET_TAX_PERCENTAGE'
           exporting
             aland         = 'MX'
             datab         = wa_ekko-aedat
             mwskz         = wa_ekpo-mwskz
             txjcd         = ''
           tables
             t_ftaxp       = it_ftaxp.
           if sy-subrc eq 0.
              loop at it_ftaxp .
                   porcentaje = it_ftaxp-kbetr / 1000.
              endloop.
           endif.
           wa_salida-ebelp  = wa_ekpo-ebelp.
           wa_salida-ebeln  = wa_ekpo-ebeln.
           wa_salida-loekzp = wa_ekpo-loekz.
           wa_salida-txz01p = wa_ekpo-txz01.
           wa_salida-matnrp = wa_ekpo-matnr.
           wa_salida-status = wa_ekpo-status.
           wa_salida-mengep = wa_ekpo-menge.
           wa_salida-netwr  = wa_ekpo-netwr.
           wa_salida-netpri = wa_ekpo-netpr + ( wa_ekpo-netpr * porcentaje ) .
           wa_salida-netwri = wa_ekpo-netwr + ( wa_ekpo-netwr * porcentaje ) .
           wa_salida-netpr  = wa_ekpo-netpr.
           wa_salida-mwskz  = wa_ekpo-mwskz.
           wa_salida-pstyp  = wa_ekpo-pstyp.
           wa_salida-knttp  = wa_ekpo-knttp.
           wa_salida-aedat  = wa_ekko-aedat.
           wa_salida-waers  = wa_ekko-waers.
           wa_salida-unsez  = wa_ekko-unsez.
           wa_salida-zterm  = wa_ekko-zterm.
           wa_salida-lifnr  = wa_ekko-lifnr.
           shift wa_salida-lifnr left deleting leading '0'.
           clear wa_lfa1.
           read table it_lfa1 into wa_lfa1 with key lifnr = wa_ekko-lifnr.
           if wa_lfa1 is not initial.
              concatenate wa_lfa1-name1 wa_lfa1-name2 into wa_salida-name1.
           endif.
           clear wa_eket.
           read table it_eket into wa_eket with key ebeln = wa_ekpo-ebeln ebelp = wa_ekpo-ebelp.
           if wa_eket is not initial.
              wa_salida-eindt = wa_eket-eindt.
           endif.
           clear wa_eketr. "Se cambio eketr por eket sin R sin efecto
           read table it_eketr into wa_eketr with key ebeln = wa_ekpo-ebeln ebelp = wa_ekpo-ebelp.
           if wa_eketr is not initial.
*              wa_salida-eindt = wa_eket-eindt.
              wa_salida-wemng = wa_eketr-wemng.
              wa_salida-pendt  = ( wa_ekpo-menge - wa_eketr-wemng ). "( wa_ekpo-menge - wa_eketr-wemngt ).
           endif.
           clear wa_ekkn.
           read table it_ekkn into wa_ekkn with key ebeln = wa_ekko-ebeln ebelp = wa_ekpo-ebelp.
           if wa_ekkn is not initial.
              wa_salida-sakto = wa_ekkn-sakto.
              wa_salida-kostl = wa_ekkn-kostl.
              wa_salida-anln1 = wa_ekkn-anln1.
              wa_salida-anln2 = wa_ekkn-anln2.
           endif.
           select mandt ebeln ebelp bwart budat from ekbe into corresponding fields of table it_ekbe
           where ebeln = wa_ekpo-ebeln and ebelp = wa_ekpo-ebelp and bwart = 101 .
           clear wa_ekbe.
           read table it_ekbe into wa_ekbe with key ebeln = wa_ekpo-ebeln ebelp = wa_ekpo-ebelp.
           wa_salida-budat = wa_ekbe-budat.
           clear wa_eban.
*           read table it_eban into wa_eban with key banfn = wa_ekpo-banfn bnfpo = wa_ekpo-bnfpo.
           read table it_eban into wa_eban with key ebeln = wa_ekpo-ebeln ebelp = wa_ekpo-ebelp.
           if wa_eban is not initial.
              move-corresponding wa_eban to wa_salida.
              shift wa_salida-banfn left deleting leading '0'.
              wa_salida-pendtr = ( wa_eban-menge - wa_eban-mengea ).
* Leer texto de la cabecera de la solicitud.
* leer nota de posición
              lc_name = wa_eban-banfn.
              perform lee_texto.
              perform leer_nota_posicion.
           endif.
           append wa_salida to it_salida.
           clear wa_salida.
        endif.
   endloop.
   "************************Se requiere limpiar wa salida antes de mover wa_eban.
   clear wa_eban.
   clear wa_salida.
   loop at it_eban  into wa_eban where ebeln =''.
        move-corresponding wa_eban to wa_salida.
        shift wa_salida-banfn left deleting leading '0'.
*Leer texto de la cabecera de la solicitud.
        lc_name = wa_eban-banfn.
        perform lee_texto.
        perform leer_nota_posicion.
        append wa_salida to it_salida.
        clear wa_salida.
   endloop.
*   clear wa_eban.
*   loop at it_eban into wa_eban where banfn <>''.
*        clear wa_ekpo.
*        read table it_ekpo into wa_ekpo with key ebeln = wa_eban-banfn.
*        wa_salida-banfn = wa_eban-banfn.
*        wa_salida-BNFPO = wa_eban-BNFPO.
*        wa_salida-LOEKZ = wa_eban-LOEKZ.
*        wa_salida-STATU = wa_eban-STATU.
*        wa_salida-EKGRP = wa_eban-EKGRP.
*        wa_salida-AFNAM = wa_eban-AFNAM.
*        wa_salida-TXZ01 = wa_eban-TXZ01.
*        wa_salida-MATNR = wa_eban-MATNR.
*        wa_salida-WERKS = wa_eban-WERKS.
*        wa_salida-BEDNR = wa_eban-BEDNR.
*        wa_salida-MATKL = wa_eban-MATKL.
*        wa_salida-MENGE = wa_eban-MENGE.
*        wa_salida-MEINS = wa_eban-MEINS.
*        wa_salida-BADAT = wa_eban-BADAT.
*        wa_salida-MENGEA = wa_eban-MENGEA.
*        shift wa_salida-banfn left deleting leading '0'.
*Leer texto de la cabecera de la solicitud
*        lc_name = wa_eban-banfn.
*        perform lee_texto.
*        append wa_salida to it_salida.
*        clear it_eban.
*   endloop.
else.
   sort it_eban by banfn.
   clear wa_eban.
   loop at it_eban  into wa_eban.
        move-corresponding wa_eban to wa_salida.
        shift wa_salida-banfn left deleting leading '0'.
*Leer texto de la cabecera de la solicitud.
        lc_name = wa_eban-banfn.
        perform lee_texto.
        perform leer_nota_posicion.
        append wa_salida to it_salida.
   endloop.
endif.

sort it_salida by banfn bnfpo ebeln ebelp.

clear wa_salida.


*Loop para validar fecha de resago de sol ped, peticiones de oferta y pedidos, en base a 6 meses después de su creación.
loop at it_salida into wa_salida.
*Si tiene status N= No tratado, se valida la fecha de cración contra la fecha actual

*Para obtener la denominación de los grupos de articulos
 perform denominacion_grpo_art.
 perform leer_textos_servicios.

 if wa_salida-ebakz eq 'X'.

 perform solped_concluida.

else.
    if wa_salida-statu eq 'N'.
     perform get_no_tratada.
    endif.

    if wa_salida-statu eq 'A'.
     perform get_con_oferta.
    endif.

    if wa_salida-statu eq 'B' or wa_salida-banfn =''.
     perform get_pedido.
    endif.


endif.



endloop.

*Paso los registros de los textos de servicio.
loop at it_salida2 into wa_salida2.
move-corresponding wa_salida2 to wa_salida.
append wa_salida to it_salida.
endloop.
sort it_salida by banfn.

endform.

form solped_concluida.
refresh lt_color.
wa_salida-vencida = 0.
    wa_color-fname    = 'VENCIDA'.
    wa_color-color-col = 1.
    wa_color-color-int = 1.
    wa_color-color-inv = 1.
    append wa_color to lt_color.
    wa_salida-graff = lt_color.
modify it_salida from wa_salida transporting vencida.
modify it_salida from wa_salida transporting graff.

endform.

form denominacion_grpo_art.
read table it_t023t into wa_t023t with key matkl = wa_salida-matkl.
  if wa_t023t-matkl = wa_salida-matkl.
    wa_salida-wgbez60 = wa_t023t-wgbez60.
    modify it_salida from wa_salida transporting wgbez60.
  endif.
endform.

form get_no_tratada.
refresh lt_color.
      data :fecha_sol_ped like sy-datum,
            fecha_actual like sy-datum,
             dias type i,
             semanas type i,
             meses type i,
             annos type i,
             age(30) type c.


      fecha_sol_ped = wa_salida-badat.
      fecha_actual = sy-datum.

      call function 'HR_99S_INTERVAL_BETWEEN_DATES'
        exporting
          begda           = fecha_sol_ped
          endda           = fecha_actual
        importing
          days            = dias
          weeks           = semanas
          months          = meses
          years           = annos.
 wa_salida-vencida = meses.

*Si la solicitud tiene menos de 6 meses, se pinta la celda de color VERDE, DE LO CONTRARIO SE PONE EN ROJO...
 if wa_salida-vencida < 6.

    wa_color-fname    = 'VENCIDA'.
    wa_color-color-col = 5.
    wa_color-color-int = 1.
    wa_color-color-inv = 1.
    append wa_color to lt_color.
    wa_salida-graff = lt_color.

else.
    wa_color-fname    = 'VENCIDA'.
    wa_color-color-col = 6.
    wa_color-color-int = 1.
    wa_color-color-inv = 1.
    append wa_color to lt_color.
    wa_salida-graff = lt_color.
endif.

 modify it_salida from wa_salida transporting vencida.
 modify it_salida from wa_salida transporting graff.
endform.

form get_con_oferta.

    data:v_solicitud type banfn.

    call function 'CONVERSION_EXIT_ALPHA_INPUT' "Funcion para rellenar de ceros al numero de la solped
     exporting
      input = wa_salida-banfn
     importing
      output = v_solicitud.

refresh it_oferta.

   select  ebeln bedat
   from eket into corresponding fields of table it_oferta
     where banfn = v_solicitud and bnfpo = wa_salida-bnfpo.

loop at it_oferta into wa_oferta.
refresh lt_color.
 data :fecha_oferta like sy-datum,
            fecha_actual like sy-datum,
             dias type i,
             semanas type i,
             meses type i,
             annos type i,
             age(30) type c.
      fecha_oferta = wa_oferta-bedat.
      fecha_actual = sy-datum.

      call function 'HR_99S_INTERVAL_BETWEEN_DATES'
        exporting
          begda           = fecha_oferta
          endda           = fecha_actual
        importing
          days            = dias
          weeks           = semanas
          months          = meses
          years           = annos.
 wa_salida-vencida = meses.
*Si la solicitud tiene menos de 6 meses, se pinta la celda de color VERDE, DE LO CONTRARIO SE PONE EN ROJO...
 if wa_salida-vencida < 6.

    wa_color-fname    = 'VENCIDA'.
    wa_color-color-col = 5.
    wa_color-color-int = 1.
    wa_color-color-inv = 1.
    append wa_color to lt_color.
    wa_salida-graff = lt_color.

else.
    wa_color-fname    = 'VENCIDA'.
    wa_color-color-col = 6.
    wa_color-color-int = 1.
    wa_color-color-inv = 1.
    append wa_color to lt_color.
    wa_salida-graff = lt_color.
endif.

 modify it_salida from wa_salida transporting vencida.
 modify it_salida from wa_salida transporting graff.
endloop.


endform.

form get_pedido.


   refresh it_oferta.

   clear wa_oferta.
   select  ebeln bedat
   from eket into corresponding fields of table it_oferta
     where ebeln = wa_salida-ebeln and ebelp = wa_salida-ebelp.

loop at it_oferta into wa_oferta.
refresh lt_color.


 data :fecha_pedido like sy-datum,
            fecha_actual like sy-datum,
             dias type i,
             semanas type i,
             meses type i,
             annos type i,
             age(30) type c.
      fecha_pedido = wa_oferta-bedat.
      fecha_actual = sy-datum.

      call function 'HR_99S_INTERVAL_BETWEEN_DATES'
        exporting
          begda           = fecha_pedido
          endda           = fecha_actual
        importing
          days            = dias
          weeks           = semanas
          months          = meses
          years           = annos.
 wa_salida-vencida = meses.

*Si la solicitud tiene menos de 6 meses, se pinta la celda de color VERDE, DE LO CONTRARIO SE PONE EN ROJO...
 if wa_salida-vencida < 6.

    wa_color-fname    = 'VENCIDA'.
    wa_color-color-col = 5.
    wa_color-color-int = 1.
    wa_color-color-inv = 1.
    append wa_color to lt_color.
    wa_salida-graff = lt_color.

else.
    wa_color-fname    = 'VENCIDA'.
    wa_color-color-col = 6.
    wa_color-color-int = 1.
    wa_color-color-inv = 1.
    append wa_color to lt_color.
    wa_salida-graff = lt_color.
endif.

 modify it_salida from wa_salida transporting vencida.
 modify it_salida from wa_salida transporting graff.
endloop.


endform.


form llena_catalogo_alv.
  refresh it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '1'.
  wa_fieldcat-fieldname = 'BANFN'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Sol. Ped'.
  wa_fieldcat-seltext_m = 'SOLICITUD PED'.
  wa_fieldcat-seltext_l = 'SOL. PEDIDO'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '2'.
  wa_fieldcat-fieldname = 'BNFPO'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Pos.Sol.Ped'.
  wa_fieldcat-seltext_m = 'POS. SOLICITUD PED'.
  wa_fieldcat-seltext_l = 'Pos.Sol.Ped'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '3'.
  wa_fieldcat-fieldname = 'LOEKZ'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Ind. Borrado'.
  wa_fieldcat-seltext_m = 'Ind. Borrado'.
  wa_fieldcat-seltext_l = 'Ind. Borrado'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '4'.
  wa_fieldcat-fieldname = 'STATU'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Estatus'.
  wa_fieldcat-seltext_m = 'Estatus'.
  wa_fieldcat-seltext_l = 'Estatus'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '5'.
  wa_fieldcat-fieldname = 'EKGRP'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Grupo Compras'.
  wa_fieldcat-seltext_m = 'Grupo Compras'.
  wa_fieldcat-seltext_l = 'Grupo Compras'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '6'.
  wa_fieldcat-fieldname = 'AFNAM'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Solicitante'.
  wa_fieldcat-seltext_m = 'Solicitante'.
  wa_fieldcat-seltext_l = 'Solicitante'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '7'.
  wa_fieldcat-fieldname = 'BEDNR'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Area Solic'.
  wa_fieldcat-seltext_m = 'Area Solic'.
  wa_fieldcat-seltext_l = 'Area Solic'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '8'.
  wa_fieldcat-fieldname = 'TXZ01'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Texto Sol'.
  wa_fieldcat-seltext_m = 'Texto Sol'.
  wa_fieldcat-seltext_l = 'Texto Sol'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '9'.
  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Material'.
  wa_fieldcat-seltext_m = 'Material'.
  wa_fieldcat-seltext_l = 'Material'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '10'.
  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Centro'.
  wa_fieldcat-seltext_m = 'Centro'.
  wa_fieldcat-seltext_l = 'Centro'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '11'.
  wa_fieldcat-fieldname = 'MATKL'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Grupo de Art'.
  wa_fieldcat-seltext_m = 'Grupo de Art'.
  wa_fieldcat-seltext_l = 'Grupo de Art'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '12'.
  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Cantidad Sol'.
  wa_fieldcat-seltext_m = 'Cantidad Sol'.
  wa_fieldcat-seltext_l = 'Cantidad Sol'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '13'.
  wa_fieldcat-fieldname = 'MEINS'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Unidad Med'.
  wa_fieldcat-seltext_m = 'Unidad Med'.
  wa_fieldcat-seltext_l = 'Unidad Med'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '14'.
  wa_fieldcat-fieldname = 'BADAT'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Fecha Sol'.
  wa_fieldcat-seltext_m = 'Fecha Sol'.
  wa_fieldcat-seltext_l = 'Fecha Sol'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '15'.
  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Pedido'.
  wa_fieldcat-seltext_m = 'Pedido'.
  wa_fieldcat-seltext_l = 'Pedido'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '16'.
  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Fecha Pedido'.
  wa_fieldcat-seltext_m = 'Fecha Pedido'.
  wa_fieldcat-seltext_l = 'Fecha Pedido'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '17'.
  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Pos. Ped'.
  wa_fieldcat-seltext_m = 'Pos. Ped'.
  wa_fieldcat-seltext_l = 'Pos. Ped'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '18'.
  wa_fieldcat-fieldname = 'LOEKZP'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Ind. Borrado Ped'.
  wa_fieldcat-seltext_m = 'Ind. Borrado Ped'.
  wa_fieldcat-seltext_l = 'Ind. Borrado Ped'.
  append wa_fieldcat to it_fieldcat.


  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '19'.
  wa_fieldcat-fieldname = 'MENGEP'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Cant Ped'.
  wa_fieldcat-seltext_m = 'Cant Ped'.
  wa_fieldcat-seltext_l = 'CANTIDAD PED'.
  append wa_fieldcat to it_fieldcat.


  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '20'.
  wa_fieldcat-fieldname = 'LIFNR'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Proveedor'.
  wa_fieldcat-seltext_m = 'Proveedor'.
  wa_fieldcat-seltext_l = 'Proveedor'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '21'.
  wa_fieldcat-fieldname = 'EINDT'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Fecha Entrega'.
  wa_fieldcat-seltext_m = 'Fecha Entrega'.
  wa_fieldcat-seltext_l = 'Fecha Entrega'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '22'.
  wa_fieldcat-fieldname = 'ZTERM'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Condicion'.
  wa_fieldcat-seltext_m = 'Condicion'.
  wa_fieldcat-seltext_l = 'Condicion'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '23'.
  wa_fieldcat-fieldname = 'BUDAT'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Fecha de Entrada'.
  wa_fieldcat-seltext_m = 'Fecha de Entrada'.
  wa_fieldcat-seltext_l = 'Fecha de Entrada'.
  append wa_fieldcat to it_fieldcat.


  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '24'.
  wa_fieldcat-fieldname = 'WEMNG'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Cant. Entrada'.
  wa_fieldcat-seltext_m = 'Cant. Entrada'.
  wa_fieldcat-seltext_l = 'Cant. Entrada'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '25'.
  wa_fieldcat-fieldname = 'PENDT'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Pend OC'.
  wa_fieldcat-seltext_m = 'Pend OC'.
  wa_fieldcat-seltext_l = 'Pend OC'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '26'.
  wa_fieldcat-fieldname = 'PENDTR'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Pend Solped'.
  wa_fieldcat-seltext_m = 'Pend Solped'.
  wa_fieldcat-seltext_l = 'Pend Solped'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '27'.
  wa_fieldcat-fieldname = 'NETPR'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Precio Neto'.
  wa_fieldcat-seltext_m = 'Precio Neto'.
  wa_fieldcat-seltext_l = 'Precio Neto'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '28'.
  wa_fieldcat-fieldname = 'NETPRI'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Precio Neto C/Iva'.
  wa_fieldcat-seltext_m = 'Precio Neto C/Iva'.
  wa_fieldcat-seltext_l = 'Precio Neto C/Iva'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '29'.
  wa_fieldcat-fieldname = 'NETWR'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Valor Bruto'.
  wa_fieldcat-seltext_m = 'Valor Bruto'.
  wa_fieldcat-seltext_l = 'Valor Bruto'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '30'.
  wa_fieldcat-fieldname = 'NETWRI'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Valor Bruto C/Iva'.
  wa_fieldcat-seltext_m = 'Valor Bruto C/Iva'.
  wa_fieldcat-seltext_l = 'Valor Bruto C/Iva'.
  append wa_fieldcat to it_fieldcat.

 clear: wa_fieldcat.
  wa_fieldcat-col_pos = '31'.
  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Nom Proveedor'.
  wa_fieldcat-seltext_m = 'Nom Proveedor'.
  wa_fieldcat-seltext_l = 'Nom Proveedor'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '32'.
  wa_fieldcat-fieldname = 'WAERS'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Moneda'.
  wa_fieldcat-seltext_m = 'Moneda'.
  wa_fieldcat-seltext_l = 'Moneda'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '33'.
  wa_fieldcat-fieldname = 'UNSEZ'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Cuadro'.
  wa_fieldcat-seltext_m = 'Cuadro'.
  wa_fieldcat-seltext_l = 'Cuadro'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '34'.
  wa_fieldcat-fieldname = 'TXTCAB'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '35'.
  wa_fieldcat-fieldname = 'TXTCAB1'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '36'.
  wa_fieldcat-fieldname = 'TXTCAB2'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '37'.
  wa_fieldcat-fieldname = 'TXTCAB3'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '38'.
  wa_fieldcat-fieldname = 'TXTCAB4'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '39'.
  wa_fieldcat-fieldname = 'TXTCAB5'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '40'.
  wa_fieldcat-fieldname = 'TXTCAB6'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '41'.
  wa_fieldcat-fieldname = 'TXTCAB7'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '42'.
  wa_fieldcat-fieldname = 'TXTCAB8'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '43'.
  wa_fieldcat-fieldname = 'TXTCAB9'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Uso'.
  wa_fieldcat-seltext_m = 'Uso'.
  wa_fieldcat-seltext_l = 'Uso'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.

    clear: wa_fieldcat.
  wa_fieldcat-col_pos = '44'.
  wa_fieldcat-fieldname = 'VENCIDA'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Meses de Atraso'.
  wa_fieldcat-seltext_m = 'Meses de Atraso'.
  wa_fieldcat-seltext_l = 'Meses de Atraso'.
  append wa_fieldcat to it_fieldcat.

    clear: wa_fieldcat.
  wa_fieldcat-col_pos = '45'.
  wa_fieldcat-fieldname = 'WGBEZ60'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Denominacion grpo Art'.
  wa_fieldcat-seltext_m = 'Denominacion grpo Art'.
  wa_fieldcat-seltext_l = 'Denominacion grpo Art'.
  append wa_fieldcat to it_fieldcat.

    clear: wa_fieldcat.
  wa_fieldcat-col_pos = '46'.
  wa_fieldcat-fieldname = 'TXTNOTA_POSICION'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Nota Pos SolPed'.
  wa_fieldcat-seltext_m = 'Nota Pos SolPed'.
  wa_fieldcat-seltext_l = 'Nota Pos SolPed'.
*  wa_fieldcat-outputlen = 500.
*  wa_fieldcat-datatype = 'CHAR'.
  append wa_fieldcat to it_fieldcat.


    clear: wa_fieldcat.
  wa_fieldcat-col_pos = '47'.
  wa_fieldcat-fieldname = 'EXTROW'.
  wa_fieldcat-tabname = 'IT_SALIDA'.
  wa_fieldcat-seltext_s = 'Linea de Servicio'.
  wa_fieldcat-seltext_m = 'Linea de Servicio'.
  wa_fieldcat-seltext_l = 'Linea de Servicio'.
  append wa_fieldcat to it_fieldcat.



  endform.

form llena_sort.
* clear wa_sort.
*  wa_sort-fieldname = 'BANFN'.
*  wa_sort-tabname = 'IT_SALIDA'.
*  wa_sort-down = 'X'.
* wa_sort-subtot = 'X'.
*  append wa_sort to it_sort.

 endform.
form llena_layout.
  st_layout-window_titlebar = 'Reporte'.
  st_layout-colwidth_optimize = 'X'.
  st_layout-coltab_fieldname  = 'GRAFF'.
  endform.
*PERFORM header_and_footer.
form cal_alv.

 call function 'REUSE_ALV_GRID_DISPLAY'
  exporting
*   I_INTERFACE_CHECK              = ' '
*    I_BYPASSING_BUFFER             =
*     I_BUFFER_ACTIVE                = space
     i_callback_program             = sy-repid
*    I_CALLBACK_PF_STATUS_SET       = ' '
    i_callback_user_command        = ' '
*    I_STRUCTURE_NAME               =
    is_layout                      = st_layout
    it_fieldcat                    = it_fieldcat
*    IT_EXCLUDING                   =
*    IT_SPECIAL_GROUPS              =
    it_sort                        = it_sort
*    IT_FILTER                      =
*    IS_SEL_HIDE                    =
*    I_DEFAULT                      = 'X'
*    I_SAVE                         = ' '
*    IS_VARIANT                     =
     it_events                      = it_events
*    IT_EVENT_EXIT                  =
*    IS_PRINT                       =
*    IS_REPREP_ID                   =
*    I_SCREEN_START_COLUMN          = 0
*    I_SCREEN_START_LINE            = 0
*    I_SCREEN_END_COLUMN            = 0
*    I_SCREEN_END_LINE              = 0
*    IR_SALV_LIST_ADAPTER           =
*    IT_EXCEPT_QINFO                =
*    I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
*  IMPORTING
*    E_EXIT_CAUSED_BY_CALLER        =
*    ES_EXIT_CAUSED_BY_USER         =
   tables
     t_outtab                       = it_salida
  exceptions
    program_error                  = 1
    others                         = 2
           .
 if sy-subrc <> 0.
 message id sy-msgid type sy-msgty number sy-msgno
         with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 endif.
endform.

*LZC384-AGREGAR TEXTOS DE LINEAS DE SERVICIO
form leer_textos_servicios.

data: lc_tabix  type sy-tabix,
      lc_id     type thead-tdid,
      lc_object type thead-tdobject,
      wa_lines  type tline,
      lv_linea  type i,
      paquete type packno,
      linea type tdline,
      texto(1500) type c,
      texto_ant(1500) type c,
      posicion type extrow,
      pos_anterior type extrow,
      lt_lines  type table of tline with header line.

refresh lt_lines.

lc_id = 'LTXT'. " Texto donde está el STRING buscado
lc_object = 'ESLL'. " Tabla de textos

    select packno sub_packno
       from esll into corresponding fields of table it_esll
       where packno = wa_salida-packno.

       read table it_esll into wa_esll with key packno = wa_salida-packno.
       paquete = wa_esll-sub_packno.
       clear it_esll.

      select packno introw extrow ktext1
      from esll into corresponding fields of table it_esll
      where packno = paquete.


      loop at it_esll into wa_esll.


*FUNCION PARA QUITAR LOS CEROS A LA IZQUIERDA DE LA LINEA DEL SERVICIO
       call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
       exporting
        input = wa_esll-extrow
       importing
        output = posicion.

concatenate wa_esll-packno wa_esll-introw into lc_name.

        call function 'READ_TEXT'
        exporting
          id = lc_id
          language = sy-langu
          name = lc_name
          object = lc_object
        tables
          lines = lt_lines
        exceptions
          id = 1
          language = 2
          name = 3
          not_found = 4
          object = 5
          reference_check = 6
          wrong_access_to_archive = 7
        others = 8.


        lv_linea = 0.
        if sy-subrc eq 0.

clear wa_salida2.
wa_salida2 = wa_salida.
   loop at lt_lines into wa_lines.

        case lv_linea.
             when 0.

                  wa_salida2-txtcab = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 1.

                  wa_salida2-txtcab1 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 2.

                  wa_salida2-txtcab2 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 3.

                  wa_salida2-txtcab3 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 4.

                  wa_salida2-txtcab4 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 5.

                  wa_salida2-txtcab5 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 6.

                  wa_salida2-txtcab6 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 7.

                  wa_salida2-txtcab7 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 8.

                  wa_salida2-txtcab8 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
             when 9.

                  wa_salida2-txtcab9 = wa_lines-tdline.
                  wa_salida2-extrow = posicion.
        endcase.
        lv_linea = lv_linea + 1.

   endloop.
*           texto = ''.
*           loop at lt_lines into wa_lines.
*           wa_salida2-txt_linea_servicio = ''.
*           concatenate  texto ' ' wa_lines-tdline  into texto.
*
*                wa_salida2-txt_linea_servicio = texto.
*                wa_salida2-extrow = posicion.
*           endloop.
       append wa_salida2 to it_salida2.
        endif.

      endloop.

endform.

form leer_nota_posicion.
data: lc_tabix  type sy-tabix,
      lc_id     type thead-tdid,
      lc_object type thead-tdobject,
      wa_lines  type tline,
      lc_name   type thead-tdname,
      lv_linea  type i,
      posicion  type bnfpo,
      solicitud type banfn,
      lt_lines  type table of tline with header line.

call function 'CONVERSION_EXIT_ALPHA_INPUT'
 exporting
  input = wa_salida-banfn
 importing
  output = solicitud.

call function 'CONVERSION_EXIT_ALPHA_INPUT'
 exporting
  input = wa_salida-bnfpo
 importing
  output = posicion.

concatenate solicitud posicion into lc_name.

refresh lt_lines.

lc_id = 'B02'. " Texto donde está el STRING buscado
lc_object = 'EBAN'. " Tabla de textos


call function 'READ_TEXT'
exporting
  id = lc_id
  language = sy-langu
  name = lc_name
  object = lc_object
tables
  lines = lt_lines
exceptions
  id = 1
  language = 2
  name = 3
  not_found = 4
  object = 5
  reference_check = 6
  wrong_access_to_archive = 7
others = 8.

lv_linea = 0.
if sy-subrc eq 0.
   wa_salida-txtnota_posicion = ''.
   loop at lt_lines into wa_lines.
        case lv_linea.

             when 2.
                   wa_salida-txtnota_posicion = wa_lines-tdline.

        endcase.
        lv_linea = lv_linea + 1.

   endloop.
endif.
endform.



form lee_texto.
data: lc_tabix  type sy-tabix,
      lc_id     type thead-tdid,
      lc_object type thead-tdobject,
      wa_lines  type tline,
      lv_linea  type i,
      lt_lines  type table of tline with header line.

* Busco el texto de destinatario

refresh lt_lines.

lc_id = 'B01'. " Texto donde está el STRING buscado
lc_object = 'EBANH'. " Tabla de textos
*lc_name = ‘450003235800010’. “ Respetar ceros a la izquierda (si hubiere) y entre el Pedido y la Posición

call function 'READ_TEXT'
exporting
  id = lc_id
  language = sy-langu
  name = lc_name
  object = lc_object
tables
  lines = lt_lines
exceptions
  id = 1
  language = 2
  name = 3
  not_found = 4
  object = 5
  reference_check = 6
  wrong_access_to_archive = 7
others = 8.

* El resultado es devuelto en la tabla lt_lines que tiene dos campos:
* TDFORMAT (CHAR 2)
* TDLINE (CHAR132)
lv_linea = 0.
if sy-subrc eq 0.
   wa_salida-txtcab = ''.
*   READ TABLE lt_lines INDEX 1.
   loop at lt_lines into wa_lines.
        case lv_linea.
             when 0.
                  wa_salida-txtcab = wa_lines-tdline.
             when 1.
                  wa_salida-txtcab1 = wa_lines-tdline.
             when 2.
                  wa_salida-txtcab2 = wa_lines-tdline.
             when 3.
                  wa_salida-txtcab3 = wa_lines-tdline.
             when 4.
                  wa_salida-txtcab4 = wa_lines-tdline.
             when 5.
                  wa_salida-txtcab5 = wa_lines-tdline.
             when 6.
                  wa_salida-txtcab6 = wa_lines-tdline.
             when 7.
                  wa_salida-txtcab7 = wa_lines-tdline.
             when 8.
                  wa_salida-txtcab8 = wa_lines-tdline.
             when 9.
                  wa_salida-txtcab9 = wa_lines-tdline.
        endcase.
        lv_linea = lv_linea + 1.
*    concatenate wa_salida-txtcab lt_lines-tdline into wa_salida-txtcab.
   endloop.
endif.

endform.
