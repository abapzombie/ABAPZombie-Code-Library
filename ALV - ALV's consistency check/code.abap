REPORT zaz_consistencia_alv.

* Objetos Para Referencia
DATA: o_alv    TYPE REF TO cl_gui_alv_grid,
      o_cont   TYPE REF TO cl_gui_docking_container,
      o_parent TYPE REF TO cl_gui_container.

* Tabela com os dados Mestres
DATA: t_flight TYPE TABLE OF sflight.

*----> Classe para tratar o evento de Duplo Clique do ALV

*----------------------------------------------------------------------*
*       CLASS lcl_event DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event DEFINITION.

  PUBLIC SECTION.
    METHODS handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid.

ENDCLASS.                    "lcl_event DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_event IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event IMPLEMENTATION.

  METHOD handle_double_click.

*   Declarações do Método
    DATA: t_fcat TYPE lvc_t_fcat,
          wa_layout TYPE lvc_s_layo,
          v_variant TYPE disvariant,
          v_save TYPE char1.

*   Busca os valores do ALV que está sendo exibido
    o_alv->get_frontend_fieldcatalog( IMPORTING
                                       et_fieldcatalog = t_fcat ).

    o_alv->get_frontend_layout( IMPORTING
                                 es_layout = wa_layout ).

    o_alv->get_variant( IMPORTING
                          es_variant = v_variant
                          e_save     = v_save ).

*   Função que mostra a consistência do seu ALV
    CALL FUNCTION 'ALV_CONSISTENCY_CHECK'
      EXPORTING
        i_save     = v_save
        is_layo    = wa_layout
        is_variant = v_variant
        it_fcat    = t_fcat
        it_outtab  = t_flight.

  ENDMETHOD.                    "handle_double_click

ENDCLASS.                    "lcl_event IMPLEMENTATION

* Esta declaração deve ficar após a declaração da Classe Local
DATA:  o_event  TYPE REF TO lcl_event.

*--------------------------------------------------------------------*
* Evento START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

* Eu utilizei a SFLIGHT pois ela normalmente é usada nos exemplos dos
* programas de exemplo de ALVs (BCALV* na SE38) Se você quiser
* pode trocar para outra tabela.
  SELECT * FROM sflight INTO TABLE t_flight.

* Crie essa tela e descomente o módulo status_9000 OUTPUT.
  CALL SCREEN 9000.

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.

* Técnica para você não ter que desenhar o container na tela nova
* Essa classe cria o container pra você, e depois nós referenciamos
* estre container para o objeto do ALV OO.

* Cria o Container para a tela do ALV
  CREATE OBJECT o_cont
    EXPORTING
      side      = cl_gui_docking_container=>dock_at_top
      repid     = sy-repid
      dynnr     = '9000'
      extension = 1000
    EXCEPTIONS
      OTHERS    = 6.

* Casting para o tipo genério
  o_parent = o_cont.

* Criia Instância do ALV, referenciando o Container gerado acima
  CREATE OBJECT o_alv
    EXPORTING
      i_parent = o_parent.

* Registra tratamento do Evento de Duplo Clique
  CREATE OBJECT o_event.
  SET HANDLER o_event->handle_double_click FOR o_alv.

* Exibe o ALV
  CALL METHOD o_alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      it_outtab        = t_flight.

ENDMODULE.                 " STATUS_9000  OUTPUT