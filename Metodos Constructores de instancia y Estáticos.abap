*&---------------------------------------------------------------------*
*& Report  Z_CONSTRUCTORES_POO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  Z_CONSTRUCTORES_POO.

"Constructores son un tipo especial de metodos que no pueden ser llamados con call method
"son llamados automaticamente por el sistema para fijar el estado inicial de un objeto o clase

"1.-Definicion de la clase con sus secciones public y private...etc
CLASS EMPLEADO DEFINITION.
    PUBLIC SECTION.

"5.-Crear el metodo constructor de instancia (Solo admite importing y excepciones, no acepta exporting porque no retorna valores)
    METHODS constructor IMPORTING i_nombre type string.

"7.-Crear constructor estático. (No lleva importing ni exporting porque es estatico y se ejecuta el momento de iniciar el programa)
    CLASS-METHODS CLASS_CONSTRUCTOR.

ENDCLASS.

"6.- Implementar el metodo.

CLASS empleado IMPLEMENTATION.
    METHOD constructor.
    write: / 'El constructor de instancia', i_nombre. "El cocnstructor de instancia se llama dependiendo de los objetos.
    ENDMETHOD.

    METHOD class_constructor.
      write: / 'Estamos en el constructor estático'. "El constructor estático se llama solo una vez.
    ENDMETHOD.
ENDCLASS.

"2.-Creamos el inicio del programa
START-OF-SELECTION.

"3.-Creamos la instancia de los objetos
Data: go_empleado1 type REF TO empleado,
      go_empleado2 type REF TO empleado.

"4.-Creamos los objetos de las instancias
CREATE OBJECT: go_empleado1 EXPORTING i_nombre = 'Carlos', "Como el metodo tiene un importing que espera recibir un valor, se declara este exporting.
               go_empleado2 EXPORTING i_nombre = 'Pedro'.
