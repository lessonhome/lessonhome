###
  class @main extends template '../fast_bid'
    route : '/help'
    model : 'main/application/1_step'
    title : "Помощь"
    access : ['other', 'pupil', 'tutor']
    forms : ['pupil','person' ]
    redirect : {
      tutor : 'tutor/profile'
    }
    tree : =>
      content : module '$' :
        name        : module 'tutor/forms/input' :
          placeholder : 'Имя :'
          selector    : 'first_reg'
          #value: data('person').get('phone').then (p)-> p[1] if p?[1]?
        email       : module 'tutor/forms/input' :
          placeholder : 'Email :'
          selector    : 'first_reg'
          #value: data('person').get('phone').then (p)-> p[1] if p?[1]?
        telephone   : module 'tutor/forms/input' :
          placeholder : 'Телефон :'
          selector    : 'first_reg'
          #value: data('person').get('phone').then (p)-> p[1] if p?[1]?
        questions   : module 'tutor/forms/input'
        send_button : module 'tutor/button' :
          text      : 'Отправить'
          selector  : 'edit_save'

    init : ->

###
