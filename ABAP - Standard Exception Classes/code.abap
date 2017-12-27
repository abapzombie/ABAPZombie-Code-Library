DATA: vl_string TYPE char10,
      vl_numc   TYPE i.

vl_string = 'ABAPZOMBIE.BLOG.BR'.

TRY.

    MOVE vl_string TO vl_numc.

  CATCH cx_sy_conversion_no_number.

    MESSAGE e000(o0) WITH 'Erro de conversão'.

  CATCH cx_sy_conversion_overflow.

    MESSAGE e000(o0) WITH 'Estouro de variável'.

ENDTRY.