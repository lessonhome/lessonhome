class @main extends @template 'lp'
  route : '/tutors_search'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Профиль репетитора"
  tags   : [ 'tutor:reports']
  access : ['other']
  redirect : {
  }
  tree : =>
    content : @module '$':
      tutor : @module 'main/tutor_list/tutor':
        name : 'Конон Екатерина Владимировна'
        description : 'Индивидуальное обучение на гитаре — акустической, классической и электрогитаре в Одинцово и Одинцовском районе. Игорь Хотинский — профессиональный гитарист, работавший с Игорем Ивановым в группе «Кинематограф», с Юрием Лозой, с Женей Белоусовым, с Александром Малининым и другими составами.'
        experience  : 'Преподаватель ВУЗа, опыт более 4 лет'
        subject : 'Ритульаные жертвоприношения, Окультизм, Латынь'
        location  : 'Москва м. Перово'
        price : 500
        photo : 'https://lessonhome.ru/file/5453ab9948/user_data/images/323e35c6f4l.jpg'