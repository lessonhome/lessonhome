class @main
  forms : [{'tutor':['calendar', 'subject', 'srange', 'sduration', 'splace', 'scategory_of_student'], person:['location', 'address', 'area']}]
  tree : => @module '$' :
    ###
    line_place  : @module 'tutor/separate_line' :
      title     : 'Место :'
      link      : './edit/location'
      edit      :  @exports()
      selector  : 'horizon'

    ###
    selector: @exports()
    address_time  : @module 'tutor/profile_content/title_block'  :
      title     : @exports 'address_time_title'
      #title_two   : 'Свободное время'
      selector  : 'address_time'                         #variable class in sass
    map : @module 'maps/yandex'
    address : @exports()               # in pair with map
    calendar: @module 'new_calendar' :
      selector: 'tutor_profile'
      click_ability: @exports()
      value     : $form : tutor : 'calendar'
    ###
      show_calendar      : @module '$/show_calendar' :
        day_time : @exports 'calendar'
        separate_line       : @module '../separate_line'  :
          selector  : 'calendar'
    ###
    outside_work_areas  : @exports()
    ###
      line_subject  : @module 'tutor/separate_line' :
        title     : 'Предметы'
        link      : './edit/subjects'
        edit      :  @exports()
        selector  : 'horizon'

    ###
    subject: @exports()
    details_data: @exports()
