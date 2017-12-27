*----------------------------------------------------------------------*
*                     === ABAP ZOMBIE PRESENTS ===                     *
*----------------------------------------------------------------------*
*                      Selection Screen Examples                       *
*----------------------------------------------------------------------*
* Description -> Small code to handle characters removal in strings    *
* Date        -> Jan 21th, 2010                                        *
* SAP Version -> 6.0                                                   *
*----------------------------------------------------------------------*
* ABAP Zombie Staff: Mauricio Roberto Cruz                             *
*                    Mauro Cesar Laranjeira                            *
*----------------------------------------------------------------------*
* Please, visit us at http://abapzombie.blog.br/ and drop a Comment!   *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&  Include           ZAZ_REMOVE_CHARACTERS
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS lcl_converte_caracter DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_converte_caracter DEFINITION.

  PUBLIC SECTION.

    METHODS remove_char_mass IMPORTING value(char_remove) TYPE string
                                              no_blanks   TYPE c OPTIONAL
                                    CHANGING  string      TYPE string.

    METHODS remove_char_single IMPORTING value(char_remove) TYPE char1
                                    CHANGING string        TYPE string.


  PRIVATE SECTION.

ENDCLASS.                    "lcl_converte_caracter DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_converte_caracter IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_converte_caracter IMPLEMENTATION.

* Remove all special characters at once. They're all replaced by
* spaces (blanks can be removed using no_blanks).
*--------------------------------------------------------------------*
  METHOD remove_char_mass.

    DATA: l_pos_remove TYPE i,
          l_remove     TYPE string.

    CONDENSE char_remove NO-GAPS.

*   Create PATTERN to be used in translate
*   Special Characters will be turned into Spaces.
    WHILE l_pos_remove < STRLEN( char_remove ).

      CONCATENATE l_remove char_remove+l_pos_remove(1) space
             INTO l_remove
           RESPECTING BLANKS.
      ADD 1 TO l_pos_remove.

    ENDWHILE.

*   Remove all special characteres
    TRANSLATE string USING l_remove.

*   Check if blanks must stay.
    IF NOT no_blanks IS INITIAL.
      CONDENSE string NO-GAPS.
    ENDIF.

  ENDMETHOD.                    "remove_char_mass

* Removes the special character completely, leaving no blanks
*--------------------------------------------------------------------*
  METHOD remove_char_single.

    DATA: wa_result TYPE match_result.
    DATA: l_offset  TYPE i.

*   Remove the special character completely, leaving no blanks
    WHILE sy-subrc = 0.

      FIND char_remove IN string RESULTS wa_result.

      IF sy-subrc = 0.
        l_offset = wa_result-offset + 1.
        CONCATENATE string(wa_result-offset) string+l_offset
               INTO string.
      ENDIF.

    ENDWHILE.

  ENDMETHOD.                    "remove_char_single

ENDCLASS.                    "lcl_converte_caracter IMPLEMENTATION

*----------------------------------------------------------------------*
*                          === DISCLAIMER ===                          *
*----------------------------------------------------------------------*
* This code is made only for study and reference purposes. It was not  *
* copied from any running program and it does not make references      *
* to any functional requirement. All code here was created based on    *
* the authors experience and creativity! Enjoy!                        *
*----------------------------------------------------------------------*