REPORT  zppbap_rfc_assincrona.
**********************************************************************
* VARIÁVEIS GLOBAIS (V_...)                                          *
**********************************************************************
DATA: v_tasks        TYPE i,
      v_task_id      TYPE numc2,
      v_task_count   TYPE i,
      v_task_ativa   TYPE i.

**********************************************************************
* TABELA INTERNA (T_...)                                             *
**********************************************************************
DATA: t_bseg      TYPE TABLE OF bseg,
      t_bseg_aux  TYPE TABLE OF bseg.

**********************************************************************
* TABELA                                                             *
**********************************************************************
TABLES: bseg.

**********************************************************************
* PARÂMETROS DE TELA:                                                *
*   SELECT OPTIONS (S_...)                                           *
*   PARAMETERS     (P_...)                                           *
**********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.

SELECT-OPTIONS: s_gjahr FOR bseg-gjahr OBLIGATORY NO INTERVALS. "Ano
* Obs. Estou utilizando apenas como chave o campo GJAHR, pois o ambiente
* que estou fazendo testes não possui muitos registros

SELECTION-SCREEN END OF BLOCK b1.

**********************************************************************
* START-OF-SELECTION                                                 *
**********************************************************************
START-OF-SELECTION.
  DATA: wa_gjahr LIKE LINE OF s_gjahr.

* Obter o número de sessões disponíveis
  CALL FUNCTION 'SPBT_INITIALIZE'
    IMPORTING
      free_pbt_wps                   = v_tasks
    EXCEPTIONS
      invalid_group_name             = 1
      internal_error                 = 2
      pbt_env_already_initialized    = 3
      currently_no_resources_avail   = 4
      no_pbt_resources_found         = 5
      cant_init_different_pbt_groups = 6
      OTHERS                         = 7.

  IF sy-subrc <> 0.
*** Mensagem de erro
    LEAVE LIST-PROCESSING.
  ENDIF.

* Para cada ano informado na tela de seleção, será chamada a RFC
  LOOP AT s_gjahr INTO wa_gjahr.

* Como não sabemos a quantidade de registros, devemos controlar quantas sessões serão geradas
    DO.

* Incrementar ao contador de sessões ativas
      ADD 1 TO v_task_ativa.

* Verificar se o número de sessões ativas está dentro do limite
      IF v_task_ativa <= v_tasks.

* Cada sessão deverá ter um ID único
        ADD 1 TO v_task_id.

* Chamar a RFC em uma nova sessão
        CALL FUNCTION 'Z_RFC_ASSINC'
          STARTING NEW TASK v_task_id
          DESTINATION IN GROUP DEFAULT
          PERFORMING update_order ON END OF TASK
          EXPORTING
            i_gjahr = wa_gjahr-low
          EXCEPTIONS
            OTHERS  = 1.

        IF sy-subrc <> 0.
* Se a RFC falhar, vamos tentar novamente e diminuir o número de sessões ativas. Cuidado para não entrar
* em loop infinito!!
          SUBTRACT 1 FROM v_task_ativa.
        ELSE.
          EXIT.
        ENDIF.
      ELSE.
        SUBTRACT 1 FROM v_task_ativa.
      ENDIF.
    ENDDO.
  ENDLOOP.

  IF sy-subrc IS INITIAL.
* Esperar até que todas as sessões sejam finalizadas. O número é decrementado na subrtoina abaixo
* e incrementado quando a RFC é chamada.
    WAIT UNTIL v_task_ativa = 0.

*** Neste ponto você poderá utilizar os resultados retornados da RFC para continuar a lógica do programa

  ENDIF.

**********************************************************************
* SUBROTINA                                                          *
**********************************************************************
FORM update_order USING name.

* Obter os resultados da RFC
  RECEIVE RESULTS FROM FUNCTION 'Z_RFC_ASSINC'
     TABLES
      t_bseg       = t_bseg_aux.

  APPEND LINES OF t_bseg_aux TO t_bseg.

  SUBTRACT 1 FROM v_task_ativa.

ENDFORM.                    " UPDATE_ORDER