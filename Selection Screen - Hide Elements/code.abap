REPORT  z_mudatela_zombie.

TABLES: mara.

* Vamos controlar a mudança de tela através de dois radiobuttons
*---------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK bl01 WITH FRAME.

* É importante colocar o user-command aqui, pois sem ele o report não
* irá passar pelo evento AT SELECTION SCREEN OUTPUT quando o user
* clicar em qualquer um dos radio buttons. É um pseudo-gato ;)
* Também tem que deixar o DEFAULT, senão o radio button não chega
* com o X marcado na primeira visualização da tela! :(
*---------------------------------------------------------------------
PARAMETERS: rb_tela1 RADIOBUTTON GROUP rb01 USER-COMMAND muda_tela
                                                  DEFAULT 'X',
            rb_tela2 RADIOBUTTON GROUP rb01.

SELECTION-SCREEN END OF BLOCK bl01.

* Tela com Select Options.
* O MODIF ID deve ser o MESMO para todos os elementos da tela
*------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK bl02 WITH FRAME.

SELECT-OPTIONS: s_matnr FOR mara-matnr MODIF ID t1,
                s_mtart FOR mara-mtart MODIF ID t1.

SELECTION-SCREEN END OF BLOCK bl02.

* Tela com Parameters.
* O MODIF ID deve ser o MESMO para todos os elementos da tela
*------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK bl03 WITH FRAME.

PARAMETERS: p_matnr TYPE mara-matnr MODIF ID t2,
            p_mtart TYPE mara-mtart MODIF ID t2.

SELECTION-SCREEN END OF BLOCK bl03.

* Evento que irá controlar a mudança da tela. Lembre-se que
* é necessário o USER-COMMAND nos RadioButtons para o Report passar
* por aqui!
*------------------------------------------------------------------
AT SELECTION-SCREEN OUTPUT.

  PERFORM modifica_tela.

*&---------------------------------------------------------------*
*&      Form  MODIFICA_TELA
*&---------------------------------------------------------------*
FORM modifica_tela .

* O MODIF ID deixa o objeto "Modificavel" na tela de seleção.
* Vamos usar um Loop at Screen para modificá-la.
*------------------------------------------------------------
  LOOP AT SCREEN.

*   Se o user quiser telas com parametros
*------------------------------------------------------------------
    IF rb_tela1 = 'X'.

*     Dentro do campo GROUP1 vai ficar o valor do MODIF ID.
*     Daí é só tratar os atributos do elemento como necessário

*     Esconde Tela com Parameters
*--------------------------------
      IF screen-group1 = 'T2'.
        screen-invisible = 1.
        screen-input     = 0.
        screen-active    = 0.
        MODIFY SCREEN.
        CONTINUE.
      ENDIF.

*     Mostra tela com Select Options
*-----------------------------------
      IF screen-group1 = 'T1'.
        screen-invisible = 0.
        screen-input     = 1.
        screen-active    = 1.
        MODIFY SCREEN.
        CONTINUE.
      ENDIF.

    ELSE.

*     Esconde tela com Select Options
*-------------------------------------
      IF screen-group1 = 'T1'.
        screen-invisible = 1.
        screen-input     = 0.
        screen-active    = 0.
        MODIFY SCREEN.
        CONTINUE.
      ENDIF.

*     Mostra tela com Parameters
*--------------------------------
      IF screen-group1 = 'T2'.
        screen-invisible = 0.
        screen-input     = 1.
        screen-active    = 1.
        MODIFY SCREEN.
        CONTINUE.
      ENDIF.

    ENDIF.
  ENDLOOP.

ENDFORM.                    " MODIFICA_TELA