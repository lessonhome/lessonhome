class @main extends @template '../main'
  tags  : -> 'pupil:fast_bid'
  tree : ->
    filter_top : @module '$' :
      progress_bar : @module '//progress_bar' :
        progress : @exports()
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
        selector: @exports()
        text:     'Назад'
        href     : @exports()
      issue_bid : @module 'link_button' :
        selector: @exports()
        text: 'Отправить заявку'
        href: @exports()
      button_next : @module 'link_button' :
        selector:  @exports()
        text:     'Далее'
        href:     @exports()







