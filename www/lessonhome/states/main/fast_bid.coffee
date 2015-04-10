class @main extends template './preview'
  tags  : -> 'pupil:fast_bid'
  tree : ->
    filter_top : module '$' :
      progress_bar : module '//progress_bar' :
        progress : @exports()
      content      : @exports()   # must be defined
      #hint         : @exports()     while hint it's not need
      button_back : module 'link_button' :
        selector: @exports()
        text:     'Назад'
        href     : @exports()
      issue_bid : module 'link_button' :
        selector: @exports()
        text: 'Оформить заявку сейчас'
        href: @exports()
      button_next : module 'link_button' :
        selector:  @exports()
        text:     'Далее'
        href:     @exports()











