class @main
  tree : -> module '$' :
    subject_tag     : module 'selected_tag' :
      close     : false
      text      : data('tutor').get('subjects').then (s)-> s.name
      selector  : 'choose_subject'
    #qualification     : module 'tutor/forms/drop_down_list' :
    #  text      : 'Квалификация :'
    #  selector  : 'first_reg'
    course     : module 'tutor/forms/drop_down_list' :
      text      : 'Направление подготовки :'
      selector  : 'first_reg'
      default_options     : {
        '0': {value: 'ege', text: 'ЕГЭ'},
        '1': {value: 'gia', text: 'ГИА'}
      }
      #alue: data('tutor').get('subjects').then (s)-> return s.tags[0] if s.tags?[0]?
    pre_school      : module 'tutor/forms/checkbox' :
      text      : 'дошкольники'
      selector  : 'small font_16'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.tags, "school:0")
    junior_school   : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'младшая школа'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.tags, "school:1")
    medium_school   : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'средняя школа'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.tags, "school:2")
    high_school     : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'старшая школа'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.tags, "school:3")
    student         : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'студент'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.tags, "student")
    adult           : module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'взрослый'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.tags, "adult")
    place_price_tutor : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'У РЕПЕТИТОРА'
    place_price_pupil : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'У УЧЕНИКА'
    place_price_remote : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'УДАЛЕННО'
    place_price_group : state 'tutor/profile_content/registration_popup/place_price'  :
      title : 'ГРУППОВЫЕ'
    price_slider   : state 'main/slider_main' :
      selector      : 'price_fast_reg'
      start         : 'calendar'
      start_text    : ''
      end         : module 'tutor/forms/input' :
        selector  : 'calendar'
        align     : 'center'
      dash          : '-'
      measurement   : 'руб.'
      handle        : true
      value         :
        min : 400
        max : 5000
        left : 600
        right : 900

    duration :   module 'tutor/forms/input' :
      text2      : 'Время занятия :'
      selector  : 'first_reg'
      #value: data('tutor').get('subjects').then (s)-> s.price?[0]?.duration

    place_tutor      : module 'tutor/forms/checkbox' :
      text      : 'у себя'
      selector  : 'small font_16'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.place, "tutor")
    place_pupil      : module 'tutor/forms/checkbox' :
      text      : 'у ученика'
      selector  : 'small font_16'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.place, "pupil")
    place_remote      : module 'tutor/forms/checkbox' :
      text      : 'удалённо'
      selector  : 'small font_16'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.place, "remote")
    place_cafe      : module 'tutor/forms/checkbox' :
      text      : 'другое место'
      selector  : 'small font_16'
      #value     : data('tutor').get('subjects').then (s)-> data('convert').tutorTagToCheckbox(s.place, "other")
    group_learning         : module 'tutor/forms/drop_down_list' :
      text      : 'Групповые занятия :'
      selector  : 'first_reg'
      default_options     : {
        '0': {value: 'russia', text: 'Россия'},
        '1': {value: 'ukraine', text: 'Украина'},
        '2': {value: 'belarus', text: 'Белоруссия'}
      }
      #value : data('tutor').get('subjects').then (s)-> return s.groups[0].description if s?.groups?[0]?.description?
    comments          : module 'tutor/forms/textarea' :
      height    : '80px'
      text      : 'Комментарии :'
      selector  : 'first_reg'
      #value     : data('tutor').get('subjects').then (s)-> return s.description if s?.description?


