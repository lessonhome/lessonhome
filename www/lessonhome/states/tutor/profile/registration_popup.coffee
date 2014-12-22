class @main extends template '../profile'
  tree : ->
    popup : module '$' :
      header       : module '//header'
      progress_bar : module '//progress_bar' :
        progress : 1
      content      : @exports()   # must be defined
      footer       : module '//footer' :
        button_back : module '//button_back'
        back_link   : @exports()  # must be defined
        button_save : module '//button_save'
        button_next : module '//button_next'
        next_link   : @exports()  # must be defined
