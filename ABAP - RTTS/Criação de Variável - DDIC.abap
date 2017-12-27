DATA: datadescr TYPE REF TO cl_abap_datadescr.
DATA: variavel  TYPE REF TO data.

FIELD-SYMBOLS: <variavel> TYPE any.

* Pelo describe_by_name, conseguimos mostar qual elemento de dados
* o RTTS deve usar de referência para instanciar o objeto.
datadescr ?= cl_abap_datadescr=>describe_by_name( 'MATNR' ).

* Depois utilizamos o mesmo esquema para conseguir passar valor
* para a variável
CREATE DATA variavel TYPE HANDLE datadescr.
ASSIGN variavel->* TO <variavel>.

* Se a exit de conversão estiver ativa, você verá o output
* desse valor sem os zeros, afinal, o campo é um MATNR!
<variavel> = '000000000012345678'.
WRITE <variavel>.
