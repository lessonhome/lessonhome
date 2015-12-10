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
      filter_tags: @module '$/filter_tags' :
        value :
          filter  : $urlform : tutorsFilter : ''
          default_filter  : $durlform : mainFilter : ''
      search_filter: @module '$/search_filter':
        value :
          filter  : $urlform : tutorsFilter : ''
          default_filter  : $durlform : mainFilter : ''
        subject_list: @const('filter').subjects
          ###
          popular :
            group: 'Популярные предметы'
            items: ["английский язык","математика","русский язык","музыка","физика","химия","биология","история","литература","начальная школа","подготовка к школе"]
          languages :
            group: 'Иностранные языки'
            items: ["английский язык","немецкий язык","французский язык","испанский язык","арабский язык","венгерский язык","голландский язык","греческий язык","датский язык","иврит","итальянский язык","китайския язык","корейский язык","латынь","норвежский язык","польский язык","португальский язык","сербский язык","турецкий язык","финский язык","хинди","чешский язык","шведский язык","японский язык"]
          music :
            group: 'Музыка'
            items: ["музыка","вокал","гитара","скрипка","сольфеджио","флейта","фортепиано"]
          other :
            group: 'Другое'
            items: ["обществознание","информатика","программирование","логопеды","актёрское мастерство","алгебра","бухгалтерский учёт","высшая математика","география","геометрия","компьютерная графика","логика","макроэкономика","математический анализ","менеджмент","микроэкономика","оригами","правоведение","психология","рисование","риторика","статистика","теоретическая механика","теория вероятностей","философия","черчение","шахматы","эконометрика","экономика","электротехника"]
          ###
        training_direction:
          items: @const('filter').course
        price_select:
          items: @const('filter').price
        status_tutor:
          items: @const('filter').status
        sex:
          items: @const('filter').sex
        

      tutor : @module 'main/tutor_list/tutor':
        name : 'Конон Екатерина Владимировна'
        description : 'Индивидуальное обучение на гитаре — акустической, классической и электрогитаре в Одинцово и Одинцовском районе. Игорь Хотинский — профессиональный гитарист, работавший с Игорем Ивановым в группе «Кинематограф», с Юрием Лозой, с Женей Белоусовым, с Александром Малининым и другими составами.'
        experience  : 'Преподаватель ВУЗа, опыт более 4 лет'
        subject : 'Ритульаные жертвоприношения, Окультизм, Латынь'
        location  : 'Москва м. Перово'
        price : 500
        photo : 'https://lessonhome.ru/file/5453ab9948/user_data/images/323e35c6f4l.jpg'
