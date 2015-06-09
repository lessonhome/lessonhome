class @main extends @template '../edit_description'
  route : '/tutor/edit/career'
  model   : 'tutor/edit/description/career'
  title : "редактирование карьеры"
  tags : -> 'edit: description'
  access : ['tutor']
  redirect : {
    'other' : 'main/first_step'
    'pupil' : 'main/first_step'
  }
  forms : [{person:['work']},{tutor:['experience','extra']}]
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Карьера'
    tutor_edit  : @module '$' :
      work  : [
        {
          place_of_work: @module 'tutor/forms/input':
            selector: 'first_reg'
            text2: 'Место работы :'
            $form : person : 'work.place'
          post: @module 'tutor/forms/input':
            selector: 'first_reg'
            text2: 'Должность :'
            $form : person : 'work.post'
        }
      ]
      #add_button    : @module 'button_add' :
      #  text     : '+Добавить'
      #  selector : 'edit_add'
      line : @module 'tutor/separate_line' :
        selector : 'horizon'
      experience_tutoring : @module 'tutor/forms/drop_down_list' :
        selector    : 'first_reg'
        text        : 'Опыт репетиторства :'
        default_options     : {
          '0': {value: '1-2years', text: '1-2 года'},
          '1': {value: '3-4years', text: '3-4 года'},
          '2': {value: 'more_than_4_years', text: 'более 4 лет'},
          '3': {value: 'no_matter', text: 'неважно'}
        }
        $form : tutor : 'experience'
      extra_info : @module 'tutor/forms/textarea' :
        text      : 'Доп. информация/<br>награды'
        selector  : 'first_reg'
        height : '117px'
        $form : tutor : 'extra.0.text'
    #hint        : @module 'tutor/hint' :
    #  selector  : 'horizontal'
    #  header    : 'Это подсказка'
    #  text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'
