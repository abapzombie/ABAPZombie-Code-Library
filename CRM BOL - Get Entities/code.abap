DATA: o_controller  TYPE REF TO cl_crmcmp_b_cucobupa_impl,
      o_entity      TYPE REF TO cl_crm_bol_entity.

o_controller ?= me->get_custom_controller( 'GLOBAL.CRMCMP_BPIDENT/CuCoBuPa' ).

o_entity ?= o_controller->typed_context->customers->collection_wrapper->get_current( ).