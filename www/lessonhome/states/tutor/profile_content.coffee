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
    with_verification   : true
    personal_data       : module '$/info_block' :
      section   :
        'Дата рождения :'       : data('person').get('birthday').then (b)-> data('convert').convertToDate b if b?
        'Статус :'              : data('tutor').get('status').then (s)-> data('convert').convertTutorStatusToRus s if s?
        'Город :'               : data('person').get('location').then (l)-> l?.city
        'Опыт репетиторства :'  : data('tutor').get('experience').then (e_)->
          return e_ if e_? && e_?.length
          return data('convert').getLinkToFill "./edit/career"
        'Место работы :'        : data('person').get('work').then (w)->
          return w.pop().name if w?.pop?().name? && w?.pop?().name?.length
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
        'ВУЗ :'         : data('person').get('education').then (edu)->
          return edu.pop().name if edu?.pop?().name? && edu?.pop?().name?.length
          return data('convert').getLinkToFill "./edit/education"
        'Город :'       : data('person').get('education').then (edu)->
          return edu.pop().city if edu?.pop?().city? && edu?.pop?().city?.length
          return data('convert').getLinkToFill "./edit/education"
        'Фаультет :'    : data('person').get('education').then (edu)->
          return edu.pop().faculty if edu?.pop?().faculty? && edu?.pop?().faculty?.length
          return data('convert').getLinkToFill "./edit/education"
        'Кафедра :'     : data('person').get('education').then (edu)->
          return edu.pop().chair if edu?.pop?().chair? && edu?.pop?().chair?.length
          return data('convert').getLinkToFill "./edit/education"
        'Квалификация :'      : data('person').get('education').then (edu)->
          return edu.pop().qualification if edu?.pop?().qualification? && edu?.pop?().qualification?.length
          return data('convert').getLinkToFill "./edit/education"
        'Год выпуска:'  : data('person').get('education').then (edu)->
          return edu.pop().period.end if edu?.pop?().period?.end? && edu?.pop?().period?.end?.length
          return data('convert').getLinkToFill "./edit/education"

    line_pri            : module 'tutor/separate_line':
      title     : 'О себе'
      link      : './edit/about'
      edit      : @exports()
      selector  : 'horizon'
    private_            : module '$/private' :
      text : data('tutor').get('about')
      #'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut laLorem ipsum dolor sit amet, consectetur adipisicing elit'
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
