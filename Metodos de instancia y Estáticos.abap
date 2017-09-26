*&---------------------------------------------------------------------*
*& Report  Z_METODOS_POO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_metodos_poo.

*----------------------------------------------------------------------*
*       CLASS tarifas IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS tarifa DEFINITION.
  PUBLIC SECTION.
    "Definicion del método estatico
    CLASS-METHODS  set_tarifa_base IMPORTING i_tarifa TYPE i.

    "metodos de instancia, puede llevar el mismo nombre
    METHODS set_tarifa_empleado IMPORTING i_tarifa TYPE i. "establece la tarifa de empleado
    METHODS visualizar_tarifa.   "visualiza


  PRIVATE SECTION.
    "atributo estatico para interactuar con el metodo estatico
    CLASS-DATA tarifa_base TYPE i.
    DATA tarifa_empleado TYPE i.

ENDCLASS.                    "tarifas IMPLEMENTATION


*----------------------------------------------------------------------*
*       CLASS tarifa IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS tarifa IMPLEMENTATION.
  METHOD set_tarifa_base.
    tarifa_base = i_tarifa.
  ENDMETHOD.                    "set_tarifa_base

  METHOD set_tarifa_empleado.
    tarifa_empleado = i_tarifa.
  ENDMETHOD.                    "set_tarifa_empleado

  METHOD visualizar_tarifa.
    WRITE: / 'tarifa base: ', tarifa_base,
           / 'tarifa empleado:', tarifa_empleado.
  ENDMETHOD.                    "visualizar_tarifa
ENDCLASS.                    "tarifa IMPLEMENTATION

START-OF-SELECTION.
  "Declaracion del objeto para poder utilizar las métodos de instancia de la clase
  DATA: go_tarifa TYPE REF TO tarifa,
        go_tarifa2 TYPE REF TO tarifa.

  "Llamada de un metodo estatico (no dependen de la instancia)
*tarifa=>set_tarifa_base( i_tarifa = 20 ).

  "otra forma de Llamada de metodos estaticos
  CALL METHOD tarifa=>set_tarifa_base
    EXPORTING
      i_tarifa = 20.

  "Llamada de metodos de instancia.
  CREATE OBJECT go_tarifa.
  CREATE OBJECT go_tarifa2.

  go_tarifa->set_tarifa_empleado( i_tarifa = 30 ).
  go_tarifa2->set_tarifa_empleado( i_tarifa = 50 ).

  go_tarifa->visualizar_tarifa( ).

  SKIP 2.

  go_tarifa2->visualizar_tarifa( ).
