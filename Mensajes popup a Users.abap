*&---------------------------------------------------------------------*
*& Report  ZCALCULATOR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*



REPORT ZCALCULATOR NO STANDARD PAGE HEADING LINE-SIZE 255.

TABLES: USR41, SPOPLI.

DATA: l_length   TYPE i,
      USER_TEXT  LIKE AGR_TEXTS-TEXT,
      TERMINAL   LIKE USR41-TERMINAL,
      RESPUESTA(2),
      IP(15),
      PC(16).

DATA: ITAB LIKE SPOPLI OCCURS 0 WITH HEADER LINE.
DATA: NOMBRE LIKE SY-UNAME.
DATA: FLAG(1).


PARAMETERS: l_msg  LIKE sm04dic-popupmsg default 'Escribir texto'.



*----------------------------------------------------------------------*
START-OF-SELECTION.
*----------------------------------------------------------------------*

  PERFORM TOMAR_DATOS_DESTINATARIOS.
  PERFORM TOMAR_DECISION.

  CHECK RESPUESTA NE 'A'.

  TRANSLATE L_MSG USING '= '.
  l_length = strlen( l_msg ).

  LOOP AT ITAB WHERE SELFLAG = 'X'.
    PERFORM TH_POPUP.
  ENDLOOP.







************************************************************************
*                           SUBRUTINAS                                 *
************************************************************************
*&---------------------------------------------------------------------*
*&      Form  TOMAR_DATOS_DESTINATARIOS
*&---------------------------------------------------------------------*
FORM TOMAR_DATOS_DESTINATARIOS.

  SELECT * FROM  USR41 INTO USR41.

    CONCATENATE PC ',' ITAB-VAROPTION INTO ITAB-VAROPTION.

    MOVE USR41-BNAME TO ITAB-VAROPTION.
    ITAB-SELFLAG = ' '.
    APPEND ITAB.
    CLEAR ITAB.

  ENDSELECT.

ENDFORM.                    "TOMAR_DATOS_DESTINATARIOS

*&---------------------------------------------------------------------*
*&      Form  TOMAR_DECISION
*&---------------------------------------------------------------------*
FORM TOMAR_DECISION.
  DATA: RESTO.

  CALL FUNCTION 'POPUP_TO_DECIDE_LIST'
    EXPORTING
      MARK_FLAG          = 'X'
      MARK_MAX           = 10
      TEXTLINE1    =
      'MARCA A LOS USUARIOS QUE QUIERAS ENVIAR EL MENSAJE'
      TITEL              = 'DESTINATARIOS'
    IMPORTING
      ANSWER             = RESPUESTA
    TABLES
      T_SPOPLI           = ITAB
    EXCEPTIONS
      NOT_ENOUGH_ANSWERS = 1
      TOO_MUCH_ANSWERS   = 2
      TOO_MUCH_MARKS     = 3
      OTHERS             = 4.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  LOOP AT ITAB WHERE SELFLAG = 'X'.
    IF FLAG = ' '.
      FLAG = 'X'.
      WRITE: 3 'Usuarios que han recibido el mensaje:'.
      WRITE: 41 ITAB-VAROPTION.
    ELSE.
      WRITE: /41 ITAB-VAROPTION.
    ENDIF.
  ENDLOOP.

ENDFORM.                    "TOMAR_DECISION
*&---------------------------------------------------------------------*
*&      Form  TH_POPUP
*&---------------------------------------------------------------------*
FORM TH_POPUP .
  CLEAR NOMBRE.

  MOVE ITAB-VAROPTION TO NOMBRE.
  CALL FUNCTION 'TH_POPUP'
               EXPORTING
                    client         = sy-mandt
                    user           = NOMBRE
                    MESSAGE        = l_msg
                    message_len    = l_length
*                     CUT_BLANKS     = ' '
               EXCEPTIONS
                    user_not_found = 1
                    OTHERS         = 2.

ENDFORM.                    " TH_POPUP
