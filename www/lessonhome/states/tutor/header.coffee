class @main
  forms : ['account','person']
  tree : => @module '$' :
    depend : [
      @module 'lib/crypto'
      @module 'lib/lzstring'
    ]
    logo      : @module '$/logo'
    top_menu : @module '$/top_menu' :
      items     : @exports()
      line_menu : @exports()
    icons     : @exports()
    back_call : @module '$/back_call'  :
      #city            : 'Москва'
      call_back_popup : @state '../main/call_back_popup' :
        selector: 'header'

    button_in_out :  @module '$/button_in_out':
      enter       : @module './button' :
        text  : 'Войти'
        selector      : 'in_out'

    ###
      registered  : $form : account : 'registered'
      login       :  @module './forms/input'  :
        replace : [
          '[^\\d-\\(\\)\\@\\w\\+\\s\\.]'
        ]
        text1 : "Телефон или email"
        selector    : 'fast_bid'
        placeholder : 'Логин'
        name        : 'email'
      password   :  @module './forms/input'  :
        text1 : "Пароль"
        type        : 'password'
        selector    : 'fast_bid'
        placeholder : 'Пароль'
        name        : 'password'
    ###

    tutor_icon : @module 'mime/photo' :
      photo   : $form : person : 'avatar'
      src     : @F 'vk.unknown.man.jpg'
    tutor_icon_list : [
      @module 'tutor/header/list_button/item' :
        title : 'Профиль'
        link : '/tutor/profile'
      @module 'tutor/header/list_button/item' :
        title : 'Заявки'
        link : '/tutor/search_bids'
      @module 'tutor/header/list_button/item' :
        title : 'Помощь'
        link : '#'
      @module 'tutor/header/list_button/item' :
        title : 'Выход'
        link : '/form/tutor/logout'
    ]


