*&---------------------------------------------------------------------*
*& Report  Z_ENVIAR_EMAIL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z_ENVIAR_EMAIL.

**********************************************
* Email
**********************************************
* Declaraciones de tablas internas
DATA: i_receivers TYPE TABLE OF somlreci1 WITH HEADER LINE,

** Objetos a mandar por email
      i_objpack LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_objtxt  LIKE solisti1   OCCURS 0 WITH HEADER LINE,
      i_objbin  LIKE solisti1   OCCURS 0 WITH HEADER LINE,
      i_reclist LIKE somlreci1  OCCURS 0 WITH HEADER LINE,

* Declaraciones de estructuras
      wa_objhead  TYPE soli_tab,
      wa_doc_chng TYPE sodocchgi1,
      w_data      TYPE sodocchgi1,

* Declaración de variables
      v_len_out   TYPE so_obj_len,
      v_len_outn  TYPE i,
      v_lines_txt TYPE i,
      v_lines_bin TYPE i,

* Importar de la bapi
      zsend_to_all TYPE so_text001,
      znew_order   TYPE so_obj_id.


*******************************************************************
*/////////////////////////////////////////////////////////////
* A S U N T O  , R E M I T E N T E  y  D E S T I N A T A R I O
*/////////////////////////////////////////////////////////////
DATA: asunto_email(255) TYPE c VALUE 'Asunto EMAIL'.
DATA: remitente    TYPE so_rec_ext. "kien envía, se puede poner uno fijo
DATA: destinatario TYPE ad_smtpadr
      VALUE 'email@gmail.com'.
* Si no se pone remitente, el sistema lo coge automáticamente
* de la sesión del usuario, de este usuario
*******************************************************************

* Variable del texto a enviar
DATA: v_texto TYPE string.
TYPES: BEGIN OF t_texttable,
         line(255) TYPE c,
       END OF t_texttable.
* Estructura del texto a enviar
DATA: w_texttable TYPE t_texttable.
* Tabla donde estará el texto a enviar
DATA: i_texttable TYPE TABLE OF t_texttable.

REFRESH: i_reclist, i_objtxt, i_objbin, i_objpack.
CLEAR wa_objhead.

*******************************************************************
*////////////////////////////////////////
* T E X T O  D E L  E M A I L
*////////////////////////////////////////
*-----1ª línea
v_texto = 'Prueba del cuerpo del email, primera línea.'.
w_texttable-line = v_texto.
APPEND w_texttable TO i_texttable.
*-----2ª línea
v_texto = 'Podemos seguir escribindo, segunda línea.'.
w_texttable-line = v_texto.
APPEND w_texttable TO i_texttable.
*******************************************************************

* i_texttable es una tabla con un campo texto ( 255 caracteres )
* cargamos el cuerpo del email en la tabla a mandar
i_objtxt[] = i_texttable[].

DESCRIBE TABLE i_objtxt LINES v_lines_txt.
READ TABLE i_objtxt INDEX v_lines_txt.
wa_doc_chng-obj_name   = asunto_email.
wa_doc_chng-expiry_dat = sy-datum + 10.
wa_doc_chng-obj_descr  = asunto_email.
wa_doc_chng-sensitivty = 'F'.
wa_doc_chng-doc_size   = v_lines_txt * 255.

CLEAR i_objpack-transf_bin.
i_objpack-head_start = 1.
i_objpack-head_num   = 0.
i_objpack-body_start = 1.
i_objpack-body_num   = v_lines_txt.
i_objpack-doc_type   = 'RAW'.
APPEND i_objpack.


* ---> Destinatario del correo
CLEAR i_reclist.
i_reclist-receiver   = destinatario.
i_reclist-rec_type   = 'U'.  "Usuario de internet
APPEND i_reclist.
** Akí puedes apendear los usuarios q kieras
** con un loop a una tabla ...
*CLEAR i_reclist.
*i_reclist-receiver   = destinatario2.
*i_reclist-rec_type   = 'U'.  "Usuario de internet
*APPEND i_reclist.


* ---> Envio de correo al destinatario
CLEAR i_objpack.
CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
EXPORTING
  document_data              = wa_doc_chng
  put_in_outbox              = 'X'
  sender_address             = remitente
  sender_address_type        = 'SMTP'
  commit_work                = 'X'
IMPORTING
  sent_to_all                = zsend_to_all
  new_object_id              = znew_order
TABLES
  packing_list               =  i_objpack
  object_header              =  wa_objhead
  contents_bin               =  i_objbin
  contents_txt               =  i_objtxt
*  contents_hex               = contents_hex "no uso
*  object_para                = object_para  "no uso
*  object_parb                = object_parb  "no uso
  receivers                  = i_reclist
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

write: 'El correo fue enviado con éxito'.

ELSE.

write: 'El mensaje de correo no fue enviado'.

ENDIF.
