*&---------------------------------------------------------------------*
*&  Include           Z_ABAP_NAVEGACION_ALV_FORM
*&---------------------------------------------------------------------*

form obteniendo_datos .
select * from ekko into corresponding fields of table ti_ekko
         where bstyp eq 'F' and ebeln in s_ebeln .
endform.                    " OBTENIENDO_DATOS

form match.
  loop at ti_ekko into wa_ekko.
   move-corresponding wa_ekko to wa_salida.
   append wa_salida to ti_salida.
  endloop.
endform.                    " MATCH

form llena_catalogo_alv .
 refresh it_fieldcat.

  clear: wa_fieldcat.
  wa_fieldcat-col_pos = '1'.
  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-tabname = 'TI_SALIDA'.
  wa_fieldcat-seltext_s = 'Pedido'.
  wa_fieldcat-seltext_m = 'Pedido'.
  wa_fieldcat-seltext_l = 'Pedido'.
   wa_fieldcat-key         = 'X'.
  append wa_fieldcat to it_fieldcat.
endform.                    " LLENA_CATALOGO_ALV

form llena_layout .
st_layout-window_titlebar = 'Moverse de un Reporte ALV a una transacción'.
endform.                    " LLENA_LAYOUT

form cal_alv .
call function 'REUSE_ALV_GRID_DISPLAY'
  exporting
*   I_INTERFACE_CHECK              = ' '
*    I_BYPASSING_BUFFER             =
*     I_BUFFER_ACTIVE                = space
     i_callback_program             = sy-repid
*    I_CALLBACK_PF_STATUS_SET       = ' '
     i_callback_user_command  = 'USER_COMMAND'
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
endform.                    " CAL_ALV


form user_command using r_ucomm like sy-ucomm
                  rs_selfield type slis_selfield.

* Check function code
  case r_ucomm.
    when '&IC1'.
*   Check field clicked on within ALVgrid report
    if rs_selfield-fieldname = 'EBELN'.
*     Read data table, using index of row user clicked on
      read table ti_ekko into wa_ekko index rs_selfield-tabindex.
*     Set parameter ID for transaction screen field
      set parameter id 'BES' field wa_ekko-ebeln.
*     Sxecute transaction ME23N, and skip initial data entry screen
      call transaction 'ME23N' and skip first screen.
    endif.
  endcase.
endform.
