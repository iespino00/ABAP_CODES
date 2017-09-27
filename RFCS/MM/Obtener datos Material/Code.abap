function zmm_intranet_almacen.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(CODIGO) LIKE  MARA-MATNR OPTIONAL
*"     VALUE(CENTRO) LIKE  MARD-WERKS OPTIONAL
*"     VALUE(FECHA_INICIO) LIKE  MKPF-BUDAT OPTIONAL
*"     VALUE(INDICADOR) LIKE  PA0001-PERNR OPTIONAL
*"     VALUE(FECHA_FIN) LIKE  MKPF-BUDAT OPTIONAL
*"     VALUE(PROVEEDOR) LIKE  LFA1-LIFNR OPTIONAL
*"     VALUE(CONSULTA) LIKE  PA0001-PERNR OPTIONAL
*"  TABLES
*"      MATERIAL STRUCTURE  ZWA_MMALMACENMOVI
*"----------------------------------------------------------------------
include zmm_intranet_almacen_top.

*OBTENGO INFORMACIÓN DEL CODIGO DE MATERIAL
if indicador eq 1.

    select * from mara
    into table ti_mara
    where matnr = codigo.

    if ti_mara is not initial.

        select * from makt
        into  table ti_makt
        for all entries in ti_mara
        where matnr = ti_mara-matnr.

        select * from mard
        into table ti_mard
        for all entries in ti_mara
        where matnr = ti_mara-matnr
        and werks = centro.

        select * from mbew
          into table ti_mbew
          for all entries in ti_mara
          where matnr = ti_mara-matnr.

    endif.

   read table ti_mara index 1 into wa_mara.
   move-corresponding wa_mara to material.


   read table ti_makt index 1 into wa_makt.
   move-corresponding wa_makt to material.
*  append material.

  loop at ti_mard into wa_mard.
    stock = stock + wa_mard-labst.
  endloop.
   material-labst = stock.
   material-lgpbe = wa_mard-lgpbe.

  read table ti_mbew index 1 into wa_mbew.
  move-corresponding wa_mbew to material.

  append material.

endif.


*OBTENGO LOS MOVIMIENTOS DE ENTRADA DEL MATERIAL
if indicador eq 2.
*select * from mkpf
*  into table ti_mkpf
*  where BUDAT BETWEEN fecha_inicio and fecha_fin.
*
*
*loop at ti_mkpf into wa_mkpf.
*   move-corresponding wa_mkpf to material.
*   append material.
*endloop.

*BUSCO TODOS LOS MOVIMIENTOS DE ENTRADA QUE HA TENIDO ESE MATERIAL EN LA MSEG
if consulta eq 1.
  select * from mseg
  into table ti_mseg
  where matnr = codigo
  and bwart = 101.
endif.

if consulta eq 2.


  select * from mseg
    into table ti_mseg
    where lifnr = proveedor
    and bwart = 101.
endif.


*IF CONSULTA EQ 2.
*  select * from mseg
*    into table ti_mseg
*    where lifnr = proveedor
*    and BWART = 101.
*ENDIF.
  if ti_mseg is not initial.
     loop at ti_mseg into wa_mseg.

       select * from mkpf
       into table ti_mkpf
       where mblnr = wa_mseg-mblnr
       and budat between fecha_inicio and fecha_fin.
    if ti_mkpf is not initial.
      move-corresponding wa_mseg to material.
*     DE LA CONSULTA ANTERIOR, OBTENGO EL CODIGO DEL MATERIAL PARA OBTENER EL SOLICITANTE Y EL TEXTO DE LA POSICION
      select * from ekpo
       into table ti_ekpo
         where ebeln = wa_mseg-ebeln
         and ebelp = wa_mseg-ebelp.

        select * from lfa1
          into table ti_lfa1
          where lifnr = wa_mseg-lifnr.

        read table ti_lfa1 index 1 into wa_lfa1.
        move-corresponding wa_lfa1 to material.

        read table ti_ekpo index 1 into wa_ekpo.
        move-corresponding wa_ekpo to material.

        read table ti_mkpf index 1 into wa_mkpf.
        move-corresponding wa_mkpf to material.

*           loop at ti_mkpf into wa_mkpf.
*           move-corresponding wa_mkpf to material.
*           append material.
*          endloop.
     append material.
     endif.
     endloop.
   endif.
endif.

*OBTENGO LA INFORMACIÓN DEL PROVEEDOR
if indicador eq 3.

 call function 'CONVERSION_EXIT_ALPHA_INPUT'
 exporting
  input = proveedor
 importing
  output = acreedor.

select * from lfa1
  into table ti_lfa1
  where lifnr = acreedor.

   read table ti_lfa1 index 1 into wa_lfa1.
   move-corresponding wa_lfa1 to material.
   append material.
endif.


endfunction.
