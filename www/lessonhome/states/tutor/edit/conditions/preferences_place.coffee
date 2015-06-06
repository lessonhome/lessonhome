
class @main extends @template '../edit_conditions'
  route : '/tutor/edit/preferences'
  model   : 'tutor/edit/conditions/preferences'
  title : "редактирование условия"
  tags : -> 'edit: conditions'
  access : ['tutor']
  redirect : {
    'other' : 'main/first_step'
    'pupil' : 'main/first_step'
  }
  forms : [{tutor:['check_out_the_areas']}]
  tree : =>
    menu_condition  : 'edit: conditions'
    active_item : 'Места выезда'
    tutor_edit  : @module '$':
      area : @module 'tutor/forms/drop_down_list'  :
        text      : 'Район :'
        selector  : 'first_reg'
      ###
        metro : module 'tutor/forms/drop_down_list'  :
          text      : 'Метро :'
          selector  : 'first_reg'
          default_options     : {
            '0': {value: 'test0', text: 'test0'},
            '1': {value: 'test1', text: 'test1'},
            '2': {value: 'test2', text: 'text2'}
          }

      ###
      area_tags: $form : tutor : 'check_out_the_areas'


