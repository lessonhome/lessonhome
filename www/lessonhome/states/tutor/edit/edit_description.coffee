class @main extends @template '../edit'
  tree  : =>
    items       :
      'Общие'       : 'general'
      'Контакты'    : 'contacts'
      'Образование' : 'education'
      'Карьера'     : 'career'
      'О себе'      : 'about'
      'Настройки'   : 'settings'
    selector          : @exports()
    active_item       : @exports()
    menu_description  : @exports()
    tutor_edit        : @exports()
    hint              : @exports()