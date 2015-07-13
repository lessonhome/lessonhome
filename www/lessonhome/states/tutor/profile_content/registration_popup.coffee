class @main extends @template '../profile'
  tree : =>
    popup : @module '$' :
      header       : @module '//header'
      progress_bar : @module '//progress_bar' :
        progress : @exports()
        current_progress : @exports()
      content      : @exports()   # must be defined
      button_back   : @module 'link_button' :
        text      : 'Назад'
        selector  : @exports()
        href      : @exports()
      button_next   : @module 'link_button' :
        text      : 'Вперед'
        selector  :  @exports()
        href      :  @exports()
      close         : @exports()

