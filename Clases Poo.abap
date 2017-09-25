*&---------------------------------------------------------------------*
*& Report  Z_CLASES_POO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_clases_poo.

*----------------------------------------------------------------------*
*       CLASS alumno DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS alumno DEFINITION.

  PUBLIC SECTION.

    "Definición del método (importing  porque recibe parametros para asignar valor a la variable)
    METHODS set_nombre IMPORTING i_nombre TYPE string.
    METHODS get_nombre EXPORTING e_nombre type string.

  PROTECTED SECTION.

  PRIVATE SECTION.
    "Creo los atributos de la clase
    DATA: nombre TYPE string.

ENDCLASS.                    "alumno DEFINITION


"Implementación del método de la clase alumno
*----------------------------------------------------------------------*
*       CLASS alumno IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS alumno IMPLEMENTATION.

  METHOD set_nombre.
    nombre = i_nombre.
  ENDMETHOD.                  "set_nombre

  METHOD get_nombre.
   e_nombre = nombre.
  ENDMETHOD.

ENDCLASS.                    "alumno IMPLEMENTATION


START-OF-SELECTION.

  "Declaracion variable global object, crea una instancia de memoria.
  DATA: go_alumno TYPE REF TO alumno,
        gv_nombre TYPE string.

  "Crear objeto de la clase referenciado a la instancia.
  CREATE OBJECT go_alumno.

*Se puede asignar el valor a la variable siempre y cuando la declaración este
*en la parte publica de la clase, de lo contrario si se pasa a la parte privada,
* se tendrá que acceder desde la misma clase.
  "  go_alumno->nombre = 'Pedro'.


  CALL METHOD go_alumno->set_nombre
       EXPORTING
                i_nombre = 'Alberto'.


  go_alumno->get_nombre(
        IMPORTING
            e_nombre = gv_nombre ).
        WRITE gv_nombre.
