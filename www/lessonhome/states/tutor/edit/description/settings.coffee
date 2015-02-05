class @main extends template '../../../tutor'
  route : '/tutor/edit/settings'
  model   : 'tutor/edit/description/settings'
  title : "редактирование настройки"
  tree : =>
    items : [
      module 'tutor/header/button' : {
        title : 'Описание'
        href  : '/tutor/edit/general'
      }
      module 'tutor/header/button' : {
        title : 'Условия'
        href  : '/tutor/edit/subjects'
      }
    ]
    sub_top_menu : state 'tutor/sub_top_menu' :
      items :
        'Общие'       : 'general'
        'Контакты'    : 'contacts'
        'Образование' : 'education'
        'Карьера'     : 'career'
        'О себе'      : 'about'
        'Настройки'   : 'settings'
    #'Медиа'       : 'media'
      active_item     : 'Настройки'
    content       : module '$' :
      new_orders_toggle : module 'tutor/forms/toggle' :
        first_value : 'Получать'
        second_value : 'Не получать'
      notice_sms_checkbox : module 'tutor/forms/checkbox'
      notice_email_checkbox : module 'tutor/forms/checkbox'
      callback_toggle : module 'tutor/forms/toggle' :
        first_value : 'Да'
        second_value : 'Нет'
      callback_comment : module 'tutor/forms/textarea' :
        height    : '77px'
        selector  : 'edit_settings'
        placeholder : 'Комментарий'
      save_button : module 'tutor/button' :
        text     : 'Сохранить'
        selector : 'edit_save'
      change_button : module 'tutor/button' :
        text     : 'Изменить'
        selector : 'edit_save'
      new_phone_number : module 'tutor/forms/input'
      new_email : module 'tutor/forms/input'
      new_password : module 'tutor/forms/input'
      old_password : module 'tutor/forms/input'
      confirm_password : module 'tutor/forms/input'
      line_phone : module 'tutor/separate_line' :
        title     : 'Номер телефона'
        selector  : 'horizon'
      line_email : module 'tutor/separate_line' :
        title     : 'E-mail'
        selector  : 'horizon'
      line_password : module 'tutor/separate_line' :
        title     : 'Пароль'
        selector  : 'horizon'

  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
    @parent.tree.left_menu.setLinks ['../profile', '../search_bids', '#', '#', '#', '#', '#']


