REPORT  zombie_teste_where.

**********************************************************************
* Object (O_XX)                                                      *
**********************************************************************
DATA: o_alv       TYPE REF TO cl_gui_alv_grid,
      o_container TYPE REF TO cl_gui_custom_container.

**********************************************************************
* Tabela Interna (TL_XX)                                             *
**********************************************************************
DATA: tl_tabela  TYPE REF TO data.

**********************************************************************
* Variavel (VL_XX)                                                   *
**********************************************************************
DATA: vl_tabela    TYPE string,
      vl_where     TYPE string,
      vl_rows      TYPE string VALUE '10',
      vl_structure TYPE dd02l-tabname.

**********************************************************************
* Field-Symbols <FS_XX>                                        *
**********************************************************************
FIELD-SYMBOLS: <fs_tabela>  TYPE STANDARD TABLE.

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.

*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  "Foi digitado um nome de tabela?
  CHECK vl_tabela IS NOT INITIAL.

  TRY.
      "Criação da tabela dinâmica
      CREATE DATA tl_tabela TYPE TABLE OF (vl_tabela).

    CATCH cx_root.

      EXIT.
  ENDTRY.

  ASSIGN tl_tabela->* TO <fs_tabela>.

  "Faz a seleção no banco de dados
  SELECT * UP TO vl_rows ROWS
    FROM (vl_tabela)
    INTO TABLE <fs_tabela>
    WHERE (vl_where).

  "Caso o ALV ja tenha sido instanciado, limpa seus atributos
  IF o_alv IS BOUND.
    o_alv->free( ).
  ENDIF.

  IF o_container IS NOT BOUND.

    "Faz a criação do objecto do container apenas uma vez
    CREATE OBJECT o_container
      EXPORTING
        container_name = 'ALV'.

  ENDIF.

  "Criação do Objecto do ALV
  CREATE OBJECT o_alv
    EXPORTING
      i_parent = o_container.

  vl_structure = vl_tabela.

  "Exibe o AVL
  CALL METHOD o_alv->set_table_for_first_display
    EXPORTING
      i_structure_name = vl_structure
    CHANGING
      it_outtab        = <fs_tabela>.

ENDMODULE.                 " USER_COMMAND_9000  INPUT