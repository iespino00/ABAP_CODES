**************** BLOQUE DE DOCUMENTACION PRINCIPAL *********************
* Nombre del Programa : Reporte de Solicitudes y Pedidos en General
* Descripcion         : (Reporte que arroja todas las solicitudes y todos los pedidos sin importar su status (similar a zrequis y me5a))
* Autor del Programa  : IGNACIO ESPINO RIVERA
* Fecha               : 02/07/2014
* Referencia de Diseno:
* Numero de version   : 1.0
************************************************************************

report  zmm_requis_pedidos no standard page heading.

include zmm_requis_pedidos_top.
include zmm_requis_pedidos_form.

initialization.

start-of-selection.

perform get_data.
perform match.
perform llena_catalogo_alv.
perform llena_sort.
perform llena_layout.
perform cal_alv.
