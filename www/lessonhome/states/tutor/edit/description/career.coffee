class @main extends @template '../edit_description'
  route : '/tutor/edit/career'
  model   : 'tutor/edit/description/career'
  title : "редактирование карьеры"
  tags : -> 'edit: description'
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  forms : [{person:['works']},{tutor:['experience','extra']}]
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Карьера'
    tutor_edit  : @module '$' :
      work  : @module '$/work' :
        place_of_work: @module 'tutor/forms/input':
          selector: 'first_reg'
          text2: 'Место работы :'
          $form : person : 'works.0.place'
        post: @module 'tutor/forms/input':
          selector: 'first_reg'
          text2: 'Должность :'
          $form : person : 'works.0.post'
        remove_button : @module 'tutor/button' :
          text : 'Удалить'
          selector : 'edit_save'

      #add_button    : @module 'button_add' :
      #  text     : '+Добавить'
      #  selector : 'edit_add'
      line : @module 'tutor/separate_line' :
        selector : 'horizon'
      experience_tutoring : @module 'tutor/forms/drop_down_list' :
        selector    : 'first_reg'
        self : false
        sort : false
        smart : false
        no_input : true
        filter : false
        text        : 'Опыт репетиторства :'
        items : [
          ''
          '1-2 года'
          '3-4 года'
          'более 4 лет'
        ]
        $form : tutor : 'experience'
      extra_info : @module 'tutor/forms/textarea' :
        text      : 'Доп. информация/<br>награды'
        selector  : 'first_reg lk'
        height : '117px'
        $form : tutor : 'extra.0.text'
    #hint        : @module 'tutor/hint' :
    #  selector  : 'horizontal'
    #  header    : 'Это подсказка'
    #  text      : 'Поскольку состояния всего нашего мира зависят от времени, то и состояние какой-либо системы тоже может зависеть от времени, как обычно и происходит Если такие величины описывают динамику какой-либо системы,'
