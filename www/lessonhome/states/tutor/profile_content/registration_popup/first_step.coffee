class @main extends template '../registration_popup'
  route : '/tutor/profile/first_step'
  model : 'tutor/profile_registration/first_step'
  title : "первый вход"
  tree : ->
    progress  : 1
    content : module '$' :
      understand_button : module 'tutor/button' :
        selector: 'understand'
        text:      'Спасибо, я понял'
      first_name  : module 'tutor/forms/input':
        selector    : 'first_reg'
        text        : 'Имя :'
      last_name   : module 'tutor/forms/input':
        selector    : 'first_reg'
        text        : 'Фамилия :'
      patronymic  : module 'tutor/forms/input':
        selector    : 'first_reg'
        text        : 'Отчество :'
      sex_man     : module 'tutor/forms/sex_button' :
        selector    : 'man'
      sex_woman   : module 'tutor/forms/sex_button' :
        selector : 'woman'
      birth_day   : module 'tutor/forms/drop_down_list' :
        text        : 'Дата рождения :'
        placeholder : 'День'
        selector    : 'first_reg day'
      birth_month : module 'tutor/forms/unable_enter_list' :
        placeholder : 'Месяц'
        selector    : 'first_reg_size'
        type : 'unable_to_enter'
        list : [
          'Январь'
          'Февраль'
          'Март'
          'Апрель'
          'Май'
          'Июнь'
          'Июль'
          'Август'
          'Сентябрь'
          'Октябрь'
          'Ноябрь'
          'Декабрь'
        ]
      birth_year  : module 'tutor/forms/drop_down_list' :
        placeholder : 'Год'
        selector    : 'first_reg_size'
      status      : module 'tutor/forms/drop_down_list' :
        text        : 'Статус :'
        selector    : 'first_reg'

  init : ->
    @parent.tree.popup.footer.button_back.selector = 'inactive'
    @parent.tree.popup.footer.back_link = false
    @parent.tree.popup.footer.next_link = 'second_step'
