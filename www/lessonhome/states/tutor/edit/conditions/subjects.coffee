class @main extends template '../../edit'
  route : '/tutor/edit/subjects'
  model   : 'tutor/edit/conditions/subjects'
  title : "редактирование предметы"
  tree : =>
    menu_condition  : 'edit: conditions'
    items :
      'Предметы'     : 'subjects'
      'Место'        : 'location'
      'Календарь'    : 'calendar'
      'Предпочтения' : 'preferences'
    active_item : 'Предметы'
    tutor_edit  : state 'subject_tutor'



