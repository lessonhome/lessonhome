class @main extends template '../main'
  tree : =>
    filter_top : @exports()
    content : module '$' :
      advanced_filter  : state './advanced_filter'
###    content : module '//content' :                # center
        sort            : module '//sort'
        choose_tutors    : module '//choose_tutors'
        tutors          : module '//tutors'

###