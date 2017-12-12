report  zmm_reporte_textos.
************************************************************************
* Autor.......: Iespino

* Descripción.: Reporte de textos largos
************************************************************************
* Modificación: <Autor>
* Fecha.......: < >
* Motivo......: < >
* Consecutivo.: <#001>
************************************************************************
tables: mard,
        mara,
        mbew,
        s034,
        mseg.

*-* TYPES
type-pools: icon.
type-pools: slis.

*---------------------------------------------------------------------*
*                     ALV DATA
*---------------------------------------------------------------------*
data:   g_fieldcat_hdr    type slis_fieldcat_alv,
        g_fieldcat        type slis_t_fieldcat_alv,
        g_layout          type slis_layout_alv,
        g_variant_x       like disvariant,
        g_sort_hdr        type slis_sortinfo_alv,
        g_sort            type slis_t_sortinfo_alv,
        gi_fieldcat       type slis_t_fieldcat_alv,
        gv_repid          like sy-repid,
        gv_inclname       like sy-repid,
        is_print          type slis_print_alv,
        is_reprep_id      type slis_reprep_id,
        it_event_exit     type slis_t_event_exit,
        gi_event          type slis_t_event,
*        g_events          TYPE slis_t_event,
*        g_events_hdr      TYPE slis_alv_event,
        is_sel_hide       type slis_sel_hide_alv,
        it_filter         type slis_t_filter_alv,
        it_excluding      type slis_t_extab,
        it_fieldcat       type slis_t_fieldcat_alv,
        it_events         type slis_t_event,
        it_special_groups type slis_t_sp_group_alv,
        g_repid                like sy-repid.
*----------------------------------------------------------*


types : begin of t_salt,
         werks  like mard-werks,   "Centro
         lgort  like mard-lgort,   "Almacén
         lgpbe  like mard-lgpbe,   "Ubicación
         matnr  like mara-matnr,   "Material
         maktx  like makt-maktx,   "Texto corto del material
         makty(255) type c,        "Texto largo del material
         meins  type meins,        "Unidad de medida base
         mtart  like mara-mtart,   "Tipo de material
         matkl  like mara-matkl,   "Grupo de artículos
         verpr  like mbew-verpr,   "Precio medio variable
         labst  like mard-labst,   "Existencia
         extwg  like mara-extwg,   "Criticidad
         wgbez  like t023t-wgbez,  "Denom.Grpo.Art
         mfrgr  like marc-mfrgr,   "Grupo porte del material ABC IER
        end of t_salt.

data : t_sal type standard table of t_salt with header line,
       t_tra type standard table of t_salt with header line.


data : t_text like tline occurs 10 with header line,
       nombre like thead-tdname.

data : g_numlin type i,
       g_vbeln  like vbfa-vbeln,
       g_erdat  like vbfa-erdat.


selection-screen begin of block block1 with frame title text-001.
select-options:
                 s_werks for mseg-werks,    "Centro
                 s_lgort for mard-lgort,    "Almacén
                 s_lgpbe for mard-lgpbe,    "Ubicación
                 s_matnr for mara-matnr,    "Clave de material
                 s_mtart for mara-mtart,    "Tipo de material
                 s_matkl for mara-matkl,    "Grupo de artículos
                 s_verpr for mbew-verpr,    "Precio medio variable
                 s_labst for mard-labst.    "Existencia
parameters       p_maktx like makt-maktx.   "Descripción
selection-screen end of block block1.


selection-screen begin of block block2 with frame title text-002.
parameters: p_vari type disvariant-variant.
selection-screen end of block block2.


at selection-screen on value-request for p_vari.
  perform f_variante_alv.

*----------------------------------------------------------------------*
start-of-selection.
*----------------------------------------------------------------------*
  perform seleccionar_datos.
  if g_numlin > 0.
    perform calcula_valores.
    perform desplegar_reporte.
  else.
    call function 'POPUP_TO_DISPLAY_TEXT'
      exporting
        titel     = 'A D V E R T E N C I A'
        textline1 = 'No existen datos para los parámetros proporcionados'.
  endif.

*----------------------------------------------------------------------*
end-of-selection.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SELECCIONAR_DATOS
*&---------------------------------------------------------------------*
form seleccionar_datos .
  data swi_mod type c.


  select * into corresponding fields of table t_sal
    from mard
   where matnr in s_matnr
     and werks in s_werks
     and lgort in s_lgort
     and lgpbe in s_lgpbe
     and labst in s_labst.

 loop at t_sal.
    select single mtart matkl extwg meins into (t_sal-mtart, t_sal-matkl, t_sal-extwg, t_sal-meins)
      from mara
     where matnr = t_sal-matnr
       and mtart in s_mtart
       and matkl in s_matkl.

     "IESPINO 26.09.2017
     select single mfrgr into t_sal-mfrgr
       from marc
       where werks in s_werks
       and matnr = t_sal-matnr.

      select single wgbez into (t_sal-wgbez)
      from t023t
       where matkl = t_sal-matkl.

    if sy-subrc = 0.
      modify t_sal.
    else.
      delete t_sal.
    endif.



        endloop.

  describe table t_sal lines g_numlin.
endform.                    " SELECCIONAR_DATOS

*&---------------------------------------------------------------------*
*&      Form  CALCULA_VALORES
*&---------------------------------------------------------------------*
form calcula_valores .
  data l_texto(50) type c.
  translate p_maktx to upper case.
  move p_maktx to l_texto.
  replace '*' with '' into l_texto.
  condense l_texto no-gaps.
"  CONCATENATE '%' L_TEXTO '%' INTO L_TEXTO. **MVG-06mar2013 no necesito esto para hacer la busqueda con el operando CS

  loop at t_sal.

    select single maktx into t_sal-maktx
      from makt
     where matnr = t_sal-matnr
       and spras = 'S'.
"       AND MAKTX LIKE L_TEXTO. **MVG-06mar2013 para realizar búsqueda de l_texto en texto largo y no en desc corta

    if sy-subrc <> 0.
      delete t_sal.
      continue.
    endif.

    if not s_labst is initial.
      if not t_sal-labst in s_labst.
        delete t_sal.
        continue.
      endif.
    endif.

    select single verpr into t_sal-verpr
      from mbew
     where matnr = t_sal-matnr
       and bwkey = t_sal-werks.

    if not s_verpr is initial.
      if not t_sal-verpr in s_verpr.
        delete t_sal.
        continue.
      endif.
    endif.

    nombre = t_sal-matnr.
    call function 'READ_TEXT'
      exporting
        id                      = 'BEST'
        language                = 'S'
        name                    = nombre
        object                  = 'MATERIAL'
      tables
        lines                   = t_text
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc = 0.
      loop at t_text.
        concatenate t_sal-makty t_text-tdline into t_sal-makty.
      endloop.
    endif.
**********************Rutina añadida para buscar el palabra clave en el texto largo****************************
    if not t_sal-makty cs l_texto.
      delete t_sal.
      continue.
    endif.
******************************MVG-06mar2013***********************************



    call function 'CONVERSION_EXIT_CUNIT_OUTPUT'
      exporting
        input                = t_sal-meins
        language             = sy-langu
      importing
*       LONG_TEXT            =
        output               = t_sal-meins.
*       SHORT_TEXT           =
*     EXCEPTIONS
*       UNIT_NOT_FOUND       = 1
*       OTHERS               = 2
    .
    if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    endif.


    modify t_sal.
  endloop.

endform.                    " CALCULA_VALORES

*&---------------------------------------------------------------------*
*&      Form  DESPLEGAR_REPORTE
*&---------------------------------------------------------------------*
form desplegar_reporte .

  perform genera_catalogo.

  call function 'REUSE_ALV_GRID_DISPLAY'
       exporting
*            i_background_id       = 'ALV_BACKGROUND'
            i_callback_program    = sy-repid
            i_structure_name      = 'T_SAL'
*            is_layout             = g_layout
            it_fieldcat           = g_fieldcat
*            it_excluding          = it_excluding
*            it_special_groups     = it_special_groups
*            it_sort               = g_sort
*            it_filter             = it_filter
*            is_sel_hide           = is_sel_hide
            i_default             = 'X'
             i_save                = 'A'
             is_variant            = g_variant_x
*            it_events             = gi_event
*            it_event_exit         = it_event_exit
*            is_print              = is_print
*            is_reprep_id          = is_reprep_id
*            i_screen_start_column = 0
*            i_screen_start_line   = 0
*            i_screen_end_column   = 0
*            i_screen_end_line     = 0
       tables
            t_outtab              = t_sal
       exceptions
            program_error         = 1
            others                = 2.

endform.                    " DESPLEGAR_REPORTE

*&---------------------------------------------------------------------*
*&      Form  GENERA_CATALOGO.
*&---------------------------------------------------------------------*
form genera_catalogo.
  refresh g_fieldcat.

  clear: g_fieldcat_hdr.
  g_fieldcat_hdr-fieldname    = 'WERKS'.
  g_fieldcat_hdr-tabname      = 'MARD'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  6.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Centro'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'LGORT'.
  g_fieldcat_hdr-tabname      = 'MARD'.
  g_fieldcat_hdr-just         = 'R'.
  g_fieldcat_hdr-outputlen    =  4.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Almacén'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'LGPBE'.
  g_fieldcat_hdr-tabname      = 'MARD'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  10.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Ubicación'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'MATNR'.
  g_fieldcat_hdr-tabname      = 'MARA'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  10.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Material'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'MAKTX'.
  g_fieldcat_hdr-tabname      = 'MAKT'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  40.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Descripción corta'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'MAKTY'.
  g_fieldcat_hdr-tabname      = 'T_SAL'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  180.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Descripción larga'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'MEINS'.
  g_fieldcat_hdr-tabname      = 'T_SAL'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  4.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'U De Me'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'MTART'.
  g_fieldcat_hdr-tabname      = 'MARA'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  10.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Tipo de material'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'MATKL'.
  g_fieldcat_hdr-tabname      = 'MARA'.
  g_fieldcat_hdr-just         = 'L'.
  g_fieldcat_hdr-outputlen    =  10.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Grupo de material'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'VERPR'.
  g_fieldcat_hdr-tabname      = 'MBEW'.
  g_fieldcat_hdr-just         = 'R'.
  g_fieldcat_hdr-outputlen    =  12.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Precio medio variable'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'LABST'.
  g_fieldcat_hdr-tabname      = 'MARD'.
  g_fieldcat_hdr-just         = 'R'.
  g_fieldcat_hdr-outputlen    =  12.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Existencia'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.


g_fieldcat_hdr-fieldname    = 'EXTWG'.
  g_fieldcat_hdr-tabname      = 'MARD'.
  g_fieldcat_hdr-just         = 'R'.
  g_fieldcat_hdr-outputlen    =  9.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Criticidad'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

 g_fieldcat_hdr-fieldname    = 'WGBEZ'.
  g_fieldcat_hdr-tabname      = 'T023T'.
  g_fieldcat_hdr-just         = 'R'.
  g_fieldcat_hdr-outputlen    =  20.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Denom.Grpo.Art'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.

  g_fieldcat_hdr-fieldname    = 'MFRGR'.
  g_fieldcat_hdr-tabname      = 'MARA'.
  g_fieldcat_hdr-just         = 'R'.
  g_fieldcat_hdr-outputlen    =  20.
  g_fieldcat_hdr-do_sum       = ''.
  g_fieldcat_hdr-seltext_l    = 'Indicador ABC'.
  append g_fieldcat_hdr to g_fieldcat.
  clear: g_fieldcat_hdr.


endform.                    " GENERA_CATALOGO

*&---------------------------------------------------------------------*
*&      Form  f_variante_alv
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form f_variante_alv .
* --- Utiliza el manejo de Variantes de reporte tipo ALV
  data: rs_variant type disvariant.
  rs_variant-report   = sy-repid.
  rs_variant-username = sy-uname.
  call function 'REUSE_ALV_VARIANT_F4'
    exporting
      is_variant         = rs_variant
      i_save             = 'U' " Solo trae variantes del usuario
      i_display_via_grid = 'X' " Muestra el tipo ventana Variantes
    importing
      es_variant         = rs_variant
    exceptions
      others             = 1.
  if sy-subrc = 0.
    p_vari = rs_variant-variant.
    g_variant_x-variant = p_vari.
    g_variant_x-text    = p_vari.
  endif.
endform.                    " F_VARIANTE_ALV
