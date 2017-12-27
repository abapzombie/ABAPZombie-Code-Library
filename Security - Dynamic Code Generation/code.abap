REPORT  z_codigo_dinamico.

DATA: t_pool TYPE TABLE OF string,
      v_prog TYPE          string.

APPEND: 'PROGRAM pool.'                          TO t_pool,
        'FORM mensagem.'                         TO t_pool,
        '  WRITE / ''Código dinâmico chamado''.' TO t_pool,
        'ENDFORM.'                               TO t_pool.

GENERATE SUBROUTINE POOL t_pool NAME v_prog.

WRITE: 'Nome do programa gerado: ', v_prog.

PERFORM ('MENSAGEM') IN PROGRAM (v_prog) IF FOUND.