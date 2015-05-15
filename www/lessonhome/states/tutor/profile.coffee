class @main extends template '../tutor'
  route : '/tutor/profile'
  model   : 'tutor/profile/profile'
  title : "анкета"
  tags   : -> 'tutor:profile'
  forms : [{person:['phone','email','skype','site']}]
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
          'Телефон :'     : $form : person : phone : (s)->
            s || '<a href="./edit/contacts">заполнить</a>'
          'Почта :'     : $form : person : email : (s)->
            s || '<a href="./edit/contacts">заполнить</a>'
          'Скайп :'     : $form : person : skype : (s)->
            s || '<a href="./edit/contacts">заполнить</a>'
          'Личный сайт :'     : $form : person : site : (s)->
            s || '<a href="./edit/contacts">заполнить</a>'
      #progress  : module './profile_content/progress' :
      #  filling  : '56%'
      edit      : true
      add       : true
  init : =>
    @parent.tree.left_menu.setActive 'Анкета'

