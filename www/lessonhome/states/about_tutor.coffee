class @main
  tree : -> module '$' :
    reason     : module 'tutor/forms/textarea' :
      height    : '87px'
      text      : 'Почему я репетитор?'
      selector  : 'first_reg'
      value     : data('tutor').get('reason')
    interests  : module 'tutor/forms/textarea' :
      height    : '87px'
      text      : 'Интересы :'
      selector  : 'first_reg'
      value     : data('person').get('interests').then (i)-> i[0].description if i?[0]?.description?
    slogan     : module 'tutor/forms/input'  :
      text2        : 'Девиз :'
      selector  : 'first_reg'
      value     : data('tutor').get('slogan')
    about      : module 'tutor/forms/textarea' :
      height    : '117px'
      text      : 'О себе :'
      selector  : 'first_reg'
      value     : data('tutor').get('about')
