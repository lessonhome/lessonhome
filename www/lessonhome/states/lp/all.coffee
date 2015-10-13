class @main  extends @template '../lp'
  route : '/lp_all'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  access : ['other']
  redirect : {

  }
  tree : =>
    content : @module '$':
      tutors :[
        @module 'main/tutor_list/tutor':
          name : 'Конон Екатерина Владимировна'
          description : 'Индивидуальное обучение на гитаре — акустической, классической и электрогитаре в Одинцово и Одинцовском районе. Игорь Хотинский — профессиональный гитарист, работавший с Игорем Ивановым в группе «Кинематограф», с Юрием Лозой, с Женей Белоусовым, с Александром Малининым и другими составами.'
          experience  : 'Преподаватель ВУЗа, опыт более 4 лет'
          subject : 'Ритульаные жертвоприношения, Окультизм, Латынь'
          location  : 'Москва м. Перово'
          price : 500
          photo : 'https://lessonhome.ru/file/5453ab9948/user_data/images/323e35c6f4l.jpg'
        @module 'main/tutor_list/tutor':
          name : 'Бубенкова Галина Юрьевна'
          description : 'Семья, дочь, большой опыт преподавания, устного перевода общения с носителями. Особенно люблю преподавать старшеклассникам, студентам и взрослым.'
          experience  : 'Частный преподаватель, опыт 1-2 года'
          subject : 'Демонология, Гадание на костях'
          location  : 'Москва м. Университет'
          price : 1500
          photo : 'https://lessonhome.ru/file/f46da49a1e/user_data/images/7c68d58025l.jpg'
      ]
      top_form  : @module 'main/fastest_top'