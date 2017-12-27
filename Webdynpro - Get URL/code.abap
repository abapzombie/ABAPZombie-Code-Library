DATA: it_param TYPE tihttpnvp.

DATA: wa_param TYPE ihttpnvp.

DATA: l_url     TYPE string,
      l_url_c   TYPE char255.


"Parametros
wa_param-name = 'PARAM_1'.
wa_param-value = 'valor1'.
APPEND wa_param TO it_param.

wa_param-name = 'PARAM_2'.
wa_param-value = 'valor2'.
APPEND wa_param TO it_param.


"Criação da URL para a chamada WebDynpro
cl_wd_utilities=>construct_wd_url( EXPORTING 
                                     application_name           = 'Z_APLLICACAO'
                                     in_parameters              = it_param
                                   IMPORTING 
                                     out_absolute_url = l_url ).

l_url_c = l_url.


"Abri a aplicação webdynpro
CALL FUNCTION 'CALL_BROWSER'
  EXPORTING
    url = l_url_c.