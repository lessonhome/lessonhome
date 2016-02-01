class @main extends @template './preview'
  tags  : -> 'pupil:fast_bid'
  tree : ->
    filter_top : @module '$' :
      progress_bar : @module '//progress_bar' :
        progress : @exports()

      b_selector  : @exports()
      content      : @exports()   # must be defined
      #hint         : @exports()     while hint it's not need

      add_tutors : @module 'main/add_tutors'  :
        tutors : [
          @module 'main/add_tutors/tutor_small' :
            src : '#'
          @module 'main/add_tutors/tutor_small' :
            src : '#'
          @module 'main/add_tutors/tutor_small' :
            src : '#'
        ]

      button_back : @module 'link_button' :
        selector: @exports 'style_button_back'
        text:     'Назад'
        href     : @exports 'href_button_back'
      issue_bid : @module 'link_button' :
        selector: @exports 'style_issue_bid'
        text: 'Отправить заявку'
        href: @exports 'href_issue_bid'
      button_next : @module 'link_button' :
        selector:  @exports 'style_button_next'
        text:     'Далее'
        href:     @exports 'href_button_next'







