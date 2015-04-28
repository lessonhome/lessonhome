class @main
  tree : -> module '$'  :
    popup               : @exports()
    photo               : module 'mime/photo' :
      photo   : data('ava').get()
      src     : F 'vk.unknown.man.jpg'
    all_rating          : module '../rating_star':
      filling  : 40
    progress            : @exports()
    count_review        : @exports()
    send_bid_this_tutor : @exports()
    first_name  : data('person').get('first_name')
    middle_name : data('person').get('middle_name')
    last_name   : data('person').get('last_name')
    #with_verification   : true
    personal_data       : module '$/info_block' :
      section   :
        'Дата рождения :'       : data('person').get('birthday').then (b)-> data('convert').convertToDate b if b?
        'Статус :'              : data('tutor').get('status').then (s)-> data('convert').convertTutorStatusToRus s if s?
        'Город :'               : data('person').get('location').then (l)-> l?.city
        'Опыт репетиторства :'  : data('tutor').get('experience').then (e_)->
          return e_ if e_? && e_?.length
          return data('convert').getLinkToFill "./edit/career"
        'Место работы :'        : data('person').get('work').then (w)->
          return w[0].place if w?[0]?.place? && w?[0]?.place?.length
          return data('convert').getLinkToFill "./edit/career"
    line_con            : module 'tutor/separate_line':
      title     : 'Контакты'
      link      : './edit/contacts'
      edit      : @exports()
      selector  : 'horizon'
    contacts : @exports()
    line_edu            : module 'tutor/separate_line':
      title     : 'Образование'
      link      : './edit/education'
      edit      : @exports()
      selector  : 'horizon'
    education           : module '$/info_block' :
      section :
        'Город :'       : data('person').get('education').then (edu)->
          return edu[0].city if edu?[0]?.city? && edu?[0]?.city?.length
          return data('convert').getLinkToFill "./edit/education"
        'ВУЗ :'         : data('person').get('education').then (edu)->
          return edu[0].name if edu?[0]?.name? && edu?[0]?.name?.length
          return data('convert').getLinkToFill "./edit/education"
        'Фаультет :'    : data('person').get('education').then (edu)->
          return edu[0].faculty if edu?[0]?.faculty? && edu?[0]?.faculty?.length
          return data('convert').getLinkToFill "./edit/education"
        'Кафедра :'     : data('person').get('education').then (edu)->
          return edu[0].chair if edu?[0]?.chair? && edu?[0]?.chair?.length
          return data('convert').getLinkToFill "./edit/education"
        'Квалификация :'      : data('person').get('education').then (edu)->
          return edu[0].qualification if edu?[0]?.qualification? && edu?[0]?.qualification?.length
          return data('convert').getLinkToFill "./edit/education"
        'Период обучения :'  : data('person').get('education').then (edu)->
          return "#{edu[0].period.start} - #{edu[0].period.end} гг." if edu?[0]?.period?.start? && edu?[0]?.period?.start?.length && edu?[0]?.period?.end? && edu?[0]?.period?.end?.length
          return data('convert').getLinkToFill "./edit/education"

    line_pri            : module 'tutor/separate_line':
      title     : 'О себе'
      link      : './edit/about'
      edit      : @exports()
      selector  : 'horizon'
    about            : module '$/info_block' :
      section :
        'Интересы :'        : 'scsdcs sdcscsd sadcsdcs SDCASDC'
        'О себе :'          : 'ssdcsds sdcdscds sdcsdcsd sdcsds sdcssd sdcsdcsd sdcsdcsd sdcsdcsd sdcsdcsd sdcsdc'
      #text : data('tutor').get('about')
    line_med            : module 'tutor/separate_line':
      title    : 'Медиа'
      link      : './edit/media'
      edit     : @exports()
      selector : 'horizon'
    media               : module '$/media' :
      photo1  : module 'mime/photo' :
        src : F 'vk.unknown.man.jpg'
      photo2  : module 'mime/photo' :
        src : F 'vk.unknown.man.jpg'
      video   : module 'mime/video' :
        src : F 'vk.unknown.man.jpg'

