class @main  extends @template '../lp'
  route : '/lp_all'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  access : ['other']
  redirect : {

  }
  tree : =>
    content : @module '$':
      lib_diff  : @module 'lib/diff'
      tutor : @module 'main/tutor_list/tutor':
        name : 'Конон Екатерина Владимировна'
        description : 'Индивидуальное обучение на гитаре — акустической, классической и электрогитаре в Одинцово и Одинцовском районе. Игорь Хотинский — профессиональный гитарист, работавший с Игорем Ивановым в группе «Кинематограф», с Юрием Лозой, с Женей Белоусовым, с Александром Малининым и другими составами.'
        experience  : 'Преподаватель ВУЗа, опыт более 4 лет'
        subject : 'Ритульаные жертвоприношения, Окультизм, Латынь'
        location  : 'Москва м. Перово'
        price : 500
        photo : 'https://lessonhome.ru/file/5453ab9948/user_data/images/323e35c6f4l.jpg'
      top_form  : @module 'main/fastest_top'
      bottom_block_attached : @module 'main/attached_panel' :
        bottom_bar  : @state 'main/attached_panel/bar'
        popup       : @state 'main/attached_panel/popup'
      button_attach : @module 'link_button' :
        text : 'Оформить заявку'
        selector : 'view'
      value :
        phone : $urlform : pupil : 'phone'
        name : $urlform : pupil : 'name'
      filter : @exports()
      photo_src : @exports()
      title : @exports()
      sub_title : @exports()
      text : @exports()
      title_suit_tutors : @exports()
      landing_img: @exports()
      title_position: @exports()
      button_color: @exports()
      bg_position : @exports()
      opacity_form: @exports()
      ###
      tutors : do Q.async =>
        #console.log @req.urlData.filterHash()
        yield console.log @req.udata
        m = []
        for i in [0...5]
          m.push @module 'main/tutor_list/tutor':
            name : 'Конон Екатерина Владимировна'
            description : 'Индивидуальное обучение на гитаре — акустической, классической и электрогитаре в Одинцово и Одинцовском районе. Игорь Хотинский — профессиональный гитарист, работавший с Игорем Ивановым в группе «Кинематограф», с Юрием Лозой, с Женей Белоусовым, с Александром Малининым и другими составами.'
            experience  : 'Преподаватель ВУЗа, опыт более 4 лет'
            subject : 'Ритульаные жертвоприношения, Окультизм, Латынь'
            location  : 'Москва м. Перово'
        return m
      ###


