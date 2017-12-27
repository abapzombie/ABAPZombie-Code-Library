" Declaração da variável
DATA: o_msg  TYPE REF TO cl_bsp_wd_message_service.

"Pega a instância singleton da classe que controla todas as mensagens no CRM
o_msg = cl_bsp_wd_message_service=>get_instance( ).

"Adiciona a mensagem na classe
o_msg->add_message( iv_msg_type       = 'S'
                    iv_msg_id         = 'ZCLASS'
                    iv_msg_number     = '000'
                    iv_msg_v1         = 'Parametro 1'
                    iv_msg_v2         = 'Parametro 2'
                    iv_msg_v3         = 'Parametro 3'
                    iv_msg_v4         = 'Parametro 4' ).