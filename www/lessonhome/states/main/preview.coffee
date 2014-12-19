class @main extends template '../main'
  tree : =>
    top_filter : @exports()
    content : module '$' :
      filter : module '//filter'        # left filter
      content : module '//content' :    # tutor
        sort : module '//sort'
        tutors : module '//tutors'