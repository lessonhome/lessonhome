class @main  extends @template '../lp'
  route : '/lp_all'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  access : ['other']
  redirect : {

  }
  tree : =>
    content : @module '$':
      tutor : @module 'main/tutor_list/tutor':
        value : {"index":110672,"link":"/tutor_profile?L=110672","name":"Татьяна Сереевна","subject":"Химия, Биология, Русский язык","experience":"Частный преподаватель, опыт 3-4 года","about":"Расширяю горизонты всех людей, которые со мной встречаются и общаются. \nПоказываю разнообразные взгляды на мир, учу мыслить самостоятельно, критично.\nНавыки, полученные на занятиях каждый ученик применяет и оттачивает, поэтому они не забываются годами и результаты положительны и доставляют удовольствие.\nВсегда преподаю по принципу: \"Не для школы учимся - для жизни\".","location":"Москва","left_price":1000,"photos":"/file/d1692783eb/user_data/images/768998dcf5l.jpg","metro_tutors":{"altufevo":{"metro":"Алтуфьево","color":"metro_grey"},"timiryazevskaya":{"metro":"Тимирязевская","color":"metro_grey"},"savelovskaya":{"metro":"Савёловская","color":"metro_grey"},"dmitrovskaya":{"metro":"Дмитровская","color":"metro_grey"},"petrovsko-razumovskaya":{"metro":"Петровско-Разумовская","color":"metro_grey"},"vladykino":{"metro":"Владыкино","color":"metro_grey"}}}
      top_form  : @module 'main/fastest_top'
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


