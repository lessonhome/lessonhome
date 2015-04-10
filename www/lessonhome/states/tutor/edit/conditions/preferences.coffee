class @main extends template '../edit_conditions'
  route : '/tutor/edit/preferences'
  model   : 'tutor/edit/conditions/preferences'
  title : "редактирование условия"
  tags : -> 'edit: conditions'
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : =>
    menu_condition  : 'edit: conditions'
    active_item : 'Предпочтения'
    tutor_edit  : module '$':
      gender_data   : state 'gender_data':
        selector  : 'choose_gender'
        title     : 'true'
        selector_button : 'registration'
      status : module 'tutor/forms/drop_down_list'  :
        text      : 'Статус :'
        selector  : 'first_reg'
        default_options     : {
          '0': {value: 'preschool_child', text: 'дошкольник'},
          '1': {value: 'student_junior_school', text: 'школьник - младшая школа'},
          '2': {value: 'student_high_school', text: 'школьник - средняя школа'},
          '3': {value: 'student_senior_school', text: 'школьник - старшая школа'},
          '4': {value: 'student', text: 'студент'},
          '5': {value: 'grown_up', text: 'взрослый'}
        }
    hint        : module 'tutor/hint' :
      selector  : 'horizontal'
      header    : 'Это подсказка'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'




