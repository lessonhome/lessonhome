class @main extends @template '../profile'
  tree : =>
    popup : @module '$' :
      selector : @exports()
      header       : @module '//header'
      progress_bar : @module '//progress_bar' :
        progress : @exports()
        current_progress : @exports()
      content      : @exports()   # must be defined
      button_back   : @module 'link_button' :
        text      : 'Назад'
        selector  : @exports 'selector_button_back'
        href      : @exports 'href_button_back'
      button_next   : @module 'link_button' :
        text      : 'Вперед'
        selector  : 'fast_bid_nav'
        href      :  @exports 'href_button_next'
      close         : @exports()

