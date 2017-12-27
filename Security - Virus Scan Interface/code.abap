* Busca instância do scanner
DATA: lo_scanner TYPE REF TO cl_vsi.

CALL METHOD cl_vsi=>get_instance
  EXPORTING
    if_profile         = '/MEU_PACOTE/MINHA_APLICACAO'
  IMPORTING
    eo_instance        = lo_scanner
  EXCEPTIONS
    profile_not_active = 1
    OTHERS             = 2.

CASE sy-subrc.
  WHEN 0.
* Tudo certo com a interface
  WHEN 1.
* O antivírus está desabilitado para a aplicação /MEU_PACOTE/MINHA_APLICACAO.
* Aqui, a SAP recomenda exibir o erro com a mensagem da exceção se o
* escaneamento anti-vírus for obrigatório.
  WHEN OTHERS.
* Este caso é sempre um erro, e a SAP também recomenda que seja sempre usada
* a mensagem da exceção.
ENDCASE.

DATA: lv_scanrc TYPE vscan_scanrc,
      lv_data   TYPE xstring,
      lv_text   TYPE string.

* A variável LV_DATA aqui deve receber o conteúdo do arquivo a ser escaneado

CALL METHOD lo_scanner->scan_bytes
  EXPORTING
    if_data             = lv_data
  IMPORTING
    ef_scanrc           = lv_scanrc
  EXCEPTIONS
    not_available       = 1
    configuration_error = 2
    internal_error      = 3
    OTHERS              = 4.

* Se o SY-SUBRC voltar diferente de 0 aqui, é erro da VSI
IF sy-subrc <> 0.
* MESSAGE...
* EXIT.
ENDIF.

* Para cada valor de LV_SCANRC retornado pelo SCAN_BYTES, existe um texto
* correspondente que pode ser buscado com o GET_SCANRC_TEXT. Se voltar 0,
* nenhum vírus
lv_text = cl_vsi=>get_scanrc_text( lv_scanrc ).

WRITE: / 'Resultado do escaneamento:',
       / 'Return code: ',              lv_scanrc,
       / 'Descrição: ',                lv_text.