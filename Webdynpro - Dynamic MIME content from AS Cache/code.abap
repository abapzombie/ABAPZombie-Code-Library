DATA: lv_hora_expiracao TYPE timestamp,
      lv_comp              TYPE        i,
      lv_timestamp         TYPE        timestamp,
      lv_tp_conteudo       TYPE        string,
      lv_content_type      TYPE        string,
      lo_cached_response   TYPE REF TO if_http_response,
      lv_conteudo          TYPE        xstring,
      lv_url               TYPE        string,
      lv_nome_arquivo      TYPE        string,
      lv_expires_abs_date  TYPE        d,
      lv_expires_abs_time  TYPE        t,
      lv_guid              TYPE        guid_32.

* Antes de começar o processo, verificamos se o conteúdo que já foi
* colocado anteriormente no cache ainda está válido. Se ainda estiver
* válido, não é preciso fazer um novo upload.
IF NOT lv_hora_expiracao IS INITIAL.

  GET TIME STAMP FIELD lv_timestamp.

  lv_comp = cl_abap_tstmp=>compare(
      tstmp1 = lv_timestamp
      tstmp2 = lv_hora_expiracao
  ).

ENDIF.

IF lv_comp <> -1.
* Neste caso, o timestamp atual é igual ou superior ao timestamp de
* expiração, portanto temos que subir o conteúdo novamente para o
* cache.

**********************************************************************
* 1. Determinação do conteúdo
**********************************************************************
* Criamos primeiro o objeto do cache:
  CREATE OBJECT lo_cached_response
    TYPE cl_http_response
    EXPORTING
      add_c_msg = 1.

* O conteúdo aqui vem de alguma fonte dinâmica (upload, módulo de
* função, gravado em alguma tabela, etc.) em formato XSTRING: 
  lo_cached_response->set_data( lv_conteudo ).

* Determinamos o MIME type do conteúdo que vai ser gravado. Abaixo
* estão 2 tipos mais comuns, adapte conforme a sua necessidade:
  CASE lv_tp_conteudo.
    WHEN 'JPG'.
      lv_content_type = 'image/jpeg'.
    WHEN 'PDF'.
      lv_content_type = 'application/pdf'.
    WHEN OTHERS.
*     ... 
  ENDCASE.  

  lo_cached_response->set_header_field(
      name  = if_http_header_fields=>content_type
      value = lv_content_type
  ).

* Determinando o status do pacote (sempre OK): 
  lo_cached_response->set_status(
      code   = 200
      reason = 'OK'
  ).

**********************************************************************
* 2. Determinando a URL
**********************************************************************
* Normalmente é possível usar a própria URL da sua aplicação, que pode
* ser obtida com a classe CL_WD_UTILITIES. Caso isso não seja possível,
* verifique com o Basis um caminho.

  cl_wd_utilities=>construct_wd_url(
    EXPORTING
      application_name = wd_this->wd_get_api( )->get_application( )->get_application_info( )->get_name( )
    IMPORTING
      out_local_url    = lv_url
  ).

* Se você tiver o nome do arquivo, use o prório junto com a URL.
  lv_url = lv_url && '/' && lv_nome_arquivo.

* Caso você não tenha ou o conteúdo seja dinâmico, crie um caminho
* usando a função GUID_CREATE:  
  CALL FUNCTION 'GUID_CREATE'
    IMPORTING
      ev_guid_32 = lv_guid.

  lv_url = lv_url && '/' && lv_guid. "não precisa de extensão

**********************************************************************
* 3. Definindo a validade do conteúdo
**********************************************************************
* Essa validade tem que ser gravada no contexto junto da URL, para que
* possamos testar depois

  GET TIME STAMP FIELD lv_hora_expiracao.

* Qualquer valor entre 1 e 3min é razoável, porém ajuste conforme o
* seu ambiente
  lv_hora_expiracao = cl_abap_tstmp=>add( 
     tstmp = lv_hora_expiracao
     secs  = 180
  ).

  CONVERT TIME STAMP lv_hora_expiracao
    TIME ZONE 'BRAZIL'
    INTO DATE lv_expires_abs_date
         TIME lv_expires_abs_time.

  lo_cached_response->server_cache_expire_abs(
    EXPORTING
      expires_abs_date = lv_expires_abs_date
      expires_abs_time = lv_expires_abs_time
  ).

**********************************************************************
* 4. Upload do conteúdo
**********************************************************************
  cl_http_server=>server_cache_upload(
      url      = lv_url
      response = lo_cached_response
  ).

ENDIF.