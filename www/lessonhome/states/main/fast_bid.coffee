class @main extends template './preview'
  tree : ->
    filter_top : module '$' :
      progress_bar : module '//progress_bar' :
        progress : 1
      content      : @exports()   # must be defined
      hint : @exports()
      footer       : module '//footer' :
        button_back : module '//button_back' :
          selector : 'active'
        back_link   : @exports()  # must be defined
        issue_bid : module '//issue_bid' :
          selector : 'active'
        button_next : module '//button_next' :
          selector : 'active'
        next_link   : @exports()  # must be defined











