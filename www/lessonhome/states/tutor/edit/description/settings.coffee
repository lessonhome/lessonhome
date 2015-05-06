class @main extends template '../edit_description'
  route : '/tutor/edit/settings'
  model   : 'tutor/edit/description/settings'
  title : "редактирование настройки"
  tags : -> 'edit: description'
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Настройки'
    tutor_edit  : module '$' :
      new_orders_toggle : module 'tutor/forms/toggle' :
        first_value : 'Получать'
        second_value : 'Не получать'
      notice_sms_checkbox : module 'tutor/forms/checkbox' :
        text      : 'по смс'
        selector  : 'small'
        value     : true
      notice_email_checkbox : module 'tutor/forms/checkbox' :
        text      : 'на email'
        selector  : 'small'
        value     : true
      callback_toggle : module 'tutor/forms/toggle' :
        first_value : 'Да'
        second_value : 'Нет'
      callback_comment : module 'tutor/forms/textarea' :
        height    : '77px'
        selector  : 'first_reg'
        placeholder : 'Комментарий'
      save_button_notice : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'
      save_button_password : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'
      change_button_login : module 'tutor/button' :
        text     : 'Изменить'
        selector : 'edit_save'
      change_button_email : module 'tutor/button' :
        text     : 'Изменить'
        selector : 'edit_save'
      #confirm_code_login : module 'tutor/forms/input' :
        #text2      : 'Введите код :'
        #selector  : 'first_reg'
      #confirm_code_login_button : module 'tutor/button' :
       # text     : 'Подтвердить'
        #selector : 'edit_save'
      old_login : '+7*** *** ** 98'
      new_login : module 'tutor/forms/input' :
        text2      : 'Новый :'
        selector  : 'first_reg'
        replace     : [
          {"^(8|7)(?!\\+7)":"+7"}
          {"^(.*)(\\+7)":"$2$1"}
          "\\+7"
          "[^\\d_]"
          {"^(.*)$":"$1__________"}
          {"^([\\d_]{0,10})(.*)$": "$1"}
          {"^([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)$":"+7 ($1$2$3) $4$5$6-$7$8-$9$10"}
        ]
        replaceCursor     : [
          "(_)"
        ]
        selectOnFocus : true
        patterns : [
          "^\\+7 \\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d-\\d\\d$" : "Введите телефон <br>в формате +7 (926) 123-45-45"
        ]

      password: module 'tutor/forms/input' :
        text2      : 'Ваш пароль :'
        selector  : 'first_reg'
      old_email : 'dd******@mail.ru'
      new_email : module 'tutor/forms/input'  :
        text2      : 'Новый :'
        selector  : 'first_reg'
      old_password : module 'tutor/forms/input' :
        text2      : 'Старый :'
        selector  : 'first_reg'
      new_password : module 'tutor/forms/input' :
        text2      : 'Новый :'
        selector  : 'first_reg'
      confirm_password : module 'tutor/forms/input' :
        text2      : 'Подтвердите :'
        selector  : 'first_reg'
      line_login : module 'tutor/separate_line' :
        title     : 'Изменить логин'
        selector  : 'horizon'
      line_email : module 'tutor/separate_line' :
        title     : 'Изменить e-mail'
        selector  : 'horizon'
      line_password : module 'tutor/separate_line' :
        title     : 'Изменить пароль'
        selector  : 'horizon'

    #hint        : module 'tutor/hint' :
    #  selector  : 'horizontal'
    #  header    : 'Это подсказка'
    #  text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'


  init  :=>
    @parent.parent.tree.content.possibility_save_button = false         # exception property, not this save button in state
    settings = data('tutor').get('settings')
    @tree.tutor_edit.new_orders_toggle.value = settings.then (s)-> s?.new_orders
    ###
      @tree.tutor_edit.notice_sms_checkbox.value = settings.then (s)-> s?.get_notifications.then (arr)->
        for key, val of arr
          console.log 'val : '+val+'key : '+key
          if val == 'sms'
            return true
        return false

    ###
    phone_call = data('tutor').get('phone_call')
    @tree.tutor_edit.callback_comment.value = phone_call.then (p)-> p?.description
