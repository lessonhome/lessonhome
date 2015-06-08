class @main extends @template '../edit_description'
  route : '/tutor/edit/settings'
  model   : 'tutor/edit/description/settings'
  title : "редактирование настройки"
  tags : -> 'edit: description'
  forms : ['tutor']
  access : ['tutor']
  redirect : {
    'other' : 'main/first_step'
    'pupil' : 'main/first_step'
  }
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Настройки'
    tutor_edit  : @module '$' :
      new_orders_toggle : @module 'tutor/forms/toggle' :
        first_value : 'Получать'
        second_value : 'Не получать'
        value : $form : tutor : 'settings_new_orders'
      notice_sms_checkbox : @module 'tutor/forms/checkbox' :
        text      : 'по смс'
        selector  : 'small'
        #value     : true
        value     : $form : tutor : 'settings_get_notifications_sms'
      notice_email_checkbox : @module 'tutor/forms/checkbox' :
        text      : 'на email'
        selector  : 'small'
        #value    : true
        value     : $form : tutor : 'settings_get_notifications_email'
      callback_toggle : @module 'tutor/forms/toggle' :
        first_value : 'Да'
        second_value : 'Нет'
        value : $form : tutor : 'settings_call_operator_possibility'
      callback_comment : @module 'tutor/forms/textarea' :
        height    : '77px'
        selector  : 'first_reg'
        placeholder : 'Комментарий'
        value : $form : tutor : 'phone_call_description'
      save_button_notice : @module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'
      save_button_password : @module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'
      change_button_login : @module 'tutor/button' :
        text     : 'Изменить'
        selector : 'edit_save'
      change_button_email : @module 'tutor/button' :
        text     : 'Изменить'
        selector : 'edit_save'
      #confirm_code_login : @module 'tutor/forms/input' :
        #text2      : 'Введите код :'
        #selector  : 'first_reg'
      #confirm_code_login_button : @module 'tutor/button' :
       # text     : 'Подтвердить'
        #selector : 'edit_save'
      old_login : '+7*** *** ** 98'
      new_login : @module 'tutor/forms/input' :
        text2      : 'Новый :'
        selector  : 'first_reg'

      password: @module 'tutor/forms/input' :
        text2      : 'Ваш пароль :'
        selector  : 'first_reg'
      old_email : 'dd******@mail.ru'
      new_email : @module 'tutor/forms/input'  :
        text2      : 'Новый :'
        selector  : 'first_reg'
      old_password : @module 'tutor/forms/input' :
        text2      : 'Старый :'
        selector  : 'first_reg'
      new_password : @module 'tutor/forms/input' :
        text2      : 'Новый :'
        selector  : 'first_reg'
      confirm_password : @module 'tutor/forms/input' :
        text2      : 'Подтвердите :'
        selector  : 'first_reg'
      line_login : @module 'tutor/separate_line' :
        title     : 'Изменить логин'
        selector  : 'horizon'
      line_email : @module 'tutor/separate_line' :
        title     : 'Изменить e-mail'
        selector  : 'horizon'
      line_password : @module 'tutor/separate_line' :
        title     : 'Изменить пароль'
        selector  : 'horizon'

    #hint        : @module 'tutor/hint' :
    #  selector  : 'horizontal'
    #  header    : 'Это подсказка'
    #  text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'


  init  :=>
    @parent.parent.tree.content.possibility_save_button = false         # exception property, not this save button in state
