*&----------------------------------------------------------------------*
*& PROGRAMA.............: ZMM_ABC_MASIVO
*& AUTOR................: Ignacio Espino Rivera
*& FECHA................: 02.09.2017
*& TRANSACCION..........: ZCARGA_ABC
*&----------------------------------------------------------------------*
*& DESCRIPCION:
*Cargar un archivo Excel para actualizar el indicador ABC
*de los materiales, ubicado en el campo grpo porte en la
*pestaña de compras.

report  zmm_abc_masivo.

include zmm_abc_masivo_top.
include zmm_abc_masivo_form.

*&---------------------------------------------------------------------*
*& Validaciones de Pantalla
*&---------------------------------------------------------------------*
at selection-screen on value-request for archivo.
    perform set_filepath changing archivo.

initialization.
start-of-selection.

    perform upload_excel_it using archivo changing ti_data.

 if ti_data[] is initial.
    message text-e02 type 'I' display like 'E'.
  else.
    perform cargar_alv.
  endif.

  end-of-selection.
