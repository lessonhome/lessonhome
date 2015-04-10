class @main extends template '../tutor'
  route : '/tutor/profile'
  model   : 'tutor/profile/profile'
  title : "анкета"
  tags   : -> 'tutor:profile'
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }

  tree : ->
    items : [
      module 'tutor/header/button' :
        title : 'Описание'
        href  : '/tutor/profile'
        tag   : 'tutor:profile'
      module 'tutor/header/button' :
        title : 'Условия'
        href  : '/tutor/conditions'
      module 'tutor/header/button' :
        title : 'Отзывы'
        href  : '/tutor/reviews'
    ]
    content : state './profile_content' :
      popup         : @exports()
      contacts : module './profile_content/info_block' :
        section :
          'Телефон :'     : data('person').get('phone').then (p)-> p[0] if p?[0]?
          'Почта :'       : data('person').get('email').then (e)-> e[0] if e?[0]?
          'Скайп :'       : data('person').get('social_networks').then (s)-> s.skype[0] if s?.skype?[0]?
          'Личный сайт :' : data('person').get('site').then (s)-> s[0] if s?[0]?
      progress  : module './profile_content/progress' :
        filling  : '56%'
      edit      : true
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'

