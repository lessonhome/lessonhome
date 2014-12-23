class @main extends template '../main'
  tree : =>
    top_filter : @exports()
    content : module '$' :
      advanced_filter : module '$/advanced_filter'  :  # left filter
        list_course  : module 'tutor/forms/drop_down_list'  :
          selector  : 'list_course'
          placeholder : 'Например ЕГЭ'
        add_course   : module 'tutor/button'  :
          selector  : 'chose_course'
          text      : 'ЕГЭ'
        calendar          : module '$/calendar' :
          choose_all       : module 'tutor/forms/checkbox'
         # close



      content : module '//content' :                # center
        sort            : module '//sort'
        chose_tutors    : module '//chose_tutors'
        tutors          : module '//tutors'