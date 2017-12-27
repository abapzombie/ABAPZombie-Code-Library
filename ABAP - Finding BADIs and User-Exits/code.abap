REPORT z_enhancement_finder NO STANDARD PAGE HEADING LINE-SIZE 201.

TABLES :  tstc,
          tadir,
          modsapt,
          modact,
          trdir,
          tfdir,
          enlfdir,
          sxs_attrt ,
          tstct.

DATA : jtab LIKE tadir OCCURS 0 WITH HEADER LINE.
DATA : field1(30).
DATA : v_devclass LIKE tadir-devclass.

PARAMETERS : p_tcode LIKE tstc-tcode,
p_pgmna LIKE tstc-pgmna .

DATA wa_tadir TYPE tadir.

START-OF-SELECTION.

  IF NOT p_tcode IS INITIAL.
    SELECT SINGLE * FROM tstc WHERE tcode EQ p_tcode.

  ELSEIF NOT p_pgmna IS INITIAL.
    tstc-pgmna = p_pgmna.
  ENDIF.

  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM tadir
    WHERE pgmid = 'R3TR'
    AND object = 'PROG'
    AND obj_name = tstc-pgmna.

    MOVE : tadir-devclass TO v_devclass.

    IF sy-subrc NE 0.
      SELECT SINGLE * FROM trdir
      WHERE name = tstc-pgmna.
      IF trdir-subc EQ 'F'.
        SELECT SINGLE * FROM tfdir
        WHERE pname = tstc-pgmna.

        SELECT SINGLE * FROM enlfdir
        WHERE funcname = tfdir-funcname.

        SELECT SINGLE * FROM tadir
        WHERE pgmid = 'R3TR'
        AND object = 'FUGR'
        AND obj_name EQ enlfdir-area.

        MOVE : tadir-devclass TO v_devclass.
      ENDIF.
    ENDIF.

    SELECT * FROM tadir INTO TABLE jtab
    WHERE pgmid = 'R3TR'
    AND object IN ('SMOD', 'SXSD')
    AND devclass = v_devclass.

    SELECT SINGLE * FROM tstct
    WHERE sprsl EQ sy-langu
    AND tcode EQ p_tcode.

    FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
    WRITE:/(19) 'Transaction Code - ',
    20(20) p_tcode,
    45(50) tstct-ttext.
    SKIP.
    IF NOT jtab[] IS INITIAL.
      WRITE:/(105) sy-uline.
      FORMAT COLOR COL_HEADING INTENSIFIED ON.

*      sorting the internal table
      SORT jtab BY object.
      DATA : wf_txt(60) TYPE c,
      wf_smod TYPE i ,
      wf_badi TYPE i ,
      wf_object2(30) TYPE c.
      CLEAR : wf_smod, wf_badi , wf_object2.

*GET the total smod.
      LOOP AT jtab INTO wa_tadir.
        AT FIRST.
          FORMAT COLOR COL_HEADING INTENSIFIED ON.

          WRITE:/1 sy-vline,
          2 'Enhancement/ Business Add-in',
          41 sy-vline ,
          42 'Description',
          105 sy-vline.
          WRITE:/(105) sy-uline.
        ENDAT.
        CLEAR wf_txt.
        AT NEW object.
          IF wa_tadir-object = 'SMOD'.
            wf_object2 = 'Enhancement' .
          ELSEIF wa_tadir-object = 'SXSD'.
            wf_object2 = ' Business Add-in'.

          ENDIF.
          FORMAT COLOR COL_GROUP INTENSIFIED ON.

          WRITE:/1 sy-vline,

          2 wf_object2,
          105 sy-vline.
        ENDAT.

        CASE wa_tadir-object.
          WHEN 'SMOD'.
            wf_smod = wf_smod + 1.
            SELECT SINGLE modtext INTO wf_txt
            FROM modsapt
            WHERE sprsl = sy-langu
            AND name = wa_tadir-obj_name.
            FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

          WHEN 'SXSD'.
*        for badis
            wf_badi = wf_badi + 1 .
            SELECT SINGLE text INTO wf_txt
            FROM sxs_attrt
            WHERE sprsl = sy-langu
            AND exit_name = wa_tadir-obj_name.
            FORMAT COLOR COL_NORMAL INTENSIFIED ON.
        ENDCASE.

        WRITE:/1 sy-vline,
        2 wa_tadir-obj_name HOTSPOT ON,
        41 sy-vline ,
        42 wf_txt,
        105 sy-vline.
        AT END OF object.
          WRITE : /(105) sy-uline.
        ENDAT.
      ENDLOOP.

      WRITE:/(105) sy-uline.

      SKIP.
      FORMAT COLOR COL_TOTAL INTENSIFIED ON.
      WRITE:/ 'No.of Exits:' , wf_smod.
      WRITE:/ 'No.of BADis:' , wf_badi.

    ELSE.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED ON.
      WRITE:/(105) 'No userexits or BADis exist'.
    ENDIF.
  ELSE.
    FORMAT COLOR COL_NEGATIVE INTENSIFIED ON.
    WRITE:/(105) 'Transaction does not exist'.
  ENDIF.

AT LINE-SELECTION.

  DATA : wf_object TYPE tadir-object.
  CLEAR wf_object.

  GET CURSOR FIELD field1.
  CHECK field1(8) EQ 'WA_TADIR'.
  READ TABLE jtab WITH KEY obj_name = sy-lisel+1(20).
  MOVE jtab-object TO wf_object.

  CASE wf_object.
    WHEN 'SMOD'.
      SET PARAMETER ID 'MON' FIELD sy-lisel+1(10).

      CALL TRANSACTION 'SMOD' AND SKIP FIRST SCREEN.
    WHEN 'SXSD'.
      SET PARAMETER ID 'EXN' FIELD sy-lisel+1(20).
      CALL TRANSACTION 'SE18' AND SKIP FIRST SCREEN.
  ENDCASE.