

 " Declaração da variável do tipo da classe que controla o alert modeler
  DATA: o_alert TYPE REF TO cl_crm_ic_5x_ext_alert_srv.

  "Pega a instancia do Alert Modeler
  o_alert ?= cl_crm_ic_5x_ext_alert_srv=>if_crm_ic_5x_ext_alert_srv~get_instance( ).

  "Insere o texto no Alert Modeler
  o_alert->if_crm_ic_5x_ext_alert_srv~trigger_alert( iv_message = 'Teste de alert' ).