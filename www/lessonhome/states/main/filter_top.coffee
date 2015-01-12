class @main
  tree : => module '$' :
      title           : @exports()
      list_subject    : @exports()
      button_back     : module 'tutor/button'  :
        selector  : 'subject_back'
        text      : 'Назад'
      button_issue    : module 'tutor/button'  :
        selector  : 'issue_bid'
        text      : 'Оформить заявку сейчас'
      button_onward   : module 'tutor/button'  :
        selector  : 'onward_block'
        text      : 'Далее'
