

class @main extends template '../main'
  tree : =>
    content : module '$' :
      filter : module '//filter'
      content : module '//content' :
        sort : module '//sort'
        tutors : module '//tutors'
    top_filter : @exports()