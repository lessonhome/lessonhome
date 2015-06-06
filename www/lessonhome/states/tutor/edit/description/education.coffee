class @main extends @template '../edit_description'
  route : '/tutor/edit/education'
  model   : 'tutor/edit/description/education'
  title : "редактирование образования"
  tags : -> 'edit: description'
  access : ['tutor']
  redirect : {
    'other' : 'main/first_step'
    'pupil' : 'main/first_step'
  }
  forms : [{person:['edu']}]
  tree : =>
    menu_description  : 'edit: description'
    active_item : 'Образование'
    tutor_edit  : @module '$' :
      country       : module 'tutor/forms/drop_down_list' :
        text      : 'Страна :'
        selector  : 'first_reg'
        $form : person : 'edu.country'
      city          : @module 'tutor/forms/drop_down_list' :
        text      : 'Город :'
        selector  : 'first_reg'
        $form : person : 'edu.city'
      university    : @module 'tutor/forms/drop_down_list' :
        text      : 'ВУЗ :'
        selector  : 'first_reg'
        $form : person : 'edu.name'
      faculty       : @module 'tutor/forms/drop_down_list' :
        text      : 'Факультет :'
        selector  : 'first_reg'
        $form : person : 'edu.faculty'
      chair         : @module 'tutor/forms/drop_down_list' :
        text      : 'Кафедра :'
        selector  : 'first_reg'
        $form : person : 'edu.chair'
      qualification : @module 'tutor/forms/drop_down_list' :
        text      : 'Статус :'
        selector  : 'first_reg'
        $form : person : 'edu.qualification'
      learn_from    : @module 'tutor/forms/drop_down_list'  :
        text        : 'Период обучения :'
        selector    : 'first_reg_from'
        placeholder : 'с'
        $form : person : 'edu.period.start'
      learn_till    : @module 'tutor/forms/drop_down_list'  :
        selector    : 'first_reg_till'
        placeholder : 'до'
        $form : person : 'edu.period.end'
      #add_button    : module 'button_add' :
      #  text      : '+Добавить'
      #  selector  : 'edit_add'
    #hint        : module 'tutor/hint' :
    #  selector  : 'horizontal'
    #  header    : ''
    #  text      : ''


