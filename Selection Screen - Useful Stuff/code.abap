REPORT  z_adicionais_zombie.

* Vamos começar a nos divertir hehe :D
* Ah, e boa parte dessas coisas você vê no HELP (F1).
*----------------------------------------------

SELECTION-SCREEN BEGIN OF BLOCK bl01 WITH FRAME.

*------> Pular Linhas
PARAMETER: p_pula  TYPE char10.
SELECTION-SCREEN SKIP 1. "Podem ser X linhas
PARAMETER: p_pulou TYPE char10.
SELECTION-SCREEN SKIP 2.

*-------> Comentário
SELECTION-SCREEN COMMENT /1(50) comment.
SELECTION-SCREEN SKIP 1.

*-------> Botão para apertar (apertar = clicar hehe)
SELECTION-SCREEN  PUSHBUTTON /2(13) botao USER-COMMAND click.
SELECTION-SCREEN SKIP 1.

*-------> Linha Horizontal
SELECTION-SCREEN ULINE. "mesmo esquema do WRITE
SELECTION-SCREEN SKIP 1.

*-------> ListBox (ele puxa os valores do domínio)
PARAMETERS: p_listb   TYPE MARA-MTART
                      AS LISTBOX VISIBLE LENGTH 10.

SELECTION-SCREEN END OF BLOCK bl01.

*----------------------------------------------------------
* Vou criar outra tela de seleção, igual a de cima!
* Escrever tudo denovo? Pra que?
SELECTION-SCREEN BEGIN OF SCREEN 9000 AS WINDOW.

*-------> Incluir uma tela de seleção em outras
SELECTION-SCREEN INCLUDE BLOCKS bl01.
* Dá pra fazer só com parameters ou só com select-options
* aperte F1 no INCLUDE ali pra ver!

SELECTION-SCREEN END OF SCREEN 9000.

*--------------------------------------
INITIALIZATION.

* Texto do Comentário
  comment = 'Eu sou um comentário, duh'.
* Texto do Botão
  botao = 'Click Me!'.

*--------------------------------------
AT SELECTION-SCREEN.

* Clicou no botao!
  IF sy-ucomm = 'CLICK'.
*   E com isso, você pode chamar a mesma tela como pop-up X vezes
*   (até o sap não aguentar e dar uns problemas malucos!).
    CALL SELECTION-SCREEN 9000 STARTING AT 5 5.
  ENDIF.