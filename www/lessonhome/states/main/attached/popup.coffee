class @main
  tree: => @module '$':
    first : @module 'main/fast_bid/first_step' :
      type_form: 'boring'
      name : @module 'tutor/forms/input' :
        text1      : 'Имя :'
        selector  : 'fast_bid'
        value     : $urlform : pupil : 'name'  #$form : person : 'first_name'
      phone : @module 'tutor/forms/input':
        text1: 'Телефон :'
        selector  : 'fast_bid'
        value     : $urlform : pupil : 'phone'
#      call_time : @module 'tutor/forms/textarea' :
#        text: 'В какое время Вам звонить :'
#        selector  : 'fast_bid'
#        value     : $urlform : pupil : 'phone_comment'
      email : @module 'tutor/forms/input':
        text1: 'E-mail :'
        selector  : 'fast_bid'
        value     : $urlform : pupil : 'email'

#      subject :@module 'tutor/forms/drop_down_list':
#        selector  : 'fast_bid'
#        smart : true
#        self : true
#        sort : true
#        filter : true
#        items : ["английский язык","математика","русский язык","музыка","физика","химия","немецкий язык","начальная школа","франзузский язык","обществознание","информатика","программирование","испанский язык","биология","логопеды","актёрское мастерство","алгебра","арабский язык","бухгалтерский учёт","венгерский язык","вокал","высшая математика","география","геометрия","гитара","голландский язык","греческий язык","датский язык","иврит","история","итальянский язык","китайския язык","компьютерная графика","корейский язык","латынь","литература","логика","макроэкономика","математический анализ","менеджмент","микроэкономика","начертательная геометрия","норвежский язык","оригами","подготовка к школе","польский язык","португальский язык","правоведение","психология","рисование","риторика","рки","сербский язык","скрипка1","сольфеджио","сопротивление материалов","статистика","теоретическая механика","теория вероятностей","турецкий язык","философия","финский язык","флейта","фортепиано","хинди","черчение","чешский язык","шахматы","шведский язык","эконометрика","экономика","электротехника","японский язык"]
#        value     : $urlform : pupil : 'subject'
#
#      comments : @module 'tutor/forms/textarea':
#        text: 'Комментарии :'
#        selector  : 'fast_bid'
#        value : $urlform : pupil : 'subject_comment'

    subject :@module 'tutor/forms/drop_down_list':
      selector  : 'write_tutor'
      smart : true
      self : true
      sort : true
      filter : true
      items : ["английский язык","математика","русский язык","музыка","физика","химия","немецкий язык","начальная школа","франзузский язык","обществознание","информатика","программирование","испанский язык","биология","логопеды","актёрское мастерство","алгебра","арабский язык","бухгалтерский учёт","венгерский язык","вокал","высшая математика","география","геометрия","гитара","голландский язык","греческий язык","датский язык","иврит","история","итальянский язык","китайския язык","компьютерная графика","корейский язык","латынь","литература","логика","макроэкономика","математический анализ","менеджмент","микроэкономика","начертательная геометрия","норвежский язык","оригами","подготовка к школе","польский язык","португальский язык","правоведение","психология","рисование","риторика","рки","сербский язык","скрипка1","сольфеджио","сопротивление материалов","статистика","теоретическая механика","теория вероятностей","турецкий язык","философия","финский язык","флейта","фортепиано","хинди","черчение","чешский язык","шахматы","шведский язык","эконометрика","экономика","электротехника","японский язык"]
      value     : $urlform : pupil : 'subject'

    second : @module 'main/fast_bid/second_step' :
      type_form: 'boring'
      pupil: @module 'tutor/forms/checkbox' :
        text      : 'У себя'
        selector  : 'small'
        value : $urlform : mainFilter : 'place_attach.pupil'
      tutor: @module 'tutor/forms/checkbox' :
        text      : 'У репетитора'
        selector  : 'small'
        value : $urlform : mainFilter : 'place_attach.tutor'
      remote: @module 'tutor/forms/checkbox'  :
        text      : 'Удалённо'
        selector  : 'small'
        value : $urlform : mainFilter : 'place_attach.remote'

      calendar        : @module 'new_calendar' :
        selector    : 'bids'
        value : $urlform : pupil : 'calendar'

      time_spend_lesson   : @state '../slider_main' :
        selector      : 'time_fast_bids'
        default :
          left : 45
          right : 180
        dash          : '-'
        measurement   : 'мин.'
        min : 30
        max : 240
        left  : $urlform : pupil : 'duration.left'#'newBid.subjects.0.lesson_duration.0'
        right : $urlform : pupil : 'duration.right'#'newBid.subjects.0.lesson_duration.1'
        division_value : 5
        type : 'default'
      price   : @state '../slider_main' :
        selector      : 'time_fast_bids'
        default :
          left : 400
          right : 5000
        dash          : '-'
        measurement   : 'мин.'
        min : 400
        max : 5000
        left  : $urlform : pupil : 'price.left'#'newBid.subjects.0.lesson_duration.0'
        right : $urlform : pupil : 'price.right'#'newBid.subjects.0.lesson_duration.1'
        division_value : 50
        type : 'default'
    third : @module 'main/fast_bid/third_step' :
      type_form: 'boring'
      student : @module 'tutor/forms/checkbox'  :
        text      : 'Студент'
        selector  : 'small'
        value : $urlform : pupil : 'status.student'
      teacher : @module 'tutor/forms/checkbox'  :
        text      : 'Преподаватель школы'
        selector  : 'small'
        value : $urlform : pupil : 'status.school_teacher'

      professor : @module 'tutor/forms/checkbox'  :
        text      : 'Преподаватель ВУЗа'
        selector  : 'small'
        value : $urlform : pupil : 'status.high_school_teacher'
      native : @module 'tutor/forms/checkbox'  :
        text      : 'Носитель языка'
        selector  : 'small'
        value : $urlform : pupil : 'status.native_speaker'
      experience : @module 'tutor/forms/drop_down_list':
        selector  : 'fast_bid'
        self : false
        no_input : true
        default_options     : {
          '0': {value: 'no_matter', text: 'неважно'}
          '1': {value: '1-2years', text: '1-2 года'},
          '2': {value: '3-4years', text: '3-4 года'},
          '3': {value: 'more_than_4_years', text: 'более 4 лет'},
        }
        value : $urlform : pupil : 'experience'
      gender_data : @module 'tutor/forms/drop_down_list':
        selector  : 'fast_bid'
        items : ['неважно','мужской','женский']
        slef : false
        no_input : true
        value : $urlform : pupil : 'gender'
    btn_send : @module 'link_button' :
      text : 'Отправить'
      selector : 'invite'