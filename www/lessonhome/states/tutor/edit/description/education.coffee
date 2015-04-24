class @main extends template '../edit_description'
  route : '/tutor/edit/education'
  model   : 'tutor/edit/description/education'
  title : "редактирование образования"
  tags : -> 'edit: description'
  access : ['tutor']
  redirect : {
    'default' : 'main/first_step'
  }
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Образование'
    tutor_edit  : module '$' :
      country       : module 'tutor/forms/drop_down_list' :
        text      : 'Страна :'
        selector  : 'first_reg'
      city          : module 'tutor/forms/drop_down_list' :
        text      : 'Город :'
        selector  : 'first_reg'
      university    : module 'tutor/forms/drop_down_list' :
        text      : 'ВУЗ :'
        selector  : 'first_reg'
      faculty       : module 'tutor/forms/drop_down_list' :
        text      : 'Факультет :'
        selector  : 'first_reg'
      chair         : module 'tutor/forms/drop_down_list' :
        text      : 'Кафедра :'
        selector  : 'first_reg'
      status        : module 'tutor/forms/drop_down_list' :
        text      : 'Статус :'
        selector  : 'first_reg'
      release_date   : state 'data_date'  :
        text  : 'Дата выпуска :'
      #add_button    : module 'button_add' :
      #  text      : '+Добавить'
      #  selector  : 'edit_add'
    hint        : module 'tutor/hint' :
      selector  : 'horizontal'
      header    : 'Это подсказка'
      text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'


  init: =>
    education = data('person').get('education')
    @tree.tutor_edit.country.value = education.then (edu)-> edu?.country
    @tree.tutor_edit.city.value = education.then (edu)-> edu?.city
    @tree.tutor_edit.university.value = education.then (edu)-> edu?.name
    @tree.tutor_edit.faculty.value = education.then (edu)-> edu?.faculty
    @tree.tutor_edit.chair.value = education.then (edu)-> edu?.chair
    @tree.tutor_edit.status.value = education.then (edu)-> edu?.qualification



