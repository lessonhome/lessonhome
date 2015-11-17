class @main
  tree : => @module 'forms/drop_down_list_with_tags' :
    lib_diff  : @module 'lib/diff'
    list  : @module 'forms/drop_down_list'  :
      selector        : @exports()
      placeholder     : @exports()
      value     : ''
      smart : @exports()
      filter : @exports()
      sort : @exports()
      self : @exports()
      items : @exports()
    value : @exports()