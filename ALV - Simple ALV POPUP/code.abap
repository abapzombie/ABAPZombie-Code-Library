FUNCTION zmmf_simple_alv_popup.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_START_COLUMN) TYPE  I DEFAULT 25
*"     REFERENCE(I_START_LINE) TYPE  I DEFAULT 6
*"     REFERENCE(I_END_COLUMN) TYPE  I DEFAULT 100
*"     REFERENCE(I_END_LINE) TYPE  I DEFAULT 10
*"     REFERENCE(I_TITLE) TYPE  STRING DEFAULT 'ALV'
*"     REFERENCE(I_POPUP) TYPE  FLAG DEFAULT 'X'
*"  TABLES
*"      IT_ALV TYPE  STANDARD TABLE
*"----------------------------------------------------------------------
* Objeto da classe CL_SALV_TABLE que iremos utilizar para mostrar o ALV
  DATA go_alv TYPE REF TO cl_salv_table.

* Montando e preenchendo nosso objeto de acordo com a Tabela Interna recebida no parâmetro
  TRY.

      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = it_alv[] ).

    CATCH cx_salv_msg.

  ENDTRY.

  DATA: lr_functions TYPE REF TO cl_salv_functions_list.

  lr_functions = go_alv->get_functions( ).
  lr_functions->set_all( 'X' ).

  IF go_alv IS BOUND.
    IF i_popup = 'X'.
*     Mostrando a tela do ALV em um tamanho menor parecido com um POPUP
      go_alv->set_screen_popup(
        start_column = i_start_column
        end_column  = i_end_column
        start_line  = i_start_line
        end_line    = i_end_line ).
    ENDIF.

*   Método que mostra o ALV
    go_alv->display( ).

  ENDIF.

ENDFUNCTION.