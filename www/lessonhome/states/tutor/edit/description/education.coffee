class @main extends @template '../edit_description'
  route : '/tutor/edit/education'
  model   : 'tutor/edit/description/education'
  title : "редактирование образования"
  tags : -> 'edit: description'
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  forms : [{person:['edu']}]
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Образование'
    tutor_edit  : @module '$' :
      remove_button     : @module 'tutor/button' :
        text      : 'Удалить'
        selector  : 'edit_remove'
      country       : @module 'tutor/forms/drop_down_list' :
        text      : 'Страна :'
        items : ['Россия','Белоруссия','Казахстан','Киргизия','Абхазия','Украина','Молдавия','Румыния','Норвегия','Латвия']
        selector  : 'first_reg'
        value : $form : person : 'edu.country'
        self  : true
        smart : true
      city          : @module 'tutor/forms/drop_down_list' :
        text      : 'Город :'
        items : ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Нижний Новгород', 'Казань', 'Самара', 'Челябинск', 'Омск',
          'Ростов-на-Дону', 'Уфа', 'Красноярск', 'Пермь', 'Волгоград', 'Воронеж', 'Саратов', 'Краснодар', 'Тольятти', 'Тюмень', 'Ижевск',
          'Барнаул', 'Ульяновск', 'Иркутск', 'Владивосток', 'Ярославль', 'Хабаровск', 'Махачкала', 'Оренбург', 'Томск', 'Кемерово', 'Рязань',
          'Астрахань', 'Набережные Челны', 'Пенза', 'Липецк']
        selector  : 'first_reg'
        $form : person : 'edu.city'
        self  : true
        smart : true
      university    : @module 'tutor/forms/drop_down_list' :
        text      : 'ВУЗ :'
        selector  : 'first_reg'
        $form : person : 'edu.name'
        self  : true
        smart : true
      faculty       : @module 'tutor/forms/drop_down_list' :
        text      : 'Факультет :'
        selector  : 'first_reg'
        $form : person : 'edu.faculty'
        self  : true
        smart : true
      chair         : @module 'tutor/forms/drop_down_list' :
        text      : 'Кафедра :'
        selector  : 'first_reg'
        $form : person : 'edu.chair'
        self  : true
        smart : true
      qualification : @module 'tutor/forms/drop_down_list' :
        text      : 'Статус :'
        selector  : 'first_reg'
        $form : person : 'edu.qualification'
        self  : true
        smart : true
      learn_from    : @module 'tutor/forms/drop_down_list'  :
        text        : 'Период обучения :'
        selector    : 'first_reg_from'
        placeholder : 'с'
        $form : person : 'edu.period.start'
        self  : true
        smart : true
      learn_till    : @module 'tutor/forms/drop_down_list'  :
        selector    : 'first_reg_till'
        placeholder : 'до'
        $form : person : 'edu.period.end'
        self  : true
        smart : true
      #add_button    : @module 'button_add' :
      #  text      : '+Добавить'
      #  selector  : 'edit_add'
    #hint        : @module 'tutor/hint' :
    #  selector  : 'horizontal'
    #  header    : ''
    #  text      : ''


