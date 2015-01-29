class @main extends template '../profile'
  tree : ->
    popup : module '$' :
      header       : module '//header'
      progress_bar : module '//progress_bar' :
        progress : 1
      content      : @exports()   # must be defined
      footer       : module '//footer' :
        button_back : module '//button_back' :
          selector : 'active'
        back_link   : @exports()  # must be defined
        save_notice : module '//save_notice'
        button_next : module '//button_next' :
          selector : 'active'
        next_link   : @exports()  # must be defined
