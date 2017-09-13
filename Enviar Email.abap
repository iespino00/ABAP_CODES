*&---------------------------------------------------------------------*
*& Report  Z_ENVIAR_EMAIL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z_ENVIAR_EMAIL.

  DATA: maildata TYPE sodocchgi1.
  DATA: mailtxt TYPE TABLE OF solisti1 WITH HEADER LINE.
  DATA: mailrec TYPE TABLE OF somlrec90 WITH HEADER LINE.

  CLEAR: maildata, mailtxt, mailrec.
  REFRESH: mailtxt, mailrec.
    REFRESH: mailtxt.

  maildata-obj_name = 'SAPRPT'.
  maildata-obj_descr = 'Asunto del email'.
  maildata-obj_langu = sy-langu.

  mailtxt-line = 'Cuerpo del email...'.
  APPEND mailtxt.

  mailrec-receiver = 'correo@gmail.com'.
 " ailrec-rec_type = 'U'.
  APPEND mailrec.

 CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = maildata
        document_type              = 'RAW'
        put_in_outbox              = 'X'
        commit_work                = 'X'
      TABLES
        object_header              = mailtxt
        object_content             = mailtxt
        receivers                  = mailrec
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.




IF sy-subrc = 0.

MESSAGE 'El correo fue enviado con éxito' TYPE 'S'.

ELSE.

MESSAGE 'El mensaje de correo no fue enviado' TYPE 'W'.

ENDIF.
