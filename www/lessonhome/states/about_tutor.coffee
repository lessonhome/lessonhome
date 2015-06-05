class @main
  forms : [{tutor:['reason','slogan','about']},{person :['interests0_description']}]
  tree : => @module '$' :
    reason     : @module 'tutor/forms/textarea' :
      height    : '87px'
      text      : 'Почему я репетитор?'
      selector  : 'first_reg'
      value     : $form : tutor : 'reason'
    interests  : @module 'tutor/forms/textarea' :
      height    : '87px'
      text      : 'Интересы :'
      selector  : 'first_reg'
      value     : $form : person : 'interests0_description'
    slogan     : @module 'tutor/forms/input'  :
      text2        : 'Девиз :'
      selector  : 'first_reg'
      value     : $form : tutor : 'slogan'
    about      : @module 'tutor/forms/textarea' :
      height    : '117px'
      text      : 'О себе :'
      selector  : 'first_reg'
      value     : $form : tutor : 'about'
