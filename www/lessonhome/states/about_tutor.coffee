class @main
  forms : [{tutor:['reason','slogan','about']},{person :['interests0_description']}]
  tree : => @module '$' :
    reason     : @module 'tutor/forms/textarea' :
      height    : '123px'
      text      : 'Почему я репетитор?'
      selector  : 'first_reg'
      value     : $form : tutor : 'reason'
    interests  : @module 'tutor/forms/textarea' :
      height    : '127px'
      text      : 'Интересы :'
      selector  : 'first_reg'
      value     : $form : person : 'interests0_description'
    slogan     : @module 'tutor/forms/input'  :
      text2        : 'Девиз :'
      selector  : 'first_reg'
      value     : $form : tutor : 'slogan'
    about      : @module 'tutor/forms/textarea' :
      height    : '215px'
      text      : 'О себе :'
      selector  : 'first_reg'
      value     : $form : tutor : 'about'
      placeholder : 'Информация, которая будет интересна ученику о Вас как о репетиторе.'
