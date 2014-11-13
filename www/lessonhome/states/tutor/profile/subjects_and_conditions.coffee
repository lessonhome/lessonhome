@route = '/tutor/subjects_and_conditions'

@struct = state 'tutor/template/template'

@struct.content = module 'tutor/profile/subjects_and_conditions':

###############################################################################################

  address_and_free_time: module  'tutor/profile/subjects_and_conditions/address_and_free_time':
    show_address : 'Новогиреевская улица дом 12 кв 4'
    map : '#'
    calendar : '#'

###############################################################################################
  outside_work_areas : {
    'Бибирево'
    'Бирюлёво'
    'м.Крюково'
  }

  #############################################################################################

  distance_work : [
    'Skype'
    'Viber'
    'Livestream'
  ]

  #############################################################################################

  subject : module 'tutor/profile/subjects_and_conditions/subject':
    subject_name : 'Физика'
    subject_details : 'ЕГЭ,ГИА'

  #############################################################################################

  details_data : module 'tutor/profile/subjects_and_conditions/details_data' :
    outside_work_price : '1500р.'
    home_price : '1200р.'
    distance_work_price : '900р.'

    sections : 'Школьный курс'
    category_student : 'школьники 8-11 классов, студенты'
    comments : 'Олимпиадные задачи школьного уровня, операционные системы'
    group_lessons : 'до 5 человек, по 1000 р.'
    duration_lesson : '60-90 минут'


@struct.header.top_menu.active_item = 'Предметы и условия'



