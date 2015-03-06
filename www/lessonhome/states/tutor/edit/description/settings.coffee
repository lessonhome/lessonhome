class @main extends template '../../edit'
  route : '/tutor/edit/settings'
  model   : 'tutor/edit/description/settings'
  title : "редактирование настройки"
  tags : -> 'edit: description'
  tree : =>
    menu_description  : 'edit: description'
    items       :
      'Общие'       : 'general'
      'Контакты'    : 'contacts'
      'Образование' : 'education'
      'Карьера'     : 'career'
      'О себе'      : 'about'
      'Настройки'   : 'settings'
    active_item : 'Настройки'
    tutor_edit  : module '$' :
      new_orders_toggle : module 'tutor/forms/toggle' :
        first_value : 'Получать'
        second_value : 'Не получать'
      notice_sms_checkbox : module 'tutor/forms/checkbox' :
        text      : 'по смс'
        selector  : 'small'
      notice_email_checkbox : module 'tutor/forms/checkbox' :
        text      : 'на email'
        selector  : 'small'
      callback_toggle : module 'tutor/forms/toggle' :
        first_value : 'Да'
        second_value : 'Нет'
      callback_comment : module 'tutor/forms/textarea' :
        height    : '77px'
        selector  : 'first_reg'
        placeholder : 'Комментарий'
      save_button : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'
      change_button : module 'tutor/button' :
        text     : 'Изменить'
        selector : 'edit_save'
      new_phone_number : module 'tutor/forms/input' :
        text      : 'Новый :'
        selector  : 'first_reg'
      new_email : module 'tutor/forms/input'  :
        text      : 'Новый :'
        selector  : 'first_reg'
      new_password : module 'tutor/forms/input' :
        text      : 'Старый :'
        selector  : 'first_reg'
      old_password : module 'tutor/forms/input' :
        text      : 'Новый :'
        selector  : 'first_reg'
      confirm_password : module 'tutor/forms/input' :
        text      : 'Подтвердите :'
        selector  : 'first_reg'
      line_phone : module 'tutor/separate_line' :
        title     : 'Номер телефона'
        selector  : 'horizon'
      line_email : module 'tutor/separate_line' :
        title     : 'E-mail'
        selector  : 'horizon'
      line_password : module 'tutor/separate_line' :
        title     : 'Пароль'
        selector  : 'horizon'

    hint        : module 'tutor/hint' :
      selector  : 'horizontal'
      header    : 'Это подсказка'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'


  init  :=>
    @parent.tree.content.possibility_save_button = false