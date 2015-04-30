class @main extends template '../tutor'
  route : '/tutor/profile'
  model   : 'tutor/profile/profile'
  title : "анкета"
  tags   : -> 'tutor:profile'
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : =>
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
          'Телефон :'     : data('person').get('phone').then (p)->
            return p[0] if p?[0]? && p[0] && p[0]!="+7 (___) ___-__-__"
            return data('convert').getLinkToFill "./edit/contacts"
          'Почта :'       : data('person').get('email').then (e)->
            return e[0] if e?[0]? && e[0]
            return data('convert').getLinkToFill "./edit/contacts"
          'Скайп :'       : data('person').get('social_networks').then (s)->
            return s.skype[0] if s?.skype?[0]? && s.skype[0]
            return data('convert').getLinkToFill "./edit/contacts"
          'Личный сайт :' : data('person').get('site').then (s)->
            return s[0] if s?[0]? && s[0]
            return data('convert').getLinkToFill "./edit/contacts"
      progress  : module './profile_content/progress' :
        filling  : '56%'
      edit      : true
  init : =>
    @parent.tree.left_menu.setActive 'Анкета'

