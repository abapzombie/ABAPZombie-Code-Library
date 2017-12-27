* Chamando uma stored procedure

CALL 'C_DB_FUNCTION'
ID 'FUNCTION' FIELD 'DB_SQL'
ID 'FCODE'    FIELD 'EP'
ID 'PROCNAME' FIELD lv_nome_procedure
ID 'CONNAME'  FIELD lv_con_name
ID 'CONDA'    FIELD lv_conda
ID 'PARAMS'   FIELD lt_parametros
ID 'ROWCNT'   FIELD lv_contador_linhas
ID 'SQLCODE'  FIELD lv_sql_code
ID 'SQLMSG'   FIELD lv_sql_msg.

* Chamando uma função

CALL 'C_DB_FUNCTION'
ID 'FUNCTION'    FIELD 'DB_SQL'
ID 'FCODE'       FIELD 'PO'
ID 'STMT_STR'    FIELD lv_comando
ID 'CONNAME'     FIELD lv_con_name
ID 'CONDA'       FIELD lv_con_da
ID 'HOLD_CURSOR' FIELD lv_cursor
ID 'INVALS'      FIELD lt_valores
ID 'CURSOR'      FIELD lv_cursor
ID 'SQLCODE'     FIELD lv_sql_code
ID 'SQLMSG'      FIELD lv_sql_msg.


--------------------------------------------


CALL 'C_DB_EXECUTE'
ID 'STATLEN' FIELD lv_comprimento
ID 'STATTXT' FIELD lv_comando
ID 'SQLERR'  FIELD lv_erro.


--------------------------------------------

DATA v_value TYPE msxxlist-host.

CALL 'C_SAPGPARAM'
ID 'NAME'  FIELD 'SAPDBHOST'
ID 'VALUE' FIELD v_value.
