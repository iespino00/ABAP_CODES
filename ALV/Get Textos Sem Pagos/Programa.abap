**************** BLOQUE DE DOCUMENTACION PRINCIPAL *********************
* Nombre del Programa : Reporte semanas de pagos
* Descripcion         : Obteniendo información de los textos del pedido.
* Autor del Programa  : IGNACIO ESPINO RIVERA
* Fecha               : 01/11/2017
* Report  ZMM_SEM_PAGOS_PEDIDOS
* Numero de version   : 1.0
* Solicitud: LZC 494
**
************************************************************************

report  zmm_sem_pagos_pedidos no standard page heading.

include zmm_sem_pagos_pedidos_top.

include zmm_sem_pagos_pedidos_form.



start-of-selection.
perform obteniendo_datos.
perform match.
perform llena_catalogo_alv.
perform llena_layout.
perform cal_alv.
