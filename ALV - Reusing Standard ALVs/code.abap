DATA: lt_selscreen TYPE TABLE OF rsparams,
      wa_selscreen TYPE rsparams.

FIELD-SYMBOLS <lt_data>   TYPE ANY TABLE.
DATA lr_data              TYPE REF TO data.

* Monta a tabela com os dados do parâmetro de seleção
wa_selscreen-selname = 'INVNR'.   "Nome do campo
wa_selscreen-kind    = 'S'.       "Tipo (P - parameter /S - select-options)
wa_selscreen-sign    = 'I'.
wa_selscreen-option  = 'BT'.
wa_selscreen-low     = '120000'.
wa_selscreen-high    = '161000'.
APPEND wa_selscreen TO lt_selscreen.
CLEAR wa_selscreen.

wa_selscreen-selname = 'SWERK'. "Nome do campo
wa_selscreen-kind    = 'S'.     "Tipo (P - parameter /S - select-options)
wa_selscreen-sign    = 'I'.
wa_selscreen-option  = 'EQ'.
wa_selscreen-low     = '331'.
APPEND wa_selscreen TO lt_selscreen.
CLEAR wa_selscreen.

cl_salv_bs_runtime_info=>set(
  EXPORTING display  = abap_false
            metadata = abap_false
            data     = abap_true ).

* Executa o relatório e importa a tabela de saida
SUBMIT riequi20
  WITH SELECTION-TABLE lt_selscreen
  AND RETURN.
TRY.
    cl_salv_bs_runtime_info=>get_data_ref(
      IMPORTING r_data = lr_data ).
    ASSIGN lr_data->* TO <lt_data>.
  CATCH cx_salv_bs_sc_runtime_info.
    MESSAGE 'Não é possível recuperar os dados ALV' TYPE 'E'.

ENDTRY.

cl_salv_bs_runtime_info=>clear_all( ).