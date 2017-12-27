DATA: estrutura TYPE REF TO data.

FIELD-SYMBOLS: <estrutura> TYPE any,
               <campo>     TYPE any.

DATA: structdescr TYPE REF TO cl_abap_structdescr.

* O get da CL_ABAP_STRUCTDESCR tem um paramêtro chamado "P_COMPONENTS".
* Não precisa ser nenhum PhD para entender o que precisamos fazer..
DATA: componentes TYPE abap_component_tab,
      componente  LIKE LINE OF componentes.

* A importância de entender o RTTS por "etapas" como estamos fazendo
* vem agora. A estrutura de componentes tem um campo chamado "TYPE", que
* aceita um objeto do tipo CL_ABAP_DATADESCR. Nós já aprendemos como
* criar objetos que fazem referência a variáveis, certo? Então vamos
* montar nossa estrutura!

DATA: datadescr TYPE REF TO cl_abap_datadescr,
      elemdescr TYPE REF TO cl_abap_elemdescr.

* Criando um campo CHAR de 10
elemdescr = cl_abap_elemdescr=>get_c( 10 ).
componente-name = 'CHAR_DE_10'.
componente-type = elemdescr.
APPEND componente TO componentes.

* Criando um campo para a planta, com o elemento de dados WERKS_D
datadescr ?= cl_abap_datadescr=>describe_by_name('WERKS_D').
componente-name = 'WERKS'.
componente-type = datadescr.
APPEND componente TO componentes.

* Agora vamos criar nossa estrutura!
structdescr = cl_abap_structdescr=>get( componentes ).

* Mesmo esquema de sempre para poder acessá-la
CREATE DATA estrutura TYPE HANDLE structdescr.
ASSIGN estrutura->* TO <estrutura>.

* Porem para acessar os campos e preenche-los, vamos utilizar o
* ASSIGN COMPONENT utilizando um índice para indicar qual o campo
* que queremos acessar
ASSIGN COMPONENT 1 OF STRUCTURE <estrutura> TO <campo>.
<campo> = '1234567890'.

ASSIGN COMPONENT 2 OF STRUCTURE <estrutura> TO <campo>.
<campo> = '3000'.

* Pare aqui no debug e veja os valores preenchidos em <estrutura> :)
BREAK-POINT.
