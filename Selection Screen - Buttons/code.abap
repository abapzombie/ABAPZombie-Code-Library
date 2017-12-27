REPORT z_teste_botao.

* Estrutura necessária para manipulação do elemento na Tela
*----------------------------------------------------------
TABLES: sscrfields.

* Type Pools com os Ícones (duplo clique para visualiza-los)     
*----------------------------------------------------------
TYPE-POOLS: icon.

* Declaração do Botão
* Você pode utilizar da função 1 até a função 5
* O atalho será Ctrl+Fx onde X é o número da Function Key
*--------------------------------------------------------
SELECTION-SCREEN: FUNCTION KEY 1. "Declaração do Botão

* O Botão por sí só não faz uma tela de seleção.
* Outros elementos de tela devem existir, e o botão irá aparecer ao lado
* do botão executar.
*-----------------------------------------------------------------------
PARAMETERS: p_dummy TYPE char10.

* Descrevendo o botão no evento Initialization
*---------------------------------------------
INITIALIZATION.

 PERFORM cria_botao.

* Manipualação do Botão
*----------------------
AT SELECTION-SCREEN.

 IF sy-ucomm = 'FC01'.
 BREAK-POINT.
 ENDIF.

*&---------------------------------------------------------------------*
*&      Form  cria_botao
*&---------------------------------------------------------------------*
FORM cria_botao .

*  Estrutura para descrever o botão
 DATA: wa_button TYPE smp_dyntxt.

*  Nome do Botão
 wa_button-text      = 'Botao Log de Erros'.

*  Ícone do Botão
 wa_button-icon_id   = icon_error_protocol.

*  Texto que aparecerá ao lado do ícone (pode ser vazio)
 wa_button-icon_text = 'Log de Erros'.

*  Quickinfo (aparece quando o user passar o mouse sobre o botao)
 wa_button-quickinfo = 'Visualizar Log de Erros'.

*  Associa essas propriedades com a função 1
 sscrfields-functxt_01 = wa_button.

ENDFORM.                    " cria_botao