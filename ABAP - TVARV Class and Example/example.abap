REPORT z_tvarv.

* Essa é a include que contém a classe de acesso à TVARV
INCLUDE zaz_tvarv.

* Parametro e Range de Exemplo
DATA: p_param TYPE char10.
DATA: r_range TYPE RANGE OF char10.

* Objeto da TVARV
DATA: o_tvarv TYPE REF TO lcl_tvarv.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

* Aqui estamos criando o Objeto e acessando a TVARV.
* PREFIX: valor que vem antes do separador. Exemplo: em GAP1-VARIAVEL1
*         o valor de PREFIX seria GAP1, pois todas as variáveis devem
*         iniciar com GAP1 para o programa GAP1.
* SEPARATOR: O Separador. Não precisa de exemplo né? :P
*-----------------------------------------------------------*
  CREATE OBJECT o_tvarv
    EXPORTING
      prefix    = 'AUDI' "Exemplo de Prefixo
      separator = '_'.

* Busca Valor de um paraâmetro simples.
  o_tvarv->get_parameter(
   EXPORTING
     suffix = 'KONTENPLAN' "Sufixo qualquer de Parâmetro
   IMPORTING
     value  = p_param ).

* Busca os Valor de um SelOption da TVARV, e ainda monta o range.
* Agora ficou fácil :D
  o_tvarv->get_seloption(
   EXPORTING
     suffix = 'KONTENPLAN' "Sufixo qualquer de Select Option
   IMPORTING
     value = r_range ).