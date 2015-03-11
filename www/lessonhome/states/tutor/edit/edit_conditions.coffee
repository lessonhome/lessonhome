class @main extends template '../edit'
  tree  : =>
    items :
      'Предметы'     : 'subjects'
      'Место'        : 'location'
      'Календарь'    : 'calendar'
      'Предпочтения' : 'preferences'
    active_item     : @exports()
    menu_condition  : @exports()
    tutor_edit      : @exports()
    hint            : @exports()
    selector_hint   : @exports()  #because hint have different style