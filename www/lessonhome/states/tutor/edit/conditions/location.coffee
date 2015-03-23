class @main extends template '../edit_conditions'
  route : '/tutor/edit/location'
  model   : 'tutor/edit/conditions/location'
  title : "редактирование место"
  tags : -> 'edit: conditions'
  tree : =>
    menu_condition  : 'edit: conditions'
    active_item : 'Место'
    tutor_edit : state 'place_tutor'