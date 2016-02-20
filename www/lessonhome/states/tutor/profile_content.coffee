class @main
  forms : [{person : ['documents','photos','eperiod','equalification','echair','efaculty','ename','ecity','workplace','avatar','first_name','middle_name','interests','last_name','birthdate','city']},{tutor:['status','experience','about']}]
  tree : => @module '$'  :
    popup               : @exports()
    photo : @module 'add_photos' :
      photo : $form : person : 'avatar'
      min : true
      depend : [
        @module 'lib/jquery/ui_widget'
        @module 'lib/jquery/iframe_transport_plugin'
        @module 'lib/jquery/fileupload'
      ]

    media : @module '$/media' :
      photos : $form : person : 'photos'
      message: "Сделать главной"
      depend : [
        @module 'lib/jquery/ui_widget'
        @module 'lib/jquery/iframe_transport_plugin'
        @module 'lib/jquery/fileupload'
      ]

    documents : @module '$/media' :
      photos : $form : person : 'documents'
      depend : [
        @module 'lib/jquery/ui_widget'
        @module 'lib/jquery/iframe_transport_plugin'
        @module 'lib/jquery/fileupload'
      ]
    avatars : @module '$/media' :
      photos : $form : person : 'photos_avatars'
      message: "Сделать главной"
      depend : [
        @module 'lib/jquery/ui_widget'
        @module 'lib/jquery/iframe_transport_plugin'
        @module 'lib/jquery/fileupload'
      ]
    #all_rating          : @module '../rating_star':
    #  filling  : 40
    #progress            : @exports()
    count_review        : @exports()
    send_bid_this_tutor : @exports()
    first_name  : $form : person : 'first_name'
    middle_name : $form : person : 'middle_name'
    last_name   : $form : person : 'last_name'
    #with_verification   : true
    personal_data       : @module '$/info_block' :
      section   :
        'Дата рождения :'       : $form : person : birthdate  : (s)->
          s || '<a href="./edit/general">заполнить</a>'
        'Статус :'              : $form : tutor  : status     : (s)->
          s || '<a href="./edit/general">заполнить</a>'
        'Город :'               : $form : person : city       : (s)->
          s || '<a href="./edit/contacts">заполнить</a>'
        'Опыт репетиторства :'  : $form : tutor  : experience : (s)->
          s || '<a href="./edit/career">заполнить</a>'
        'Место работы :'        : $form : person : workplace  : (s)->
          s || '<a href="./edit/career">заполнить</a>'
    line_con            : @module 'tutor/separate_line':
      title     : 'Контакты'
      link      : './edit/contacts'
      edit      : @exports()
      selector  : 'horizon'
    contacts : @exports()
    line_edu            : @module 'tutor/separate_line':
      title     : 'Образование'
      link      : './edit/education'
      edit      : @exports()
      selector  : 'horizon'
    education           : @module '$/info_block' :
      section :
        'Город :'           : $form : person : ecity : (s)->
          s || '<a href="./edit/education">заполнить</a>'
        'Вуз :'             : $form : person : ename : (s)->
          s || '<a href="./edit/education">заполнить</a>'
        'Факультет :'       : $form : person : efaculty : (s)->
          s || '<a href="./edit/education">заполнить</a>'
        'Кафедра :'         : $form : person : echair : (s)->
          s || '<a href="./edit/education">заполнить</a>'
        'Квалификация :'    : $form : person : equalification : (s)->
          s || '<a href="./edit/education">заполнить</a>'
        'Период обучения :' : $form : person : eperiod : (s)->
          s || '<a href="./edit/education">заполнить</a>'

    line_pri            : @module 'tutor/separate_line':
      title     : 'О себе'
      link      : './edit/about'
      edit      : @exports()
      selector  : 'horizon'
    about            : @module '$/info_block' :
      selector : 'about'
      section :
        'Интересы :'       : $form : person : interests : (s)->
          s || '<a href="./edit/about">заполнить</a>'
        'О себе :'       : $form : tutor : about : (s)->
          s || '<a href="./edit/about">заполнить</a>'
    line_med            : @module 'tutor/separate_line':
      title    : 'Фотографии'
      link      : '#'
      upload_input : @module 'media_upload' :
        type: 'photos'
      add     : @exports()
      selector : 'horizon'
    line_doc            : @module 'tutor/separate_line':
      title    : 'Документы'
      link      : '#'
      upload_input : @module 'media_upload' :
        type: 'documents'
      add     : @exports()
      selector : 'horizon'
    line_avatars            : @module 'tutor/separate_line':
      title    : 'Фотографии профиля'
      link      : '#'
      upload_input : @module 'media_upload' :
        type: 'avatars'
      add     : @exports()
      selector : 'horizon'
    #media               : @module '$/media' :
    #  photo1  : @module 'mime/photo' :
    #    src : @F 'vk.unknown.man.jpg'
    #  photo2  : @module 'mime/photo' :
    #    src : @F 'vk.unknown.man.jpg'
    #  video   : @module 'mime/video' :
    #    src : @F 'vk.unknown.man.jpg'

