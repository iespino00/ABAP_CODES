report  z_mm_cuadro_comparativo no standard page heading line-size 355 line-count 75.
************************************************************************
* Descripción.: Reporte comparativo de precios de materiales y servicios
*
tables: ekko,
        ekpo,
        eket,
        mara.

data:    begin of xekpo occurs 20.
        include structure ekpo.
data:      lamng like ekpo-menge,   "Ktmng in Basismengeneinheit
           proze(3) type p,         "Prozentzahl des Wertes
           rang like sy-tabix,      "Rang der Angebotsposition
           gruppe like sy-tabix,    "Gruppe der Position
           netpr5(16) type p decimals 5,
         end of xekpo.

data:    begin of yekpo occurs 5.
        include structure ekpo.
data:    end of yekpo.

data:    begin of xekko occurs 20.
        include structure ekko.
data:      wert like ekpo-zwert,    "Summe der Nettowerte der Positionen
           proze(3) type p,         "Prozentzahl des Wertes
           rang like sy-tabix,      "Rang des Angebots
         end of xekko.

data: begin of srvtab   occurs 100.
        include structure srv_tab.
data:   ublock like sy-index,
        link   like sy-index,
        indekko like sy-index.
data: end of srvtab.


data: index_xekko like sy-tabix,
      diff_language.

data: aktind   like sy-tabix,
      maxind   like sy-tabix,
      firstind like sy-tabix,
      pagind   like sy-tabix.

data: begin of ekkokey,
        mandt like sy-mandt,
        ebeln like ekko-ebeln,
      end of ekkokey.

data: begin of packtab  occurs 20.
        include structure pack_tab.
data: end of packtab.


data: begin of total_oferta occurs 20,
        ebeln   like ekko-ebeln,
        tot_ofe type ktwrt.
data: end of total_oferta.


data:    begin of s_xekpo occurs 20.
        include structure ekpo.
data:      lamng like ekpo-menge,   "Ktmng in Basismengeneinheit
           proze(3) type p,         "Prozentzahl des Wertes
           rang like sy-tabix,      "Rang der Angebotsposition
           gruppe like sy-tabix,    "Gruppe der Position
           netpr5(16) type p decimals 5,
         end of s_xekpo.

data:    begin of s_xekko occurs 20.
        include structure ekko.
data:      wert like ekpo-zwert,    "Summe der Nettowerte der Positionen
           proze(3) type p,         "Prozentzahl des Wertes
           rang like sy-tabix,      "Rang des Angebots
         end of s_xekko.

types: begin of t_datos,
        matnr like ekpo-matnr,
        ebeln like ekko-ebeln,
        ktmng like ekpo-ktmng,
       end of t_datos.

data : tab_exc type standard table of t_datos with header line.   "Tabla general de excepciones


data : wa_vf like zmm_vf.

data: helpind   like sy-tabix.
data: old_spras like ekko-spras.

data:    xactvt like tact-actvt,         "Hilfsfeld Aktivität
         xactxt(10),                     "Hilfsfeld Aktivitätstext
         xobjekt(10),                    "Hilfsfeld Objekt
         xobjtxt(15),                    "Hilfsfeld Objekttext
         xfldtxt(15),                    "Hilfsfeld Feldtext
         xact,                           "Aktivität für Berecht.prüfung
         xauth.                          "Kz. Selektion ausgel. wg. Ber.

data : lon_ray type i,
       lon_col type i value 35,
       lon_dis type i value 250,
       lon_des type i,
       pos_col type i,
       pos_des type i,
       pos_rve type i,
       pos_num type i,
       con_col type i,
       col_tot type i,
       con_ind type i,
       sum_ofe type ktwrt,
       val_min type ktwrt,
       sal_pmi,
       sal_pme,
       swi_ini,
       l_page_count(5) type c.

data : sal_ind type i,
       sal_mat type matnr,
       mon_min type netpr,  "Monto mínimo
       mon_med type netpr,  "Monto medio
       pco_min type netpr,  "Precio mínimo
       pco_med type netpr,  "Precio medio
       pco_max type netpr,  "Precio maximo
       acu_min type netpr,  "Acumulado precio mínimo
       acu_med type netpr,  "Acumulado precio medio
       l_monto type netpr,
       g_resco type c,
       g_monto type netpr,
       g_preci type netpr,
       g_docto type ebeln,
       g_fech1 type datum,
       g_fech2 type datum,
       g_convt type c,      "Para saber si hay que convertir al tipo de cambio
       swi_ent.

data : col_nec type i, "Columnas necesarias
       col_dis type i, "Columnas disponibles
       col_res type i, "Columnas restantes
       col_des type i, "Columnas desplegadas
       can_pas type i. "Cantidad de pasadas.

* atm01.begin.insert

data: wa_firma1 like zeban_firmas.
data: wa_firma2 like zeban_firmas.
data: wa_firma3 like zeban_firmas.

* atm01.end.insert
ranges r_matnr for mara-matnr.

parameters:      p_ekorg like ekko-ekorg memory id eko obligatory.
select-options:  p_ebeln for ekko-ebeln matchcode object mekk,
                 p_submi for ekko-submi,
                 p_lifnr for ekko-lifnr matchcode object kred,
                 p_matnr for ekpo-matnr matchcode object mat1.

selection-screen skip 1.
selection-screen begin of block block1 with frame title text-001.
parameters:
                 p_anfbas like rm06i-psanf     "Bezugsanfrage
                                   matchcode object mekk,
                 p_mittel like rm06i-psmit,    "Mittelwertangebot
                 p_mini   like rm06i-psmin,    "Minimalwertangebot
                 p_prozb  like rm06i-psprz,    "Prozentbasis
                 p_pscol like rm06i-pscol default 12. "Angebote/Seite
selection-screen end of block block1.
selection-screen begin of block block2 with frame title text-002.
parameters:
                 p_skonto like rm06i-pssko,    "Skonto mit einbeziehen
                 p_bezugs like rm06i-psbez,    "incl.Bezugsnebenkosten
                 p_effekt like rm06i-pseff,    "Effektivpreis
                 p_incdes as checkbox.         "Incluir descuentos
selection-screen end of block block2.

top-of-page.
  write: /152 'Página ', sy-pagno,'de ', '-----'.
  uline.

*----------------------------------------------------------------------*
start-of-selection.
*----------------------------------------------------------------------*
  perform seleccionar_datos.
  perform corregir_datos.
  if maxind > 0.
    perform desplegar_reporte.
  else.
    call function 'POPUP_TO_DISPLAY_TEXT'
      exporting
        titel     = 'A D V E R T E N C I A'
        textline1 = 'No existen datos para los parámetros proporcionados'.
  endif.

  write sy-pagno to l_page_count left-justified.
  do sy-pagno times.
    read line 1 of page sy-index.
    replace '-----' with l_page_count into sy-lisel.
    modify current line.
  enddo.

*----------------------------------------------------------------------*
end-of-selection.
*----------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  SELECCIONAR_DATOS
*&---------------------------------------------------------------------*
form seleccionar_datos .
  select * from ekko into table xekko
    where ebeln in p_ebeln
    and   bstyp eq 'A'
    and   lifnr in p_lifnr
    and   ekorg eq p_ekorg
    and   submi in p_submi
    order by primary key.
endform.                    " SELECCIONAR_DATOS

*&---------------------------------------------------------------------*
*&      Form  CORREGIR_DATOS
*&---------------------------------------------------------------------*
form corregir_datos .
  if sy-dbcnt gt 0.
    maxind = sy-dbcnt.
    if p_anfbas ne space.
      move sy-mandt to ekkokey-mandt.
      move p_anfbas to ekkokey-ebeln.
      read table xekko with key ekkokey binary search.
      case sy-subrc.
        when 0.                                             "ok
        when 4.
          move ekko to xekko. clear: xekko-wert, xekko-proze,
                                     xekko-rang.
          insert xekko index sy-tabix.
        when 8.
          move ekko to xekko. clear: xekko-wert, xekko-proze,
                                     xekko-rang.
          append xekko.
      endcase.
    endif.
    perform xangeb_setzen(sapfm06d) using 'X'.
    loop at xekko.
      helpind = sy-tabix.
      move xekko to ekko.
      perform berechtigungen_kopf(sapfm06d).
      if sy-subrc ne 0.
        xauth = 'X'.
        delete xekko.
      else.
        clear: xekko-wert, xekko-proze, xekko-rang.
        modify xekko index helpind.
      endif.
    endloop.
*---- Lesen Belegpositionen -------------------------------------------*
    perform pos_lesen_db.
*---- Initialisieren numerische Felder (sonst Werte 20202 etc.) -------*
    refresh packtab.
    loop at xekpo.
      clear: xekpo-lamng, xekpo-proze, xekpo-rang, xekpo-gruppe.
      modify xekpo.
    endloop.
*---- Berechtigungsprüfungen Pos---------------------------------------*
    loop at xekpo.
      move xekpo to ekpo.
      perform berechtigungen_pos(sapfm06d).
      if sy-subrc ne 0.
        xauth = 'X'.
        delete xekpo.
      else.
*......merken Dienstleistungspakete
        if not xekpo-packno is initial.
          packtab = xekpo-packno.
          append packtab.
        endif.
      endif.
    endloop.
*---- Köpfe ohne Positionen rauswerfen --------------------------------*
    loop at xekko.
      move xekko-mandt to ekkokey-mandt.
      move xekko-ebeln to ekkokey-ebeln.
      read table xekpo with key ekkokey.
      if sy-subrc ne 0.
        delete xekko.
      else.
        if ( sy-tabix = 1 ).
          old_spras = xekko-spras.
        elseif ( old_spras ne xekko-spras ).
          diff_language = 'X'.
        endif.
      endif.
    endloop.
  endif.
  describe table xekko lines maxind.
  describe table packtab lines sy-tfill.
  if sy-tfill ne 0.
    call function 'MS_READ_SERVICE_SPECS'
      tables
        packnotab        = packtab
        srvtab           = srvtab
      exceptions
        no_service_found = 01.
  endif.
endform.                    " CORREGIR_DATOS

*&---------------------------------------------------------------------*
*&      Form  POS_LESEN_DB
*&---------------------------------------------------------------------*
form pos_lesen_db .
  check not xekko[] is initial.
*--- Positionen nur lesen, wenn mindestens 1 Kopf da ------------------*
  select * from ekpo into table xekpo
     for all entries in xekko
     where ebeln eq xekko-ebeln
     and   matnr in p_matnr
     and   bstyp eq 'A'
     and   loekz eq space
     order by primary key.
endform.                    " POS_LESEN_DB

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_REPORTE
*&---------------------------------------------------------------------*
form desplegar_reporte.
  data : ind_top type i.
* SORT XEKPO BY EBELN MATNR.
  perform desplegar_encabezado.
  perform calcular_pasadas.
  describe table s_xekko lines ind_top.
  col_tot = ind_top.
  con_ind = 0.
  do can_pas times.
    refresh : xekpo, xekko.
    maxind = 0.
    con_ind = con_ind + 1.
    if con_ind = can_pas.
      p_mini   = sal_pmi.
      p_mittel = sal_pme.
    endif.
    do col_dis times.
      read table s_xekko index 1.
      move s_xekko to xekko.
      append xekko.
      loop at s_xekpo where ebeln = s_xekko-ebeln.
        move s_xekpo to xekpo.
        append xekpo.
        delete s_xekpo.
      endloop.
      delete s_xekko index 1.
      maxind = maxind + 1.
      ind_top = ind_top - 1.
      if ind_top = 0.
        exit.
      endif.
    enddo.
    perform desplegar_columnas.
    perform desplegar_cuadro.
    refresh total_oferta.
  enddo.
  perform desplegar_excepciones.
  perform desplegar_piedepagina.
  perform desplegar_firmas.
endform.                    " DESPLEGAR_REPORTE
*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_ENCABEZADO
*&---------------------------------------------------------------------*
form desplegar_encabezado .
  data : l_texto(100) type c,
         l_posi       type i.
  position 10.
  write 'CUADRO COMPARATIVO PARA MATERIALES'.
  read table xekpo index 1.
  select single name1 into l_texto from t001w where werks = xekpo-werks.
  read table xekko index 1.

  shift l_texto left deleting leading space.
  skip 1.
  l_posi = ( 170 - strlen( l_texto ) ) div 2.
  position l_posi.
  write l_texto.
  skip 1.
  l_texto = 'EVALUACION TECNICO-ECONOMICA Y DICTAMEN DE COTIZACIONES'.
  l_posi = ( 170 - strlen( l_texto ) ) div 2.
  position  l_posi.
  write l_texto.
  skip 1.
  position 10.
  write 'PROVEEDOR SELECCIONADO _____________________________________'.
  concatenate 'NO. SOLICITUD PEDIDO : '  xekpo-banfn into l_texto.
  position 80.
  write l_texto.
  position 130.
  write : 'NO. PED(S): ____________________________          FECHA DE IMPRESION ',sy-datum.
  skip 1.
  write 'POR:'.
  skip 1.
  position 1.
  write :'PRECIO      (  )          T. ENTREGA       (  )                               AREA SOLICITANTE:',xekpo-afnam.
  l_texto = 'Pendiente'.
  write :/ 'CON PAGO    (  )          ESPECIFICACIONES (  )                               CC Y/O PROYECTO:',l_texto.
  position 1.
  perform obtener_moneda_de_cotizacion.
  write :/ 'FABRICANTE  (  )          EMERGENCIA       (  )                               Cotización en moneda (',xekko-waers,xekko-wkurs,')'.
  write :/ 'LAB         (  )                                                              Número de licitación:',xekko-submi.
endform.                    " DESPLEGAR_ENCABEZADO

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_COLUMNAS
*&---------------------------------------------------------------------*
form desplegar_columnas .
  data : l_long type i,
       : l_indi type i.
  skip 1.
  pos_des = lon_col * 3.
  position pos_des.
  write sy-vline.
  lon_ray = maxind * lon_col - 1.
  pos_des = pos_des + 1.
  position pos_des.

  l_long = lon_dis.
  if lon_ray > l_long.
    lon_ray = l_long.
  endif.

  write sy-uline(lon_ray).
  pos_des = pos_des + lon_ray.
  position pos_des.
  write sy-vline.
  lon_ray = lon_col * 3.
  write / space.
  pos_des = lon_ray.
  do maxind times.
    l_indi = sy-index + con_col.
    position pos_des.
    write :   sy-vline,l_indi.
    pos_des = pos_des + lon_col.
  enddo.
  con_col = con_col + maxind.
  position pos_des.
  write : sy-vline.

  perform muestra_raya_grande.


endform.                    " DESPLEGAR_COLUMNAS

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_CUADRO
*&---------------------------------------------------------------------*
form desplegar_cuadro .
  perform desplegar_material.
  perform desplegar_textobreve.
  perform desplegar_cantidad.
  perform desplegar_nombre.
  perform desplegar_precioanterior.
  perform desplegar_condicionesdepago.
  perform desplegar_lugardeentrega.
  perform desplegar_tiempodeentrega.
  perform desplegar_fechadeentrega.
  perform desplegar_telefono.
  perform desplegar_fax.
  perform desplegar_materiales.
  perform desplegar_totales.
endform.                    " DESPLEGAR_CUADRO

*&---------------------------------------------------------------------*
*&      Form  COLOCA_RAYA
*&---------------------------------------------------------------------*
form coloca_raya .
  position pos_rve.
  write : sy-vline.
  if p_mini = 'X'.
    pos_rve = pos_rve + 1.
    position pos_rve.
    if swi_ini = 'S'.
      write '      MINIMO'.
      pos_rve = pos_rve - 1.
      if p_mittel = 'X'.
        pos_rve = pos_rve + lon_col.
        position pos_rve.
        write sy-vline.
      else.
        pos_rve = pos_rve + lon_col.
        position pos_rve.
        write sy-vline.
      endif.
    else.
      pos_rve = pos_rve + lon_col - 1.
      position pos_rve.
      write sy-vline.
      if p_mittel = 'X'.
        pos_rve = pos_rve + lon_col - 2.
      endif.
    endif.
  endif.
  if p_mittel = 'X'.
    if swi_ini = 'S'.
      pos_rve = pos_rve + 1.
      position pos_rve.
      write : '       MEDIO'.
      pos_rve = pos_rve + lon_col - 1.
      position pos_rve.
      write sy-vline.
    else.
      if p_mini = 'X'.
        pos_rve = pos_rve + 2.
      else.
        pos_rve = pos_rve + lon_col.
      endif.
      position pos_rve.
      write sy-vline.
    endif.
    pos_rve = pos_rve - 1.
  endif.
endform.                    " COLOCA_RAYA

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_MATERIAL
*&---------------------------------------------------------------------*
form desplegar_material .
  write :/ sy-vline,'Material'.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Fecha de cotización:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,'Ultima compra'.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    write :sy-vline,xekko-aedat.
    pos_rve = pos_rve + lon_col.
  endloop.

  swi_ini = 'S'.
  perform coloca_raya.
  swi_ini = 'N'.
endform.                    " DESPLEGAR_MATERIAL

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_TEXTOBREVE
*&---------------------------------------------------------------------*
form desplegar_textobreve .
  write :/ sy-vline,'Texto breve'.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Oferta:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    write :sy-vline,xekko-ebeln.
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_TEXTOBREVE
*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_CANTIDAD
*&---------------------------------------------------------------------*
form desplegar_cantidad .
  write :/ sy-vline,'Cantidad en um base'.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Licitante:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    write :sy-vline,xekko-lifnr.
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_CANTIDAD
*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_NOMBRE
*&---------------------------------------------------------------------*
form desplegar_nombre .
  data : l_nomb like lfa1-name1,
         l_long type i.

  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Nombre:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  lon_des = lon_col - 3.
  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    select single name1 into l_nomb from lfa1 where lifnr = xekko-lifnr.
    l_long = strlen( l_nomb ).
    if lon_des > l_long.
      lon_des = l_long.
    endif.
    write :sy-vline,l_nomb(lon_des).
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_NOMBRE

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_PRECIOANTERIOR
*&---------------------------------------------------------------------*
form desplegar_precioanterior .
  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  do maxind times.
    position pos_rve.
    write :sy-vline.
    pos_rve = pos_rve + lon_col.
  enddo.
  perform coloca_raya.
endform.                    " DESPLEGAR_PRECIOANTERIOR
*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_CONDICIONESDEPAGO
*&---------------------------------------------------------------------*
form desplegar_condicionesdepago .
  data l_conpag like t052u-text1.

  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Condiciones de pago:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  lon_des = lon_col - 3.
  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    select single text1 into l_conpag from t052u
           where spras = sy-langu
             and zterm = xekko-zterm
             and ztagg = '00'.
    write :sy-vline,l_conpag(lon_des).
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_CONDICIONESDEPAGO

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_LUGARDEENTREGA
*&---------------------------------------------------------------------*
form desplegar_lugardeentrega .
  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Lugar de entrega:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    write :sy-vline,xekko-inco2.
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_LUGARDEENTREGA

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_TIEMPODEENTREGA
*&---------------------------------------------------------------------*
form desplegar_tiempodeentrega .
  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Tiempo entrega(días):'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    read table xekpo with key ebeln = xekko-ebeln.
    write :sy-vline,xekpo-plifz.
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_TIEMPODEENTREGA

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_FECHADEENTREGA
*&---------------------------------------------------------------------*
form desplegar_fechadeentrega .
  data fec_ent type sy-datum.

  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Fecha de entrega:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    if xekko-submi+2(1) = '.'.
      fec_ent = xekko-submi.
    else.
      if xekko-submi co '0123456789'.
        unpack xekko-submi to xekko-submi.
      endif.
      select single lfdat into fec_ent
        from eban
       where banfn = xekko-submi.
    endif.
    write :sy-vline,fec_ent.
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_FECHADEENTREGA

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_TELEFONO
*&---------------------------------------------------------------------*
form desplegar_telefono.
  data l_telnum like t024-tel_number.

  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Teléfono:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.

  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    select single tel_number into l_telnum from t024 where ekgrp = xekko-ekgrp.
    write :sy-vline,l_telnum.
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.
endform.                    " DESPLEGAR_TELEFONO

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_FAX
*&---------------------------------------------------------------------*
form desplegar_fax .
  data l_faxnum like t024-telfx.
  write :/ sy-vline.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Fax:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write :sy-vline,''.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.
  pos_rve = lon_col * 3.
  loop at xekko.
    position pos_rve.
    select single telfx into l_faxnum from t024 where ekgrp = xekko-ekgrp.
    write :sy-vline,l_faxnum.
    pos_rve = pos_rve + lon_col.
  endloop.
  perform coloca_raya.

  perform muestra_raya_grande.

endform.                    " DESPLEGAR_FAX

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_MATERIALES
*&---------------------------------------------------------------------*
form desplegar_materiales .
* ATM01.BEGIN.INSERT
  data: begin of itab_ebelp occurs 0,
    ebelp like ekpo-ebelp,
  end of itab_ebelp.
* ATM01.END.INSERT
  refresh r_matnr.
  move : 'I'  to r_matnr-sign,
         'EQ' to r_matnr-option.
  swi_ent = 'N'.
  sum_ofe = 0.
  loop at xekpo.
*Inicia modificación Arturo Salcido Maese 03/Nov/09
    if xekpo-matnr in r_matnr and swi_ent = 'S'.
      continue.
    endif.
*Termina modificación Arturo Salcido Maese 03/Nov/09

    pco_min = 0.
    mon_min = 0.
    pco_med = 0.
    pco_max = 0.
*Inicia modificación Arturo Salcido Maese 31/Ago/09
    if xekpo-ebeln <> xekko-ebeln.
      read table xekko with key ebeln = xekpo-ebeln.
    endif.
*Termina modificación Arturo Salcido Maese 31/Ago/09

    swi_ent = 'S'.
    move sy-tabix to sal_ind.

    perform despliega_monto.
*
    perform acumula_oferta.
    perform despliega_monto_minimo.
    perform despliega_monto_medio.
    perform despliega_precio.
    perform despliega_precio_minimo.
    perform despliega_precio_medio.
    perform despliega_rango.
    perform despliega_rango_minimo.
    perform despliega_rango_medio.
    perform despliega_fechas.

    move xekpo-matnr to r_matnr-low.
    append r_matnr.
    read table xekpo index sal_ind.
  endloop.
endform.                    " DESPLEGAR_MATERIALES

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_TOTALES
*&---------------------------------------------------------------------*
form desplegar_totales .
  data : num_cic type i,
         cam_rve type i.

  pos_rve = 1.
  position pos_rve.
  write :/ sy-vline,'SUMA OFERTA'.

  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Monto:'.
  pos_rve = lon_col * 2.
  position pos_rve.
  write : sy-vline, (16) sum_ofe.
  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.
  loop at total_oferta.
    write (16) total_oferta-tot_ofe.
    pos_rve = lon_col * ( sy-tabix + 3 ).
    position pos_rve.
    write sy-vline.
  endloop.

  if p_mini = 'X'.
    num_cic = 1.
  endif.

  if p_mittel = 'X'.
    num_cic = num_cic + 1.
  endif.

  do num_cic times.
    cam_rve = pos_rve + 2.
    position cam_rve.
    if sy-index = 1.
      write acu_min.
    else.
      write acu_med.
    endif.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  enddo.

  pos_rve = 1.
  position pos_rve.
  write :/ sy-vline.

  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Rango:'.

  pos_rve = lon_col * 2.
  position pos_rve.
  write : sy-vline.

  perform calcula_minimo using val_min.

  pos_rve = lon_col * 3.
  position pos_rve.
  write :sy-vline.
  loop at total_oferta.
    total_oferta-tot_ofe = total_oferta-tot_ofe / val_min * 100.
    write : (16) total_oferta-tot_ofe,'%'.
    pos_rve = lon_col * ( sy-tabix + 3 ).
    position pos_rve.
    write sy-vline.
  endloop.

  do num_cic times.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  enddo.

  perform muestra_raya_grande.

endform.                    " DESPLEGAR_TOTALES

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_PIEDEPAGINA
*&---------------------------------------------------------------------*
form desplegar_piedepagina .
  skip.
  write / 'OBSERVACIONES:'.
  pos_rve = 1.
  position pos_rve.
  write : / sy-vline.

  lon_ray = lon_ray - 1.
  pos_rve = 2.
  position pos_rve.
  write : sy-uline(lon_ray).

  pos_rve = lon_ray + 1.
  position pos_rve.
  write : sy-vline.

  pos_rve = 1.
  position pos_rve.
  write : / sy-vline.

  pos_rve = lon_ray + 1.
  position pos_rve.
  write : sy-vline.

  do 2 times.
    pos_rve = 1.
    position pos_rve.
    write : / sy-vline.
    pos_rve = 2.
    position pos_rve.
    write : sy-uline(lon_ray).
    pos_rve = lon_ray + 1.
    position pos_rve.
    write : sy-vline.
  enddo.
endform.                    " DESPLEGAR_PIEDEPAGINA

*&---------------------------------------------------------------------*
*&      Form  CALCULA_MINIMO
form calcula_minimo using p_val_min.
  loop at total_oferta where tot_ofe <> 0.
    p_val_min  = total_oferta-tot_ofe.
    exit.
  endloop.
  loop at total_oferta where tot_ofe <> 0.
    if total_oferta-tot_ofe < p_val_min.
      p_val_min = total_oferta-tot_ofe.
    endif.
  endloop.
  if p_val_min = 0.
    p_val_min = 1.
  endif.
endform.                    " CALCULA_MINIMO

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_FIRMAS
*&---------------------------------------------------------------------*
form desplegar_firmas .
  data : l_nombre like zpedcom_firm-sign1.
  data : l_total like ekpo-netwr.
  data : l_comprador like t024-eknam.


  read table xekpo index 1.
  skip.
  position 80.
  write 'AUTORIZACIONES'.
  skip.
* ATM01.BEGIN.DELETE
*  WRITE / 'COMPRADOR                           GTE DE ADQUISICIONES                     SOLICITANTE                      GTE DE AREA                          GTE GRAL'.
*  SKIP.
*
*  SELECT SINGLE EKNAM INTO L_NOMBRE
*    FROM T024
*   WHERE EKGRP = XEKKO-EKGRP.
*
*  POSITION 1.
*  WRITE L_NOMBRE.
*
*  SELECT SINGLE SIGN1 INTO L_NOMBRE
*    FROM ZPEDCOM_FIRM
*   WHERE BUKRS = XEKKO-BUKRS
*     AND SIGID = 1
*     AND EKGRP = XEKKO-EKGRP.
*  POSITION 37.
*  WRITE L_NOMBRE.
*
*  POSITION 78.
*  WRITE XEKPO-AFNAM.
*
*  SELECT SINGLE SIGN1 INTO L_NOMBRE
*    FROM ZPEDCOM_FIRM
*   WHERE BUKRS = XEKKO-BUKRS
*     AND SIGID = 2
*     AND EKGRP = XEKKO-EKGRP.
*  POSITION 107.
*  WRITE L_NOMBRE.
*
*  SELECT SINGLE SIGN1 INTO L_NOMBRE
*    FROM ZPEDCOM_FIRM
*   WHERE BUKRS = XEKKO-BUKRS
*     AND SIGID = 3
*     AND EKGRP = XEKKO-EKGRP.
*
*  POSITION 147.
*  WRITE L_NOMBRE.
*
*  SKIP.
*  WRITE '    02F-053-A R01 SEP-2000 '.
* ATM01.END.DELETE

* ATM01.BEGIN.INSERT
  perform obtener_total using l_total.
  perform obtener_firmas1 using xekko xekpo.
  perform firmas_valor using xekpo-werks l_total.
* Nombre del comprador
  clear l_comprador.
  select single eknam into l_comprador
    from t024
  where ekgrp = xekko-ekgrp.
* Titulos de las firmas
  position 1.
  write 'COMPRADOR'.
  position 37.
  write wa_firma1-descripcion.
* ATM01.BEGIN.INSERT
  if wa_vf-fsol = 'X'.
    position 78.
    write 'SOLICITANTE'.
  endif.
* ATM01.END.INSERT

  position 107.
  write wa_firma2-descripcion.
  position 147.
  write wa_firma3-descripcion.

* Nombres de los que firman
  skip 2.
  position 1.
  write l_comprador.
  position 37.
  write wa_firma1-sign1.
* ATM01.BEGIN.INSERT
  if wa_vf-fsol = 'X'.
    position 78.
    write xekpo-afnam.
  endif.
* ATM01.END.INSERT
  position 107.
  write wa_firma2-sign1.
  position 147.
  write wa_firma3-sign1.

* ATM01.END.INSERT
endform.                    " DESPLEGAR_FIRMAS


* atm01.begin.insert

form obtener_firmas1 using
  i_ekko structure ekko
  i_ekpo structure ekpo.


  clear : wa_firma1 , wa_firma2 , wa_firma3.
  perform obtener_firmas_aux using
    '01' i_ekpo-werks i_ekko-ekgrp i_ekpo-afnam wa_firma1.
  perform obtener_firmas_aux using
    '02' i_ekpo-werks i_ekko-ekgrp i_ekpo-afnam wa_firma2.
  perform obtener_firmas_aux using
    '03' i_ekpo-werks i_ekko-ekgrp i_ekpo-afnam wa_firma3.

endform.                    "obtener_firmas1

*&---------------------------------------------------------------------*
*&      Form  OBTENER_TOTAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->O_TOTAL    text
*----------------------------------------------------------------------*
* OBTIENE EL MAYOR TOTAL.
form obtener_total using o_total.
  data : begin of itab_total occurs 0,
    ebeln like ekpo-ebeln,
    netwr like ekpo-netwr,
  end of itab_total.
  data : l_wkurs like ekko-wkurs.
  data : l_netwr like ekpo-netwr.
  data : l_factor type f.

  clear o_total.
  loop at xekpo.
    at new ebeln.
      clear l_netwr.
*     Obtener el tipo de cambio del pedido
      l_wkurs = 1.
      l_factor = 1.
      select single wkurs into l_wkurs
      from ekko
      where ebeln = xekpo-ebeln.
      l_factor = l_wkurs .
    endat.

    if xekpo-loekz = ' '.

      l_netwr = l_netwr + ( xekpo-brtwr * l_factor ).

    endif.

    at end of ebeln.
      itab_total-ebeln = xekpo-ebeln.
      itab_total-netwr = l_netwr.
      append itab_total.
    endat.

  endloop.
  sort itab_total by netwr descending.
  loop at itab_total.
    o_total = itab_total-netwr.
    exit.
  endloop.

endform.                    "OBTENER_TOTAL
*&---------------------------------------------------------------------*
*&      Form  firmas_valor
*&---------------------------------------------------------------------*
*      -->I_WERKS
*      -->I_TOTAL
*----------------------------------------------------------------------*
form firmas_valor using i_werks
  i_total.

  data : l_total like zmm_vf-vf1.


  l_total = i_total.

  clear wa_vf.
  select single *
  from zmm_vf
  into wa_vf
  where werks = i_werks
    and bstyp = 'A'.

  if l_total >= wa_vf-vf3.
  else.
    if l_total < wa_vf-vf3.
      clear : wa_firma3.
    endif.
    if l_total < wa_vf-vf2.
      clear : wa_firma2 , wa_firma3.
    endif.
    if l_total < wa_vf-vf1.
      clear : wa_firma1, wa_firma2 , wa_firma3.
    endif.
  endif.


endform.                    "firmas_ss

*------------------------------------------------------------
*
*------------------------------------------------------------
form obtener_firmas_aux using i_tipo i_werks i_ekgrp i_afnam
  o_firmas structure zeban_firmas.

  data : begin of ltab_firmas occurs 0.
          include structure zeban_firmas.
  data : end of ltab_firmas.

  clear o_firmas.
* Buscar por centro , grupo de compras , area solicitante
  select single * from zeban_firmas
  into  o_firmas
  where werks = i_werks
    and ekgrp = i_ekgrp
    and afnam = i_afnam
    and id_firmas = i_tipo
    and bstyp = 'A'.
  if sy-subrc = 0.
    exit.
  endif.
* buscar por centro , grupo de compras ,
  select single * from zeban_firmas
  into  o_firmas
  where werks = i_werks
    and ekgrp = i_ekgrp
    and afnam = space
    and id_firmas = i_tipo
    and bstyp = 'A'.
  if sy-subrc = 0.
    exit.
  endif.
* buscar por centro , area solicitante ,
  select single * from zeban_firmas
  into  o_firmas
  where werks = i_werks
    and ekgrp = space
    and afnam = i_afnam
    and id_firmas = i_tipo
    and bstyp = 'A'.
  if sy-subrc = 0.
    exit.
  endif.
* buscar por centro
  select single * from zeban_firmas
  into  o_firmas
  where werks = i_werks
    and ekgrp = space
    and afnam = space
    and id_firmas = i_tipo
    and bstyp = 'A'.
endform.                    "obtener_firmas_aux

* atm01.end.insert


*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_MONTO_MINIMO
*&---------------------------------------------------------------------*
form despliega_monto_minimo .
  if p_mini = 'X'.
    position pos_rve.
    write : sy-vline,mon_min.
    acu_min = acu_min + mon_min.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  endif.
endform.                    " DESPLIEGA_MONTO_MINIMO

*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_MONTO_MEDIO
*&---------------------------------------------------------------------*
form despliega_monto_medio.
  if p_mittel = 'X'.
    mon_med = mon_med / col_tot.
    position pos_rve.
    write : sy-vline,mon_med.
    acu_med = acu_med + mon_med.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  endif.
endform.                    " DESPLIEGA_MONTO_MEDIO

*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_MONTO
*&---------------------------------------------------------------------*
form despliega_monto .
  pos_rve = 1.
  position pos_rve.
  write :/ sy-vline,xekpo-matnr.
  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Monto:'.
  pos_rve = lon_col * 2.
  position pos_rve.
*Inicia modificación Arturo Salcido Maese 03/Nov/09
  perform busca_ultima_compra using g_resco g_monto g_preci g_docto g_fech1 g_fech2 .
  if g_resco = 'S'.
    write : sy-vline,g_monto.
  else.
    write : sy-vline.
  endif.
*Termina modificación Arturo Salcido Maese 03/Nov/09
endform.                    " DESPLIEGA_MONTO

*&---------------------------------------------------------------------*
*&      Form  ACUMULA_OFERTA
*&---------------------------------------------------------------------*
form acumula_oferta .
* atm01.begin.insert
  data : l_ebelp like ekpo-ebelp.

* atm01.end.insert
  data con_cic type i.
*Inicia modificación Arturo Salcido Maese 03/Nov/09
  if g_resco = 'S'.
    sum_ofe = sum_ofe + g_monto.
  endif.
*Termina modificación Arturo Salcido Maese 03/Nov/09
  pos_rve = lon_col * 3.
  sal_mat = xekpo-matnr.
*  atm01.delete.line
*  Loop At XEKPO Where MATNR = SAL_MAT.
*  atm01.insert.line
  l_ebelp = xekpo-ebelp.

  loop at xekpo where ebelp = l_ebelp.

    position pos_rve.

*Inicia modificación Arturo Salcido Maese 31/Ago/09
    if xekpo-ebeln <> xekko-ebeln.
      read table xekko with key ebeln = xekpo-ebeln.
    endif.
*   L_MONTO = XEKPO-KTMNG * XEKPO-NETPR.

*    IF G_CONVT = 'S'.
*      XEKPO-NETPR = XEKPO-NETPR / XEKKO-WKURS.
*    ENDIF.
*Inicia anexo Arturo Salcido Maese 04/Oct/09
    if  p_incdes = 'X'.
      case xekpo-mwskz.
        when ''.
          xekpo-netpr = xekpo-netpr * xekko-wkurs.
          modify xekpo.
        when 'W1'.
          xekpo-netpr = xekpo-netpr * xekko-wkurs * '1.10'.
          modify xekpo.
        when 'W2'.
          xekpo-netpr = xekpo-netpr * xekko-wkurs * '1.15'.
          modify xekpo.
        when 'W3'.
          xekpo-netpr = xekpo-netpr * xekko-wkurs * '1.15'.
          modify xekpo.
      endcase.
    endif.
*Termina anexo Arturo Salcido Maese 04/Oct/09
*    IF G_CONVT = 'S'.
*     L_MONTO = XEKPO-KTMNG * XEKPO-NETPR / XEKKO-WKURS.
*    ELSE.
    l_monto = xekpo-ktmng * xekpo-netpr.
*    ENDIF.
*Termina modificación Arturo Salcido Maese 31/Ago/09
    write : sy-vline,l_monto.
    pos_rve = pos_rve + lon_col.
    if mon_min = 0 or l_monto < mon_min.
      mon_min = l_monto.
    endif.
    mon_med = mon_med + l_monto.
    total_oferta-ebeln   = xekpo-ebeln.
    total_oferta-tot_ofe = l_monto.
    collect total_oferta.
    con_cic = con_cic + 1.
  endloop.

  con_cic = maxind - con_cic.
  do con_cic times.
    position pos_rve.
    write : sy-vline.
    pos_rve = pos_rve + lon_col.
  enddo.
  position pos_rve.
  write : sy-vline.
endform.                    " ACUMULA_OFERTA
*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_PRECIO
*&---------------------------------------------------------------------*
form despliega_precio .
* atm01.begin.insert
  data : l_ebelp like ekpo-ebelp.

  data con_cic type i.
  pos_rve = 1.
  position pos_rve.
  write :/ sy-vline.

  pos_rve = 2.
  position pos_rve.
  write : xekpo-txz01(lon_des).

  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Precio:'.
  pos_rve = lon_col * 2.
  position pos_rve.
*Inicia modificación Arturo Salcido Maese 03/Nov/09
  if g_resco = 'S'.
    write : sy-vline,g_preci.
  else.
    write : sy-vline.
  endif.
  pos_rve = lon_col * 3.
  sal_mat = xekpo-matnr.
*  atm01.delete.line
*  Loop At XEKPO Where MATNR = SAL_MAT.
*  atm01.insert.line
  l_ebelp = xekpo-ebelp.

  loop at xekpo where ebelp = l_ebelp.
*Inicia modificación Arturo Salcido Maese 31/Ago/09
    if xekpo-ebeln <> xekko-ebeln.
      read table xekko with key ebeln = xekpo-ebeln.
    endif.
*Termina modificación Arturo Salcido Maese 31/Ago/09

    position pos_rve.
*Inicia modificación Arturo Salcido Maese 28/Ago/09
*    WRITE : Sy-Vline,' ',XEKPO-NETPR.
    l_monto = xekpo-netpr. " * XEKKO-WKURS.
    write : sy-vline,' ', l_monto.
*Termina modificación Arturo Salcido Maese 28/Ago/09
    pos_rve = pos_rve + lon_col.
    if l_monto < pco_min or pco_min = 0.
      pco_min = l_monto.
    endif.
    if l_monto > pco_max or pco_max = 0.
      pco_max = l_monto.
    endif.
    pco_med = pco_med + l_monto.
    con_cic = con_cic + 1.
  endloop.
  pco_med = pco_med / col_tot.
  con_cic = maxind - con_cic.
  do con_cic times.
    position pos_rve.
    write : sy-vline.
    pos_rve = pos_rve + lon_col.
  enddo.

  position pos_rve.
  write : sy-vline.
endform.                    " DESPLIEGA_PRECIO

*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_PRECIO_MINIMO
*&---------------------------------------------------------------------*
form despliega_precio_minimo .
  if p_mini = 'X'.
    position pos_rve.
    write : sy-vline,pco_min.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  endif.
endform.                    " DESPLIEGA_PRECIO_MINIMO

*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_PRECIO_MEDIO
*&---------------------------------------------------------------------*
form despliega_precio_medio .
  if p_mittel = 'X'.
    position pos_rve.
*   Pco_Med = Pco_Med / Col_Tot.
    write : sy-vline,pco_med.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  endif.
endform.                    " DESPLIEGA_PRECIO_MEDIO


*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_RANGO
*&---------------------------------------------------------------------*
form despliega_rango .
* ATM01.INSERT.LINE
  data : l_ebelp like ekpo-ebelp,
         l_pje   type i.

  data con_cic type i.
  pos_rve = 1.
  position pos_rve.
  write :/ sy-vline.

  pos_rve = 2.
  position pos_rve.
  write : xekpo-ktmng.

  pos_rve = 19.
  position pos_rve.
  write : xekpo-meins.

  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline,'Rango:'.
  pos_rve = lon_col * 2.
  position pos_rve.
*Inicia modificación Arturo Salcido Maese 03/Nov/09
  if g_resco = 'S'.
    write : sy-vline,g_docto.
  else.
    write : sy-vline.
  endif.
*Termina modificación Arturo Salcido Maese 03/Nov/09

  pos_rve = lon_col * 3.
  sal_mat = xekpo-matnr.
* ATM01.DELETE.LINE.
*    Loop At XEKPO Where MATNR = SAL_MAT.
* ATM01.BEGIN.INSERT
  l_ebelp = xekpo-ebelp.
  loop at xekpo where ebelp = l_ebelp.
* ATM01.END.INSERT

*Inicia modificación Arturo Salcido Maese 08/Sep/09
    if xekpo-ebeln <> xekko-ebeln.
      read table xekko with key ebeln = xekpo-ebeln.
    endif.
*Termina modificación Arturo Salcido Maese 08/Sep/09
    case p_prozb.
      when ''.
        l_pje = xekpo-netpr / pco_med * 100.
      when '-'.
        l_pje = xekpo-netpr / pco_min * 100.
      when '+'.
        l_pje = xekpo-netpr / pco_max * 100.
    endcase.
    position pos_rve.
    write : sy-vline,l_pje,'%'.
    pos_rve = pos_rve + lon_col.
    con_cic = con_cic + 1.
  endloop.
  con_cic = maxind - con_cic.
  do con_cic times.
    position pos_rve.
    write : sy-vline.
    pos_rve = pos_rve + lon_col.
  enddo.

  position pos_rve.
  write : sy-vline.
endform.                    " DESPLIEGA_RANGO

*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_RANGO_MINIMO
*&---------------------------------------------------------------------*
form despliega_rango_minimo .
  if p_mini = 'X'.
    position pos_rve.
    write : sy-vline,100,'%'.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  endif.
endform.                    " DESPLIEGA_RANGO_MINIMO

*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_FECHAS
*&---------------------------------------------------------------------*
form despliega_fechas .
  data num_cic type i.
  pos_rve = 1.
  position pos_rve.
  write / sy-vline.

  pos_rve = lon_col.
  position pos_rve.
  write : sy-vline.

  pos_rve = lon_col * 2.
  position pos_rve.
*Inicia modificación Arturo Salcido Maese 03/Nov/09
  if g_resco = 'S'.
   write :  sy-vline,g_fech1.
  else.
    write :  sy-vline.
  endif.
*Termina modificación Arturo Salcido Maese 03/Nov/09  DO Num_Cic TIMES.

  num_cic = maxind + 1.

  if p_mini = 'X'.
    num_cic = num_cic + 1.
  endif.

  if p_mittel = 'X'.
    num_cic = num_cic + 1.
  endif.

  do num_cic times.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  enddo.

  pos_rve = 1.
  position pos_rve.
  write :/ sy-vline.

  pos_rve = lon_col.
  position pos_rve.
  write  sy-vline.

  pos_rve = lon_col * 2.
  position pos_rve.
*Inicia modificación Arturo Salcido Maese 03/Nov/09
  if g_resco = 'S'.
    write :  sy-vline,g_fech2.
  else.
    write :  sy-vline.
  endif.
*Termina modificación Arturo Salcido Maese 03/Nov/09  DO Num_Cic TIMES.
  do num_cic times.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  enddo.

  perform muestra_raya_grande.

endform.                    " DESPLIEGA_FECHAS

*&---------------------------------------------------------------------*
*&      Form  DESPLIEGA_RANGO_MEDIO
*&---------------------------------------------------------------------*
form despliega_rango_medio .
  if p_mittel = 'X'.
    position pos_rve.
    write : sy-vline,100,'%'.
    pos_rve = pos_rve + lon_col.
    position pos_rve.
    write sy-vline.
  endif.
endform.                    " DESPLIEGA_RANGO_MEDIO

*&---------------------------------------------------------------------*
*&      Form  CALCULAR_PASADAS
*&---------------------------------------------------------------------*
form calcular_pasadas .
  col_nec = maxind.
  if p_mini = 'X'.
    col_nec = col_nec + 1.
  endif.
  if p_mittel = 'X'.
    col_nec = col_nec + 1.
  endif.

  sal_pmi = p_mini.
  sal_pme = p_mittel.

  clear : p_mittel, p_mini.

  col_dis = lon_dis div lon_col.
  do.
    can_pas = can_pas + 1.
    col_nec = col_nec - col_dis.
    if col_nec <= 0.
      exit.
    endif.
  enddo.
  col_dis = maxind  div can_pas.

  col_dis = 5.

  maxind = col_dis.
  s_xekpo[] = xekpo[].
  s_xekko[] = xekko[].
endform.                    " CALCULAR_PASADAS

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_EXCEPCIONES
*&---------------------------------------------------------------------*
form desplegar_excepciones.
  data : t_excep type standard table of t_datos with header line.   "Tabla local de excepciones
  data : l_lineas type i,
         swi_ent type c value 'S'.

  loop at xekko.
    loop at xekpo where ebeln = xekko-ebeln and matnr <> ''.

      if swi_ent = 'S'.
        t_excep-matnr = xekpo-matnr.
        t_excep-ebeln = xekko-ebeln.
        t_excep-ktmng = xekpo-ktmng.
        append t_excep.
      else.
        read table t_excep with key matnr = xekpo-matnr.
        if t_excep-ktmng <> xekpo-ktmng.
          tab_exc-matnr = xekpo-matnr.
          tab_exc-ebeln = xekko-ebeln.
          tab_exc-ktmng = xekpo-ktmng.
          append tab_exc.
        endif.
      endif.
    endloop.
    swi_ent = 'N'.
  endloop.


  t_excep[] = tab_exc[].
  loop at t_excep.
    swi_ent = 'S'.
    loop at xekpo where matnr = t_excep-matnr and ebeln <> t_excep-ebeln.
      if t_excep-ktmng <> xekpo-ktmng.
        tab_exc-matnr = ''.
        if swi_ent = 'S'.
          tab_exc-matnr = xekpo-matnr.
          swi_ent = 'N'.
        endif.
        tab_exc-ebeln = xekpo-ebeln.
        append tab_exc.
      endif.
    endloop.
  endloop.

  describe table tab_exc lines l_lineas.
  if l_lineas > 0.
    data men_exc(42) type c value 'No existe ninguna posición oferta adecuada'.
    skip.
    write :/ 'Log de excepciones'.
    write :/ sy-uline(80).
    write :/ sy-vline,'Material          ',sy-vline,'Oferta    ',sy-vline,'Tipo de excepción                         ',sy-vline.
    write :/ sy-uline(80).
    loop at tab_exc.
      write :/ sy-vline,tab_exc-matnr,sy-vline,tab_exc-ebeln,sy-vline,men_exc,sy-vline.
    endloop.
    write :/ sy-uline(80).
  endif.
endform.                    " DESPLEGAR_EXCEPCIONES

*&---------------------------------------------------------------------*
*&      Form  MUESTRA_RAYA_GRANDE
*&---------------------------------------------------------------------*
form muestra_raya_grande.

  data swi_con type i value 0.

  lon_ray = maxind * lon_col + lon_col * 3.
  if p_mini = 'X'.
    lon_ray = lon_ray + lon_col.
  endif.
  if p_mittel = 'X'.
    lon_ray = lon_ray + lon_col.
  endif.

  pos_des = 1.
  do.
    if lon_ray <= 255.
      position pos_des.
      if swi_con = 0.
        write :/ sy-uline(lon_ray).
      else.
        write : sy-uline(lon_ray).
      endif.
      exit.
    else.
      swi_con = 1.
      write :/ sy-uline(254).
      pos_des = pos_des + 254.
      lon_ray = lon_ray - 254.
    endif.
  enddo.
endform.                    " MUESTRA_RAYA_GRANDE

*&---------------------------------------------------------------------*
*&      Form  OBTENER_MONEDA_DE_COTIZACIÓN
*&---------------------------------------------------------------------*
form obtener_moneda_de_cotizacion .
  data : conmxp type i value 0,
         conext type i value 0.
  loop at xekko.
    if xekko-waers = 'MXP'.
      conmxp = conmxp + 1.
      exit.
    else.
      conext = conext + 1.
    endif.
  endloop.
  if conmxp = 0.
    g_convt = 'S'.
  else.
    g_convt = 'N'.
    xekko-waers = 'MXP'.
    xekko-wkurs = 1.
  endif.
endform.                    " OBTENER_MONEDA_DE_COTIZACIÓN

*&---------------------------------------------------------------------*
*&      Form  BUSCA_ULTIMA_COMPRA
*&---------------------------------------------------------------------*
form busca_ultima_compra using p_resco p_monto p_preci p_docto p_fech1 p_fech2.
  data : begin of tab_ekpo occurs 0,
          ebeln like ekpo-ebeln,
          aedat like ekpo-aedat,
          menge like ekpo-menge,
          netpr like ekpo-netpr,
          prdat like ekpo-prdat,
        end of tab_ekpo.
  data : l_lineas type i,
         l_netpr like ekpo-netpr,
         l_fecha type datum.

  select * into corresponding fields of table tab_ekpo
    from ekpo
   where matnr = xekpo-matnr
     and bukrs = xekpo-bukrs
     and werks = xekpo-werks
     and bstyp = 'F'.
  sort tab_ekpo by aedat descending.
  describe table tab_ekpo lines l_lineas.
  if l_lineas = 0.
    p_resco = 'N'.
  else.
    p_resco = 'S'.
    if l_lineas = 1.
      read table tab_ekpo index 1.
      l_netpr = tab_ekpo-netpr.
    else.
      read table tab_ekpo index 1.
      l_netpr = tab_ekpo-netpr.
      l_fecha = tab_ekpo-aedat.
      loop at tab_ekpo.
       if sy-tabix = 1.
        continue.
       endif.
       if tab_ekpo-aedat <> l_fecha.
        sy-tabix = sy-tabix - 1.
        read table tab_ekpo index sy-tabix.
        exit.
       endif.
       if tab_ekpo-netpr < l_netpr.
        l_netpr = tab_ekpo-netpr.
       endif.
      endloop.
    endif.
    p_preci = l_netpr.
    p_monto = l_netpr * tab_ekpo-menge.
    p_docto = tab_ekpo-ebeln.
    p_fech1 = tab_ekpo-aedat.
    p_fech2 = tab_ekpo-prdat.
  endif.
endform.                    " BUSCA_ULTIMA_COMPRA
