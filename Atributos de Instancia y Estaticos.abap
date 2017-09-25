*&---------------------------------------------------------------------*
*& Report  Z_ATRIBUTOS_POO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_atributos_poo.

*----------------------------------------------------------------------*
*       CLASS factura DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS factura DEFINITION.

  PUBLIC SECTION.

    DATA: proveedor TYPE string.

    "Atributo de tipo constante se declara:
    CLASS-DATA fecha_pago type d.


ENDCLASS.                    "factura DEFINITION

START-OF-SELECTION.

  DATA: go_factura1 TYPE REF TO factura,
        go_factura2 TYPE REF TO factura.

  "Instancicamos los objetos en memoria
  CREATE OBJECT: go_factura1 ,
                 go_factura2.

  go_factura1->proveedor = 'Dell'.
  go_factura2->proveedor = 'Hp'.

"Para acceder a los atributos staticos de la clase se hace como:
  factura=>fecha_pago = '20200925'. "lAS DOS INSTANCIAS TENDRAN EL MISMO VALOR POR SER UN ATRIBUTO ESTÁTICO

  WRITE: / go_factura1->proveedor,
           go_factura1->fecha_pago DD/MM/YYYY.
  SKIP 2.
  WRITE:/ go_factura2->proveedor,
           go_factura2->fecha_pago DD/MM/YYYY.
