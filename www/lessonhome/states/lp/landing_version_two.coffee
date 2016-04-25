class @main extends @template '../lp'
  route: '/lp/template'
  model: 'tutor/bids/reports'
  title: 'Lessonhome - бесплатный подбор репетитора для сдачи егэ по английскому языку'
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree: =>
    content: @module '$':
      title: @exports()
      tutors_title: @exports()
      title_custom_position: @exports()
      top_img: @exports()
      shadow_bg: @exports()
      dotted_bg: @exports()
      top_right: @exports()
      title_color: @exports()
      bg_color: @exports()
      bottom_custom_text: @exports()
      bottom_bg: @exports()
      id_page: 'landing_page'
      hide_head_button: true
      hide_menu_punkt: true
      opacity_header: true
      work_steps_show: @exports()
      result_show: @exports()
      work_steps: @state './work_steps'
      comments_landing: @exports()
      comments_img: @exports()
      comments_show: @exports()
      bg_position: @exports()
      result: @state './result'
      filter : @exports()
      value :
        phone : $urlform : pupil : 'phone'
        name  : $urlform : pupil : 'name'
      short_attach : @module 'short_form/js_form' :
        value : $urlform : pupil : ''
      tutors : $defer : =>
        @tree.content.filter ?= {}
        @tree.content.filter.page = 'landing'
        filter = yield Feel.udata.d2u "mainFilter",@tree.content.filter
        hash = yield Feel.udata.filterHash filter,'filter'
        filter = yield Feel.udata.u2d filter
        jobs = yield Main.service 'jobs'
        o = yield jobs.solve 'filterTutors',{filter:{data:filter.mainFilter,hash},count:6,from:0}
        o ?= {}
        o.preps ?= {}
        modules = for index,prep of o.preps
          @state './tutor_card':
            value:prep
            main_subject : _setKey @tree.content.filter,'subject.0'
        modules = yield Q.all modules
        return modules
      comments_landing: @state 'lp/comments_landing':
        comments:
          {
            '0':
              {
                name: 'Наталия',
                userpic_src: '/lp/comments_avatar/userpic_01.jpg',
                description: 'Долгое время искала репетитора для подготовки к ЕГЭ. Наткнулась на сервис Lesson Home. Сайт мне очень понравился, простой и удобный, множество педагогов. Я быстро нашла нужного репетитора. Спасибо вам большое!!!',
                date: '21.12.15'
              }
            '1':
              {
                name: 'Анна',
                userpic_src: '/lp/comments_avatar/userpic_02.jpg',
                description: 'Искали репетитора по математике для сына,  нам очень помог ваш сервис. Быстро и легко нашли нужного человека, подтянули отметки и будем дальше заниматься. Теперь хочу найти еще педагога для старшей дочери, и может быть для себя по иностранному языку',
                date: '25.02.2016'
              }
            '2':
              {
                name: 'Антон',
                userpic_src: '/lp/comments_avatar/userpic_03.jpg',
                description: 'Очень хороший и удобный сервис для поиска репетитора. Нашли педагога в своем районе и по очень доступной цене. Всем рекомендую.',
                date: '10.11.2015'
              }
            '3':
              {
                name: 'Анатолий',
                userpic_src: '/lp/comments_avatar/userpic_04.jpg',
                description: 'Искал репетитора для себя по китайскому языку, нашел хорошего специалиста только на сайте LessonHome.ru. Бесплатно подобрали нужного репетитора, на следующий день уже начал заниматься.',
                date: '23.01.2016'
              }
            '4':
              {
                name: 'Маргарита',
                userpic_src: '/lp/comments_avatar/userpic_05.jpg',
                description: 'Оказалось, найти репетитора в таком большом городе не так то и просто! Срочно нужно было подтянуть сына по некоторым предметам, для перехода в 5 класс, и нигде не могли найти подходящего специалиста, помог только ваш сайт, за что огромное вам спасибо!',
                date: '18.12.2015'
              }
            '5':
              {
                name: 'Михаил',
                userpic_src: '/lp/comments_avatar/userpic_06.jpg',
                description: 'Приятным удивлением для меня стал сайт lessonhome.ru, поиск репетитора занял всего несколько минут, со мной связались, помогли найти компетентного специалиста, по очень выгодной цене.',
                date: '03.03.2016'
              }
            '6':
              {
                name: 'Вероника',
                userpic_src: '/lp/comments_avatar/userpic_07.jpg',
                description: 'Простой и удобный сервис, то, что нужно для подбора репетитора, есть возможность поиска по району, цене и направлению подготовки. Все доступно и просто!',
                date: '17.01.2016'
              }
            '7':
              {
                name: 'Мария',
                userpic_src: '/lp/comments_avatar/userpic_08.jpg',
                description: 'Нужно было ехать за границу, и срочно понадобился репетитор, чтобы подтянуть английский язык. Оставила заявку на нескольких сайтах, первыми позвонили из lessonhome и предложили несколько отличных специалистов.',
                date: '18.03.2016'
              }
            '8':
              {
                name: 'Дарья',
                userpic_src: '/lp/comments_avatar/userpic_09.jpg',
                description: 'Благодаря удобству и простоте вашего сервиса, нашли хорошего репетитора для ребенка, и всего после нескольких занятий, появились заметные улучшения и уверенность в школе.',
                date: '26.01.2016'
              }
            '9':
              {
                name: 'София',
                userpic_src: '/lp/comments_avatar/userpic_10.jpg',
                description: 'Очень оперативно сработали специалисты LessonHome, быстро перезвонили, уточнили детали, через 10 минут у меня уже был список из нескольких вполне компетентных специалистов, из которых я впоследствии и выбрала педагога, с которым сейчас занимается мой ребенок.',
                date: '10.12.2015'
              }
            '10':
              {
                name: 'Анжелика',
                userpic_src: '/lp/comments_avatar/userpic_11.jpg',
                description: 'Начали заниматься в феврале, и уже есть ощутимые результаты! Нашли репетитора благодаря сервису LessonHome, быстро и оперативно!',
                date: '18.02.2016'
              }
            '11':
              {
                name: 'Алексей',
                userpic_src: '/lp/comments_avatar/userpic_12.jpg',
                description: 'Очень грамотные специалисты работают в LessonHome, не успел оставить заявку, со мной тут же связались и предложили несколько подходящих вариантов, осталось только выбрать понравившегося репетитора. Спасибо большое!',
                date: '05.04.2016'
              }
          }
       
