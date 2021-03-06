REPORT Y_ListBox_en_Reportes.

TYPE-POOLS: vrm.
DATA: name TYPE vrm_id, list TYPE vrm_values, value LIKE LINE OF list.
PARAMETERS: ps_parm(10) AS LISTBOX VISIBLE LENGTH 10.

AT SELECTION-SCREEN OUTPUT.
  name = 'PS_PARM'.
  value-key = '1'. value-text = 'Linea 1'. APPEND value TO list.
  value-key = '2'. value-text = 'Linea 2'. APPEND value TO list.
  value-key = '3'. value-text = 'Linea 3'. APPEND value TO list.
  value-key = '4'. value-text = 'Linea 4'. APPEND value TO list.
  value-key = '5'. value-text = 'Linea 5'. APPEND value TO list.
  value-key = '6'. value-text = 'Linea 6'. APPEND value TO list.

  CALL FUNCTION 'VRM_SET_VALUES'
       EXPORTING
            id     = name
            values = list.

START-OF-SELECTION.
  WRITE: / 'Parametros : ', ps_parm.
