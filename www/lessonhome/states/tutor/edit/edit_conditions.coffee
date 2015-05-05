class @main extends template '../edit'
  tree  : =>
    items :
      'Предметы'     : 'subjects'
      #'Место'        : 'location'
      'Календарь'    : 'calendar'
      'Места выезда' : 'preferences'
    active_item     : @exports()
    menu_condition  : @exports()
    tutor_edit      : @exports()
    hint            : @exports()