
class @main extends @template '../tutor_profile'
  route: '/profile/subjects'
  model : 'main/tutor_profile_general'
  title : "Анкета репетитора предметы и расположение"
  access : ['other','pupil']
  tree : =>
    selector: 'subjects'
    g_selector : 'profile_nav'
    s_selector: 'profile_nav_active'
    r_selector: 'profile_nav'
    content : @state 'tutor/profile_content/conditions_content' :
      selector: 'list_tutors'
      address_time_title : 'Москва, Бибирево'
      address: 'Бибиберевская 3'
      calendar:  ''
      outside_work_areas: 'Марьино, Выхино'
      subject       : @module 'tutor/profile_content/title_block'  :
        title     : 'Математика'
        details   : 'ЕГЭ, ГИА'
        selector  : 'subject'
      details_data  : @module 'tutor/profile_content/conditions_content/details_data' :
        line_horizon  :  @module 'tutor/separate_line' :
          selector  : 'horizon'
        price_from : '1200'
        price_till : '2000'
        subject_data        : @module 'tutor/profile_content/info_block' :
          section :
            'Категория ученика :'           : 'школьник 8-11 классов, студенты'
            'Комментарии :'                 : 'олимпиадные задачи школьного уровня, операционные системы'
            'Групповые занятия :'           : 'до 5 человек, по 1000 рублей'
            'Место занятий :'               : 'у ученика, у себя'
            'Продолжительность :'           :  '60-90 минут'
          selector : 'subject_class'
          line_horizon  :  @module 'tutor/separate_line' :
            selector  : 'horizon'
        line_vertical : @module 'tutor/separate_line':
          selector  : 'vertical'