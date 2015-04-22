class @main
  tree : -> module '$' :
    subject_tag     : module 'selected_tag' :
      close     : false
      text      : 'Математика'
      selector  : 'choose_subject'
    #qualification     : module 'tutor/forms/drop_down_list' :
      text      : 'Квалификация :'
      selector  : 'first_reg'
    course     : module 'tutor/forms/drop_down_list' :
      text      : 'Направление подготовки :'
      selector  : 'first_reg'
    pre_school      : module 'tutor/forms/checkbox' :
      text      : 'дошкольники'
      selector  : 'small font_16'
    junior_school   : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'младшая школа'
    medium_school   : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'средняя школа'
    high_school     : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'старшая школа'
    student         : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'студент'
    adult           : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'взрослый'
    place_price_tutor : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'У РЕПЕТИТОРА'
    place_price_pupil : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'У УЧЕНИКА'
    place_price_remote : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'УДАЛЕННО'
    place_price_group : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'ГРУППОВЫЕ'
    price_slider   : state 'main/slider_main' :
      selector      : 'price_slider_bids'
      start         : 'calendar'
      start_text    : ''
      end         : module 'tutor/forms/input' :
        selector  : 'calendar'
        text2     : ''
        align     : 'center'
      dash          : '-'
      measurement   : 'руб.'
      handle        : true
      min           : 400
      max           : 5000

    duration :   module 'tutor/forms/input' :
      text2      : 'Время занятия :'
      selector  : 'first_reg'

    place_tutor      : module 'tutor/forms/checkbox' :
      text      : 'у себя'
      selector  : 'small font_16'
    place_pupil      : module 'tutor/forms/checkbox' :
      text      : 'у ученика'
      selector  : 'small font_16'
    place_remote      : module 'tutor/forms/checkbox' :
      text      : 'удалённо'
      selector  : 'small font_16'
    place_cafe      : module 'tutor/forms/checkbox' :
      text      : 'другое место'
      selector  : 'small font_16'
    group_learning         : module 'tutor/forms/drop_down_list' :
      text      : 'Групповые занятия :'
      selector  : 'first_reg'
    comments          : module 'tutor/forms/textarea' :
      height    : '80px'
      text      : 'Комментарии :'
      selector  : 'first_reg'
