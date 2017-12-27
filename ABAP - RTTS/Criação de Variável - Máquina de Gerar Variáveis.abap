DATA: elemdescr TYPE REF TO cl_abap_elemdescr.

* Char
elemdescr = cl_abap_elemdescr=>get_c( 10 ).
PERFORM escreva_sei_la_o_que USING elemdescr '1234567890A'.

* Inteiro
elemdescr = cl_abap_elemdescr=>get_i( ).
PERFORM escreva_sei_la_o_que USING elemdescr 123.

* NumChar
elemdescr = cl_abap_elemdescr=>get_n( 5 ).
PERFORM escreva_sei_la_o_que USING elemdescr 987654.

* String
elemdescr = cl_abap_elemdescr=>get_string( ).
PERFORM escreva_sei_la_o_que USING elemdescr 'Prevenindo Consultores e Virarem Zumbis'.

* Packed com Decimais
elemdescr = cl_abap_elemdescr=>get_p( p_length = 10 p_decimals = 5 ).
PERFORM escreva_sei_la_o_que USING elemdescr '1234567890.12345' .

*&---------------------------------------------------------------------*
*&      Form  ESCREVA_SEI_LA_O_QUE
*&---------------------------------------------------------------------*
FORM escreva_sei_la_o_que  USING p_elemdescr TYPE REF TO cl_abap_elemdescr
                                 p_seila.

  DATA: variavel TYPE REF TO data.

  FIELD-SYMBOLS <variavel> TYPE any.

  CREATE DATA variavel TYPE HANDLE p_elemdescr.

  ASSIGN variavel->* TO <variavel>.

  <variavel> = p_seila.
  WRITE: /01 'Tipo:',
          7   p_elemdescr->type_kind,
          20 'Tamanho:',
          35  p_elemdescr->length,
          50 'Valor:',
          60 <variavel>.

ENDFORM.                    " ESCREVA_SEI_LA_O_QUE
