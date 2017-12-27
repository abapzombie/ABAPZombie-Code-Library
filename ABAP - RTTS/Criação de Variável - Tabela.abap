DATA: tabela    TYPE REF TO data,
      estrutura TYPE REF TO data.

FIELD-SYMBOLS: <tabela>    TYPE standard table,
               <estrutura> TYPE any,
               <campo>     TYPE any.

DATA: structdescr TYPE REF TO cl_abap_structdescr,
      tabledescr  TYPE REF TO cl_abap_tabledescr,
      datadescr TYPE REF TO cl_abap_datadescr,
      elemdescr TYPE REF TO cl_abap_elemdescr.

DATA: componentes TYPE abap_component_tab,
      componente  LIKE LINE OF componentes.

*-- Criação da Estrutura Igual Exemplo Anterior:

elemdescr = cl_abap_elemdescr=>get_c( 10 ).
componente-name = 'CHAR_DE_10'.
componente-type = elemdescr.
APPEND componente TO componentes.

datadescr ?= cl_abap_datadescr=>describe_by_name('WERKS_D').
componente-name = 'WERKS'.
componente-type = datadescr.
APPEND componente TO componentes.

* Agora vamos criar nossa estrutura!
structdescr = cl_abap_structdescr=>get( componentes ).

* Mesmo esquema de sempre para poder acessá-la
CREATE DATA estrutura TYPE HANDLE structdescr.
ASSIGN estrutura->* TO <estrutura>.


*-- Criação da Tabela

* Ok, vamos criar essa tabela bunita. É claro que vamos utilizar o GET da
* clase CL_ABAP_TABLEDESCR. Notou que tudo no RTTS segue o mesmo padrão
* de funcionamento?

* O parâmetro obrigatório se chama P_LINE_TYPE. Podemos passar nossa estrutura!
tabledescr ?= cl_abap_tabledescr=>get( structdescr ).

CREATE DATA tabela TYPE HANDLE tabledescr.
ASSIGN tabela->* TO <tabela>.

* Você ainda pode dizer qual o tipo da tabela (SORTED, HASHED, STANDARD) e quais
* os campos chaves da sua tabela interna. Experimente fuçar no método "get".



*-- Preenchendo a tabela criada dinâmicamente

* Neste caso, eu coloquei o field-symbol como TYPE STANDARD TABLE. Isso me permite
* dar um APPEND da estrutura  pois eu criei a tabela interna da
*  forma default (que é STANDARD TABLE).

* Primeiro preechemos a estrutura:
ASSIGN COMPONENT 1 OF STRUCTURE <estrutura> TO <campo>.
<campo> = 'MATERIAL123'.

ASSIGN COMPONENT 2 OF STRUCTURE <estrutura> TO <campo>.
<campo> = 'SP01'.

* Depois é só dar o append!
APPEND <estrutura> TO <tabela>.

* Pare aqui no debug e veja a tabela criada de forma totalmente dinâmica, já
* preenchida com uma linha! :)
BREAK-POINT.
