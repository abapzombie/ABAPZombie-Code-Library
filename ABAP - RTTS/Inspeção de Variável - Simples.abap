DATA: material  TYPE mara-matnr,
      texto     TYPE string.

DATA: relative_name TYPE string.

DATA: o_typedescr TYPE REF TO cl_abap_typedescr.

DATA: x031l TYPE TABLE OF x031l,
      x030l TYPE x030l.

* Criando o objeto para análise. Este objeto fará referência ao
* tipo da variável "material".
o_typedescr = cl_abap_typedescr=>describe_by_data( material ).

* Nome absoluto contém o nome + identificador. No caso, será \TYPE=MATNR
* que indica que este objeto é referente a um TYPE MATNR(elemento de dados).
* Experimente trocar o tipo do campo para PSTAT, e você verá que o TYPE muda
* para o elemento de dados, que é o PSTAT_D.
WRITE / o_typedescr->absolute_name.

* Nome utilizado para referência no programa.
relative_name = o_typedescr->get_relative_name( ).
WRITE / relative_name.

* Métodos que só funcionam se o tipo referenciado veio do DDIC.
* Se você trocar de "material" para "texto" na hora de chamar o
* método describe_by_data, irá tomar um DUMP na cabeça.
x031l[] = o_typedescr->get_ddic_object( ).
x030l   = o_typedescr->get_ddic_header( ).

* Tipo da Variável, neste caso C de CHAR
WRITE: / o_typedescr->type_kind.

* Tamanho da variável, para o elemento de dados MATNR - 18
WRITE: / o_typedescr->length.
