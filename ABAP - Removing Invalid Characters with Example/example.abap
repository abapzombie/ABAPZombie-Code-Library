REPORT  z_caracteres_zumbis.

* Aqui vai a include mágica
INCLUDE zaz_remove_characters.

* Objeto da Classe para remoção de caracteres
DATA o_conv TYPE REF TO lcl_converte_caracter.

* String qualquer
DATA v_string  TYPE string.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

* Instânciando a classe
  CREATE OBJECT o_conv.

* String zuadassa!
  v_string = 'a;b@a#p$z%o^m>b:i-e!'.

* Removendo todos os caracteres e todos os espaços
  o_conv->remove_char_mass( EXPORTING
                             char_remove = ';@#$%^>:-'
                             no_blanks   = 'X'
                            CHANGING
                             string      = v_string ).

* Aqui vai ficar "abapzombie!"
  WRITE v_string.

* Zuando a string denovo!
  v_string = 'a#b#a#p# z#o#m#b#i#e!'.

* Vamos remover o #, e somente os espaços onde eles estavam
  o_conv->remove_char_single( EXPORTING
                               char_remove = '#'
                              CHANGING
                               string      = v_string ).

* Aqui vai ficar "abap zombie!"
  WRITE v_string.