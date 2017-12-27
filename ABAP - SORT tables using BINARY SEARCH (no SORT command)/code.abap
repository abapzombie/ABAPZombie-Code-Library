REPORT zombie_manha_read_table.

* Types
TYPES: BEGIN OF ty_values,
        num TYPE numc5,
       END OF ty_values.

* Tables
DATA: t_desord TYPE TABLE OF ty_values,
      t_ord    TYPE TABLE OF ty_values.

* Work Areas
DATA: wa_val TYPE ty_values.

* Contador
DATA: v_count TYPE i.

*-- Vamos preencher a tabela com 10 linhas
DO 10 TIMES.
  ADD 1 TO v_count.
  wa_val-num = v_count.
  APPEND wa_val TO t_desord.
ENDDO.

* E agora, fazer com que os dados fiquem "desordenados" na T_DESORD
* ou seja, a ordenação vai ficar inversa, do maior para o menor
* O output na sequencia ficaria 10, 9, 8, 7, 6...
SORT t_desord BY num DESCENDING.

*-- E agora, vamos fazer com que a tabela t_ord fique ordenada,
*-- sem usar o comando SORT
LOOP AT t_desord INTO wa_val.

* Nos aproveitamos do algoritmo de busca binária, que sempre
* retorna o SY-TABIX de onde o registro deveria ser inserido caso
* o mesmo não exista!
  READ TABLE t_ord WITH KEY
    num = wa_val-num
  BINARY SEARCH
  TRANSPORTING NO FIELDS.

  IF sy-subrc <> 0.
*   Vamos inserir o danado onde ele deveria estar
    INSERT wa_val INTO t_ord INDEX sy-tabix.
  ENDIF.

ENDLOOP.

* E, magicamente, a ordenação ficou correta na T_ORD!
* 1, 2, 3, 4, 5, 6..