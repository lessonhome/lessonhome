class @main extends @template '../edit_description'
  route : '/tutor/edit/about'
  model   : 'tutor/edit/description/about'
  title : "редактирование о себе"
  tags : -> 'edit: description'
  access : ['tutor']
  redirect : {
    'other' : 'main/first_step'
    'pupil' : 'main/first_step'
  }
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'О себе'
    tutor_edit  : @state 'about_tutor'
    #hint        : module 'tutor/hint' :
    #  selector  : 'horizontal'
    #  header    : 'Это подсказка'
    #  text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'
