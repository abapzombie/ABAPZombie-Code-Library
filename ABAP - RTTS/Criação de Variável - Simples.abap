DATA: elemdescr TYPE REF TO cl_abap_elemdescr.

DATA: variavel  TYPE REF TO data.

FIELD-SYMBOLS <char> TYPE any.

* Criando uma variável CHAR de 18 posições.
elemdescr = cl_abap_elemdescr=>get_c( 18 ).

* Aqui a magia do TYPE HANDLE entra em ação. Ele foi
* feito especialmente para funcionar com as classes do RTTS
* O comando abaixo quer dizer:
* CRIE uma variavel DO TIPO dessa classe rtts.
CREATE DATA variavel TYPE HANDLE elemdescr.

* Você não vai conseguir fazer mta coisa com a variável type ref to data.
* Precisamos utilizar um fieldsymbol para manipular o valor.
ASSIGN variavel->* TO <char>.

* Sao 18 posicoes, então o 9 teria que ser cortado.
* Teste e veja se o output está correto!
<char> = '1234567890123456789'.
WRITE <char>.
