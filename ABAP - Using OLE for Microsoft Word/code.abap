REPORT  zombie_teste_ole.
* Types-Pools
*-------------------------------------*
TYPE-POOLS: ole2.

* Variables
*--------------------------------------*
DATA: v_word_app TYPE ole2_object, "Word Application
v_documents TYPE ole2_object, "Documentos
v_document TYPE ole2_object, "Documento
v_selection TYPE ole2_object, "Linha de texto
v_paragraph TYPE ole2_object, "Paragrafo (Alinhamento)
v_font TYPE ole2_object. "Font (Cor, Tamanho, Fonte)

"Cria o Application do Word
CREATE OBJECT v_word_app 'WORD.APPLICATION'.

"Documento será aberto após criação?
SET PROPERTY OF v_word_app 'Visible' = '1' .

"Cria a sessão de documentos
CALL METHOD OF v_word_app 'Documents' = v_documents.

"Cria um documento dentro da sessão de documentos
CALL METHOD OF v_documents 'Add' = v_document.

"Cria uma entrada de texto
CALL METHOD OF v_word_app 'Selection' = v_selection.

"Cria um paragrafo dentro da entrada de texto
CALL METHOD OF v_selection 'ParagraphFormat' = v_paragraph.

"Cria um font dentro da entrada de texto
CALL METHOD OF v_selection 'Font' = v_font.

"Insere o alinhamento do paragrafo
SET PROPERTY OF v_paragraph 'Alignment' = '2' . "Right-justified

"Altera os atributos da fonte
SET PROPERTY OF v_font 'Name' = 'Arial' .
SET PROPERTY OF v_font 'Size' = '50' .
SET PROPERTY OF v_font 'Bold' = '0' . "Not bold
SET PROPERTY OF v_font 'Italic' = '1' . "Italic

"Insere o Texto
CALL METHOD OF v_selection 'TypeText'
EXPORTING #1 = 'AbapZombie.com!'.

"Salva o Documento
CALL METHOD OF v_document 'SaveAs'
EXPORTING
#1 = 'C:/example/abapzombie.ole.doc'.