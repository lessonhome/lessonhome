class @main extends template './template'
  route : '/'
  title : "title"
  tree : ->
    content : module 'main_page'  :
      filter_tutor    : module '//filter_tutor' :
        list_subject  : module 'tutor/template/forms/drop_down_list'  :
          selector  : 'subject'
        chose_subject : module 'tutor/template/button'  :
          selector  : 'fixed'
        button_back   : module 'tutor/template/button'  :
          selector  : 'fixed'
        button_issue  : module 'tutor/template/button'  :
          selector  : 'fixed'
        button_onward : module 'tutor/template/button'  :
          selector  : 'fixed'
      subject_panel   : module '//subject_panel'
      search_diagram  : module '//search_diagram'
      chose_search    : module '//chose_search'
      chose_tutor     : module '//chose_tutor'