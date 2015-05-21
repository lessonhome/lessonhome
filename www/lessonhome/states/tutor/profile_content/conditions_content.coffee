class @main
  forms : [{'tutor':['calendar', 'subject', 'srange', 'sduration', 'splace', 'scategory_of_student'], person:['location', 'address', 'area']}]
  tree : -> module '$' :
    line_place  : module 'tutor/separate_line' :
      title     : 'Место :'
      link      : './edit/location'
      edit      :  @exports()
      selector  : 'horizon'
    address_time  : module 'tutor/profile_content/title_block'  :
      title     :  $form : person : 'area'
      #title_two   : 'Свободное время'
      selector  : 'address_time'                         #variable class in sass
    map : module 'maps/yandex'
    address : $form : person : 'address'                 # in pair with map
    show_calendar      : module '$/show_calendar' :
      day_time : $form : tutor : 'calendar'
      separate_line       : module '../separate_line'  :
        selector  : 'calendar'
    outside_work_areas  : $form : tutor : 'check_out_the_areas'
    line_subject  : module 'tutor/separate_line' :
      title     : 'Предметы'
      link      : './edit/subjects'
      edit      :  @exports()
      selector  : 'horizon'
    subject       : module 'tutor/profile_content/title_block'  :
      title     : $form : tutor : 'subject.name'
      details   : $form : tutor : 'subject.tags.0'
      selector  : 'subject'
    details_data  : module '$/details_data' :
      line_horizon  :  module 'tutor/separate_line' :
        selector  : 'horizon'
      price_from : $form : tutor : 'srange.left'
      price_till : $form : tutor : 'srange.right'
      subject_data        : module 'tutor/profile_content/info_block' :
        section :
          'Категория ученика :'           : $form : tutor : 'scategory_of_student'
          'Комментарии :'                 : $form : tutor : 'subject.description'
          'Групповые занятия :'           : $form : tutor : 'subject.groups.0.description'
          'Место занятий :'               : $form : tutor : 'splace'
          'Продолжительность :'           : $form : tutor : 'sduration'
        selector : 'subject_class'
        line_horizon  :  module 'tutor/separate_line' :
          selector  : 'horizon'
      line_vertical : module 'tutor/separate_line':
        selector  : 'vertical'