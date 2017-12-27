DATA: estrutura TYPE mara.

DATA: componentes TYPE cl_abap_structdescr=>component_table.

DATA: structdescr   TYPE REF TO cl_abap_structdescr,
      campodescr    TYPE REF TO cl_abap_datadescr.

FIELD-SYMBOLS <component> LIKE LINE OF cl_abap_structdescr=>components.

structdescr ?= cl_abap_structdescr=>describe_by_data( estrutura ).

* Aqui você recebe a lista de todos os componentes da estrutura, com outros
* objetos já referenciados de acordo com o tipo do campo. (abra no debug para entender)
* Com isso você pode saber O QUE VOCÊ QUISER sobre QUALQUER CAMPO da estrutura.
* Não é feitiçaria, é SAPLoLogia (só pra rimar)
componentes = structdescr->get_components( ).

* Vamos analisar um campo específico da estrutura:
campodescr = structdescr->get_component_type( 'MATNR' ). "Troque o campo para experimentar!"
WRITE: /01 'MATNR',
       10 'É do tipo',
       20 campodescr->type_kind.

*Ah, mas tudo que eu quero é um lista dos campos e já era!
LOOP AT structdescr->components ASSIGNING  <component>.
*   Tá, toma aí
    WRITE: /01 <component>-name,
            20 <component>-decimals,
            30 <component>-length,
            40 <component>-type_kind,
            50 sy-tabix. "posição na estrutura
ENDLOOP.
