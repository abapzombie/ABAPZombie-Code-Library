*----------------------------------------------------------------------*
*                     === ABAP ZOMBIE PRESENTS ===                     *
*----------------------------------------------------------------------*
*                      Selection Screen Examples                       *
*----------------------------------------------------------------------*
* Description -> Simple TVARV Class, with code to handle the access    *
*                and range creation                                    *
* Date        -> Jan 20th, 2010                                        *
* SAP Version -> 6.0                                                   *
*----------------------------------------------------------------------*
* ABAP Zombie Staff: Mauricio Roberto Cruz                             *
*                    Mauro Cesar Laranjeira                            *
*----------------------------------------------------------------------*
* Please, visit us at http://abapzombie.blog.br/ and drop a Comment!   *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Include           ZAZ_TVARV
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS lcl_tvarv DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_tvarv DEFINITION.

* Public Section -> Methods that can be called by the program
*------------------------------------------------------------*
  PUBLIC SECTION.

    METHODS constructor IMPORTING prefix    TYPE string
                                  separator TYPE char1.

*   Get Single Values from TVARV
    METHODS get_parameter IMPORTING suffix TYPE string
                          EXPORTING value  TYPE any.

*   Get Ranges of Values from TVARV
    METHODS get_seloption IMPORTING suffix TYPE string
                          EXPORTING value TYPE STANDARD TABLE.

  PRIVATE SECTION.

*   Types
*-------------------------------------*
    TYPES: BEGIN OF ty_tvarvc.
    INCLUDE TYPE tvarvc.
    TYPES: prefix TYPE string,
           suffix  TYPE string.
    TYPES: END OF ty_tvarvc.

*   Variables
*--------------------------------------*
    DATA: t_val       TYPE TABLE OF ty_tvarvc,
          wa_val      LIKE LINE OF t_val,
          v_separator TYPE char1.


ENDCLASS.                    "lcl_tvarv DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_tvarv IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_tvarv IMPLEMENTATION.

  METHOD constructor.

*   Local Variables
    DATA: l_prefix TYPE string.

*   Field-Symbols
    FIELD-SYMBOLS: <fs_val> LIKE LINE OF t_val.

*   Create mask to get values from TVARV
    CONCATENATE prefix '%' INTO l_prefix.

*   Grab lines from TVARV. Note that fields must be explicited typed
*   due to ending fields of table T_VAL (fields SUFFIX / PREFIX)
    SELECT mandt name type numb sign opti low high clie_indep
      FROM tvarvc
      INTO TABLE t_val
      WHERE name LIKE l_prefix.

    IF sy-subrc <> 0.
*     Change this message to whatever you like
      MESSAGE i001(00) WITH 'Parâmetros de prefixo ' space prefix
                            ' não encontrados'.
      EXIT.
    ENDIF.

*   Create fields to be used by the other methods, using the
*   separator provided by the calling-program
    LOOP AT t_val ASSIGNING <fs_val>.

      SPLIT <fs_val>-name AT separator INTO <fs_val>-prefix
                                            <fs_val>-suffix.

    ENDLOOP.

    SORT t_val BY suffix type.

  ENDMETHOD.                    "CONSTRUCTOR

  METHOD get_parameter.

*   Get single value from TVARV
    READ TABLE t_val INTO wa_val WITH KEY
     suffix = suffix
     type   = 'P'
    BINARY SEARCH.

    IF sy-subrc <> 0.
*     Change this message to whatever you like
      MESSAGE i001(00) WITH 'Parâmetro '
                            suffix
                            ' não encontrado'.
      EXIT.
    ENDIF.

    value = wa_val-low.

  ENDMETHOD.                    "get_parameter

  METHOD get_seloption.

*   Data Types
    DATA: d_ref TYPE REF TO DATA.

*   Field Symbols
    FIELD-SYMBOLS: <fs_val>   TYPE ANY,
                   <fs_field> TYPE ANY.

*   Create range work area, based on the type from the calling-program
    CREATE DATA d_ref LIKE LINE OF value.
    ASSIGN d_ref->* TO <fs_val>.

*   Get select-options values from TVARV
    READ TABLE t_val INTO wa_val WITH KEY
     suffix = suffix
     type   = 'S'
    BINARY SEARCH.

    IF sy-subrc <> 0.
      MESSAGE i001(00) WITH 'Parâmetro '
                            suffix
                            ' não encontrado'.
    ENDIF.

*   Mount range dinamically
    LOOP AT t_val INTO wa_val FROM sy-tabix.

      IF wa_val-suffix <> suffix.
        EXIT.
      ENDIF.
*
      ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_val> TO <fs_field>.
      IF sy-subrc = 0.
        <fs_field> = wa_val-sign.
      ENDIF.

      ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_val> TO <fs_field>.
      IF sy-subrc = 0.
        <fs_field> = wa_val-opti.
      ENDIF.

      ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_val> TO <fs_field>.
      IF sy-subrc = 0.
        <fs_field> = wa_val-low.
      ENDIF.

      ASSIGN COMPONENT 'HIGH' OF STRUCTURE <fs_val> TO <fs_field>.
      IF sy-subrc = 0.
        <fs_field> = wa_val-high.
      ENDIF.

      APPEND <fs_val> TO value.

    ENDLOOP.

  ENDMETHOD.                    "get_seloption

ENDCLASS.                    "lcl_tvarv IMPLEMENTATION

*----------------------------------------------------------------------*
*                          === DISCLAIMER ===                          *
*----------------------------------------------------------------------*
* This code is made only for study and reference purposes. It was not  *
* copied from any running program and it does not make references      *
* to any functional requirement. All code here was created based on    *
* the authors experience and creativity! Enjoy!                        *
*----------------------------------------------------------------------*