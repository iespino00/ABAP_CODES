*&---------------------------------------------------------------------*
*&  Include           ZMM_SEM_PAGOS_PEDIDOS_FORM
*&---------------------------------------------------------------------*

form obteniendo_datos.
refresh ti_ekko.

if s_bedat is not initial.
  select * from ekko into corresponding fields of table ti_ekko
         where bstyp eq 'F' and bedat in s_bedat and bukrs in s_bukrs and ebeln in s_ebeln .

    select * from ekpo into corresponding fields of table ti_ekpo
        for all entries in ti_ekko
          where ebeln = ti_ekko-ebeln and loekz eq ''.
endif.
endform.

form match.
 sort  ti_ekko  by ebeln.
 sort ti_ekpo by ebeln.

*loop at ti_ekpo into wa_ekpo.
*  if wa_ekpo-LOEKZ eq 'L'.
*
*  else.
*  read table ti_ekko into wa_ekko with key ebeln = wa_ekpo-ebeln.
*  move-corresponding wa_ekko to wa_salida.
*  perform leer_texto.
*  endif.
*endloop.

  loop at ti_ekko into wa_ekko.
    clear wa_ekpo.
     read table ti_ekpo into wa_ekpo with key ebeln = wa_ekko-ebeln loekz = ''.
       if wa_ekpo is not initial.
       move-corresponding wa_ekko to wa_salida.
            perform leer_texto.
       endif.


  endloop.
endform.

form leer_texto.

    data: lc_tabix  type sy-tabix,
      lc_id     type thead-tdid,
      lc_object type thead-tdobject,
      wa_lines  type tline,
      lv_linea  type i,
      lt_lines  type table of tline with header line,
      lv_semana type string,
      lv_fecha type string,
      lv_importe type string,
      bas type string.

  refresh lt_lines.

lc_id = 'F00'. " Texto donde está el STRING buscado
lc_object = 'EKKO'. " Tabla de textos
nombre_texto = wa_ekko-ebeln.

          call function 'READ_TEXT'
          exporting
            id = lc_id
            language = sy-langu
            name = nombre_texto
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
   wa_salida-txtcab = ''.
   loop at lt_lines into wa_lines.

        case lv_linea.
             when 0.
                  wa_salida-txtcab = wa_lines-tdline.
             when 1.
                  wa_salida-txtcab = wa_lines-tdline.
             when 2.
                  wa_salida-txtcab = wa_lines-tdline.
             when 3.
                  wa_salida-txtcab = wa_lines-tdline.
             when 4.
                  wa_salida-txtcab = wa_lines-tdline.
             when 5.
                  wa_salida-txtcab = wa_lines-tdline.
             when 6.
                  wa_salida-txtcab = wa_lines-tdline.
             when 7.
                  wa_salida-txtcab = wa_lines-tdline.
             when 8.
                  wa_salida-txtcab = wa_lines-tdline.
             when 9.
                  wa_salida-txtcab = wa_lines-tdline.
             when 10.
                  wa_salida-txtcab = wa_lines-tdline.
             when 11.
                  wa_salida-txtcab = wa_lines-tdline.
             when 12.
                  wa_salida-txtcab = wa_lines-tdline.
             when 13.
                  wa_salida-txtcab = wa_lines-tdline.
             when 14.
                  wa_salida-txtcab = wa_lines-tdline.
             when 15.
                  wa_salida-txtcab = wa_lines-tdline.
             when 16.
                  wa_salida-txtcab = wa_lines-tdline.
             when 17.
                  wa_salida-txtcab = wa_lines-tdline.
             when 18.
                  wa_salida-txtcab = wa_lines-tdline.
             when 19.
                  wa_salida-txtcab = wa_lines-tdline.
             when 20.
                  wa_salida-txtcab = wa_lines-tdline.
             when 21.
                  wa_salida-txtcab = wa_lines-tdline.
             when 22.
                  wa_salida-txtcab = wa_lines-tdline.
             when 23.
                  wa_salida-txtcab = wa_lines-tdline.
             when 24.
                  wa_salida-txtcab = wa_lines-tdline.
             when 25.
                  wa_salida-txtcab = wa_lines-tdline.
             when 26.
                  wa_salida-txtcab = wa_lines-tdline.
             when 27.
                  wa_salida-txtcab = wa_lines-tdline.
             when 28.
                  wa_salida-txtcab = wa_lines-tdline.
             when 29.
                  wa_salida-txtcab = wa_lines-tdline.
             when 30.
                  wa_salida-txtcab = wa_lines-tdline.
             when 31.
                  wa_salida-txtcab = wa_lines-tdline.
             when 32.
                  wa_salida-txtcab = wa_lines-tdline.
             when 33.
                  wa_salida-txtcab = wa_lines-tdline.
             when 34.
                  wa_salida-txtcab = wa_lines-tdline.
             when 35.
                  wa_salida-txtcab = wa_lines-tdline.
             when 36.
                  wa_salida-txtcab = wa_lines-tdline.
             when 37.
                  wa_salida-txtcab = wa_lines-tdline.
             when 38.
                  wa_salida-txtcab = wa_lines-tdline.
             when 39.
                  wa_salida-txtcab = wa_lines-tdline.
             when 40.
                  wa_salida-txtcab = wa_lines-tdline.
             when 41.
                  wa_salida-txtcab = wa_lines-tdline.
             when 42.
                  wa_salida-txtcab = wa_lines-tdline.
             when 43.
                  wa_salida-txtcab = wa_lines-tdline.
             when 44.
                  wa_salida-txtcab = wa_lines-tdline.
             when 45.
                  wa_salida-txtcab = wa_lines-tdline.
             when 46.
                  wa_salida-txtcab = wa_lines-tdline.
             when 47.
                  wa_salida-txtcab = wa_lines-tdline.
             when 48.
                  wa_salida-txtcab = wa_lines-tdline.
             when 49.
                  wa_salida-txtcab = wa_lines-tdline.
             when 50.
                  wa_salida-txtcab = wa_lines-tdline.
             when 51.
                  wa_salida-txtcab = wa_lines-tdline.
             when 52.
                  wa_salida-txtcab = wa_lines-tdline.
             when 53.
                  wa_salida-txtcab = wa_lines-tdline.
             when 54.
                  wa_salida-txtcab = wa_lines-tdline.
             when 55.
                  wa_salida-txtcab = wa_lines-tdline.
             when 56.
                  wa_salida-txtcab = wa_lines-tdline.
             when 57.
                  wa_salida-txtcab = wa_lines-tdline.
             when 58.
                  wa_salida-txtcab = wa_lines-tdline.
             when 59.
                  wa_salida-txtcab = wa_lines-tdline.
             when 60.
                  wa_salida-txtcab = wa_lines-tdline.
             when 61.
                  wa_salida-txtcab = wa_lines-tdline.
             when 62.
                  wa_salida-txtcab = wa_lines-tdline.
             when 63.
                  wa_salida-txtcab = wa_lines-tdline.
             when 64.
                  wa_salida-txtcab = wa_lines-tdline.
             when 65.
                  wa_salida-txtcab = wa_lines-tdline.

        endcase.
        lv_linea = lv_linea + 1.

     split wa_salida-txtcab at 'MONTO:' into  wa_salida-txtcab lv_importe.
     split lv_importe at ';' into lv_importe  bas.

     split wa_salida-txtcab at 'FECHA:' into wa_salida-txtcab lv_fecha.

     split wa_salida-txtcab at 'SEM:' into wa_salida-txtcab lv_semana.

     wa_salida-semana = lv_semana.
     wa_salida-fecha = lv_fecha.
     wa_salida-importe = lv_importe.
     append wa_salida to ti_salida.
   endloop.

endif.
endform.

form llena_catalogo_alv.
  refresh it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '1'.
  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-tabname = 'TI_SALIDA'.
  wa_fieldcat-seltext_s = 'Pedido'.
  wa_fieldcat-seltext_m = 'Pedido'.
  wa_fieldcat-seltext_l = 'Pedido'.
  append wa_fieldcat to it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '2'.
  wa_fieldcat-fieldname = 'SEMANA'.
  wa_fieldcat-tabname = 'TI_SALIDA'.
  wa_fieldcat-seltext_s = 'Semana'.
  wa_fieldcat-seltext_m = 'Semana'.
  wa_fieldcat-seltext_l = 'Semana'.
  append wa_fieldcat to it_fieldcat.

    clear: wa_fieldcat.
  wa_fieldcat-col_pos = '3'.
  wa_fieldcat-fieldname = 'FECHA'.
  wa_fieldcat-tabname = 'TI_SALIDA'.
  wa_fieldcat-seltext_s = 'Fecha'.
  wa_fieldcat-seltext_m = 'Fecha'.
  wa_fieldcat-seltext_l = 'Fecha'.
  append wa_fieldcat to it_fieldcat.

    clear: wa_fieldcat.
  wa_fieldcat-col_pos = '4'.
  wa_fieldcat-fieldname = 'IMPORTE'.
  wa_fieldcat-tabname = 'TI_SALIDA'.
  wa_fieldcat-seltext_s = 'Importe'.
  wa_fieldcat-seltext_m = 'Importe'.
  wa_fieldcat-seltext_l = 'Importe'.
  append wa_fieldcat to it_fieldcat.
*   clear: wa_fieldcat.
*  wa_fieldcat-col_pos = '2'.
*  wa_fieldcat-fieldname = 'ANLN1'.
*  wa_fieldcat-tabname = 'TI_SALIDA'.
*  wa_fieldcat-seltext_s = 'Activo F.'.
*  wa_fieldcat-seltext_m = 'Activo F.'.
*  wa_fieldcat-seltext_l = 'Activo F.'.
*  append wa_fieldcat to it_fieldcat.

endform.


form llena_layout.
st_layout-window_titlebar = 'Detalle Documentos de Material'.
endform.

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
     t_outtab                       = ti_salida
  exceptions
    program_error                  = 1
    others                         = 2
           .
 if sy-subrc <> 0.
         message id sy-msgid type sy-msgty number sy-msgno
         with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 endif.
endform.
