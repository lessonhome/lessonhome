class @main extends @template '../edit_conditions'
  route : '/tutor/edit/subjects'
  model   : 'tutor/edit/conditions/subjects'
  title : "редактирование предметы"
  tags : -> 'edit: conditions'
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree : =>
    menu_condition  : 'edit: conditions'
    active_item : 'Предметы'
    tutor_edit  : @state 'subjects_tutor_test'



