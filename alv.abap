*&---------------------------------------------------------------------*
*& Report YTESTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report yteste.


tables:
  snwd_ad .

types:
  begin of ty_out,
    node_key type snwd_text-node_key,
    text     type snwd_text-text,
    city     type snwd_ad-city,
    street   type snwd_ad-street,
    country  type snwd_ad-country,
  end of ty_out.

* Dados Globais
data:
  ad_tab    type table of snwd_ad,
  ad_line   type snwd_ad,
  text_tab  type table of snwd_text,
  text_line type snwd_text,
  out_tab   type table of ty_out,
  out_line  type ty_out .


* Tela de selecao (filtro)
select-options:
  key for snwd_ad-node_key obligatory .

* Configurando valores Iniciais (opcional)
*initialization .
*
*  key-sign   = 'I' .
*  key-option = 'BT' .
*  key-low    = '005056A215981EE9AE932919D6BB8B29' .
*  key-high   = '005056A215981EE9AE932919D6C84B29' .
*  append key to key[] .


* Busca de dados
start-of-selection .

  perform:
    f_busca,
    f_organiza,
    f_exibe .


form f_busca .

  if ( key[] is not initial ) .

    select *
      into table text_tab
      from snwd_text
     where node_key in key .

    if sy-subrc eq 0 .

      select *
        into table ad_tab
        from snwd_ad
         for all entries in text_tab
       where node_key eq text_tab-node_key .

       if sy-subrc eq 0 .
       endif .

    endif .

  endif .

endform .

form f_organiza .

  if ( text_tab is not initial ) and
     ( ad_tab   is not initial ) .

    loop at text_tab into text_line .

      read table ad_tab into ad_line
        with key node_key = text_line-node_key .

      if sy-subrc eq 0 .

        out_line-node_key = text_line-node_key .
        out_line-text     = text_line-text .
        out_line-city     = ad_line-city .
        out_line-street   = ad_line-street .
        out_line-country  = ad_line-country .

        append out_line to out_tab .
        clear  out_line .

      endif .

    endloop .

  endif .

endform .

form f_exibe .

  if out_tab is not initial .

    cl_demo_output=>display( out_tab ).

  endif .

endform .
