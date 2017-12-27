DATA: tabela TYPE TABLE OF mara.

DATA: tabledescr  TYPE REF TO cl_abap_tabledescr,
      structdescr TYPE REF TO cl_abap_structdescr.

FIELD-SYMBOLS <key> LIKE LINE OF tabledescr->key.

tabledescr ?= cl_abap_tabledescr=>describe_by_data( tabela ).

* Vamos fuçar na linha da tabela
structdescr ?= tabledescr->get_table_line_type( ).
* Note que o programa faz um downcast do tipo que GET_TABLE_LINE_TYPE retorna para o
* objeto STRUCTDESCR.
* E aqui você pode usar o exemplo de estruturas para fuçar no objeto STRUCTDESCR.
* [insira o código do exemplo anterior aqui]

* Campos da tabela
LOOP AT tabledescr->key ASSIGNING <key> .
  WRITE / sy-tabix.    "Posição do Campo
  WRITE 20 <key>-name. "Números da Mega-Sena (quem sabe assim algúem testa este exemplo!)
ENDLOOP.

* Tem mais um monte de atributos que descrevem outras coisas da tabela
* interna. Explore!
