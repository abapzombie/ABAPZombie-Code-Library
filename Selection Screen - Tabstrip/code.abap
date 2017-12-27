REPORT z_tabstrip_zombie.

TABLES: mara.

* Começamos definindo um "Tabbed Block" na tela de seleção.
* O nome T1 é um nome genérico, por o número de linhas define
* quantas linhas o seu tabstrip vai ocupar na tela
*------------------------------------------------------
SELECTION-SCREEN BEGIN OF TABBED BLOCK t1 FOR 10 LINES.

* Você deve direcionar uma subscreen para cada uma das abas do seu
* tabstrip. Pontos importantes:
* USER-COMMAND -  ação gerada no sy-ucomm quando o user clicar no tab
* DEFAUL SCREEN - deve ser direcionado para uma subscreen
* Os nomes 'tab1' 'tab2' etc irão virar variáveis, e você deve atribuir
* o nome da aba nessa variável (ver no evento INITIALIZATION).
*------------------------------------------------------------------------
SELECTION-SCREEN TAB (20) tab1 USER-COMMAND tab1 DEFAULT SCREEN 101.
SELECTION-SCREEN TAB (20) tab2 USER-COMMAND tab2 DEFAULT SCREEN 102.
SELECTION-SCREEN TAB (20) tab3 USER-COMMAND tab3 DEFAULT SCREEN 103.

SELECTION-SCREEN END OF BLOCK t1.

* Subscreen 101. Declare itens como se fosse uma tela comum.
*-----------------------------------------------------------
SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
PARAMETER p_dummy TYPE char10.
SELECTION-SCREEN END OF SCREEN 101.

* Subscreen 102.
*-----------------------------------------------------------
SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
SELECT-OPTIONS p_dummy2 FOR mara-matnr.
SELECTION-SCREEN END OF SCREEN 102.

* Subscreen 103.
*-----------------------------------------------------------
SELECTION-SCREEN BEGIN OF SCREEN 103 AS SUBSCREEN.
PARAMETERS: p_dummy3 RADIOBUTTON GROUP rb01,
            p_dummy4 RADIOBUTTON GROUP rb01.
SELECTION-SCREEN END OF SCREEN 103.

* No evento INITIALIZATION você deve atribuir os nomes das abas.
* As variáveis terão os nomes declarados no SELECTION SCREEN TAB
*---------------------------------------------------------------
INITIALIZATION.
  tab1 = 'Tab 1'.
  tab2 = 'Tab 2'.
  tab3 = 'Tab 3'.

* Exemplo do SY-UCOMM. O programa vai parar no debug qdo clicarem
* na terceira aba do tabstrip
*----------------------------------------------------------------
AT SELECTION-SCREEN.
  IF sy-ucomm = 'TAB3'.
    BREAK-POINT.
  ENDIF.