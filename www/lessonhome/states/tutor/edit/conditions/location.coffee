class @main extends template '../../edit'
  route : '/tutor/edit/location'
  model   : 'tutor/edit/conditions/location'
  title : "редактирование место"
  tags : -> 'edit: conditions'
  tree : =>
    menu_condition  : 'edit: conditions'
    items :
      'Предметы'     : 'subjects'
      'Место'        : 'location'
      'Календарь'    : 'calendar'
      'Предпочтения' : 'preferences'
    active_item : 'Место'
    tutor_edit : state 'place_tutor'