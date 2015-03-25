class @main extends template './preview'
  access : ['other']
  redirect : {
    'pupil' : '/first_step'
    'tutor' : '/tutor/search_bids'
  }
  tags  : -> 'pupil:fast_bid'
  tree : ->
    filter_top : module '$' :
      progress_bar : module '//progress_bar' :
        progress : @exports()
      content      : @exports()   # must be defined
      #hint         : @exports()     while hint it's not need
      footer       : module '//footer' :
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











