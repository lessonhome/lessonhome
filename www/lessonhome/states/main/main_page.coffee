class @main extends template './template'
  route : '/'
  title : "title"
  tree : ->
    content : module 'main_page'  :
      filter_tutor    : module '//filter_tutor'
      subject_panel   : module '//subject_panel'
      search_diagram  : module '//find_diagram'
      chose_search    : module '//chose_search'
      chose_tutor     : module '//chose_tutor'