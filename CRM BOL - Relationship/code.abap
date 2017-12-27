*** Objetos
  DATA: lo_entity        TYPE REF TO cl_crm_bol_entity,
        lo_header_status TYPE REF TO if_bol_entity_col,
        lo_header_stat   TYPE REF TO cl_crm_bol_entity,
        lo_status_curr   TYPE REF TO if_bol_entity_col,
        lo_status        TYPE REF TO cl_crm_bol_entity.

***Estruturas
  DATA: lwa_admin_h      TYPE crmt_orderadm_h_wrk,
        lwa_status       TYPE crmst_status_btil.

* Obtém o AdminH-Entity com os dados do header do documento
  lo_entity ?= me->typed_context->btadminh->collection_wrapper->get_current( ).

  IF lo_entity IS BOUND.

* Busca a primeira relação de Status
    lo_header_status = lo_entity->get_related_entities(
                                      iv_relation_name = 'BTHeaderStatusSet' ).

    IF lo_header_status IS BOUND.

      lo_header_stat   = lo_header_status->get_first( ).

*     Busca a segunda relação, obtendo então o objeto com os dados que desejamos
      lo_status_curr = lo_header_stat->get_related_entities(
                                           iv_relation_name = 'BTStatusHCurrent' ).

      IF lo_status_curr IS BOUND.

        lo_status      = lo_status_curr->get_first( ).

        IF lo_status IS BOUND.

*         Obtém os valores de status existente no objeto atribuindo-os a estrutura
          lo_status->get_properties( IMPORTING
                                         es_attributes = lwa_status ).

          IF NOT lwa_status IS INITIAL AND
*** Agora chegamos as informações de status, então fica fácil basta dar
*** continuidade a lógica aqui e ser feliz =D
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.