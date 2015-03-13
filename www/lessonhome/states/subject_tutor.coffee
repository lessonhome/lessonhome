
class @main
  tree : -> module '$' :
    subject                : module 'tutor/forms/drop_down_list' :
      text      : 'Предмет :'
      selector  : 'first_reg'
    list_course             : module 'tutor/forms/drop_down_list' :
      text      : 'Курс :'
      selector  : 'first_reg'
    categories_of_students : module 'tutor/forms/drop_down_list' :
      text      : 'Категория ученика :'
      selector  : 'first_reg'
    place                  : module 'tutor/forms/drop_down_list' :
      text      : 'Место :'
      selector  : 'first_reg place'
    price                  : module 'tutor/forms/input' :
      text      : 'Цена :'
      selector  : 'first_reg price'
    price_button           : module 'button_add' :
      text      : '+'
      selector  : 'plus'
    students_in_group       : module 'tutor/forms/drop_down_list' :
      text      : 'Групповые занятия :'
      selector  : 'first_reg group'
    group_lessons_bet       : module 'tutor/forms/drop_down_list' :
      placeholder : 'Ставка'
      selector    : 'first_reg bet'
    comments                : module 'tutor/forms/textarea' :
      height    : '80px'
      text      : 'Комментарии :'
      selector  : 'first_reg'
    add_button              : module 'tutor/button' :
      text     : '+Добавить'
      selector : 'reg_add'












