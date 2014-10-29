@route = '/tutor/conditions'

@struct = state 'tutor/template'

@struct.content = module 'tutor/profile/conditions':
  durationLesson : '45-60'
  address : module  'tutor/profile/conditions/address':
    show_address : 'Новогиреевская улица дом 12 кв 4'
  place_price : module 'tutor/profile/conditions/place_price' :
    leaving : 'Бибирево'
    telework : 'Skype'
    home : 'Да'
    price : '1000'
  subject : module 'tutor/profile/conditions/subject':
    subject_name : 'Физика'
    subject_detalis : 'ЕГЭ, ГИА'
  detalis_data : module 'tutor/profile/conditions/detalis_data' :
    leaving_prise : '1500'
    home_prise : '1000'
    telework_prise : '900'
    section : 'школьный курс'
    category_student : 'школьники 8-11'
    detalis_subject : 'Олимпиадные задачи по математике'
    group_lessons : 'до 5 человек'