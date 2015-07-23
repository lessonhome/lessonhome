

class @main extends @template './motivation_content'
  route : '/'
  model   : 'main/first_step'
  title : "Быстро подберем Вам лучшего репетитора"
  forms : ['pupil']
  tags  : -> 'pupil:main_search'
  access : ['other','pupil']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    popup       : @exports()
    tag         : 'pupil:main_search'
    filter_top  : @state './filter_top' :
      title           : 'Быстро подберем Вам лучшего репетитора!'
      list_subject    : @module 'tutor/forms/drop_down_list' :
        selector    : 'main_subject'
        placeholder : 'Предмет'
        smart : true
        self : true
        items : ["английский язык","математика","русский язык","музыка","физика","химия","немецкий язык","начальная школа","франзузский язык","обществознание","информатика","программирование","испанский язык","биология","логопеды","актёрское мастерство","алгебра","арабский язык","бухгалтерский учёт","венгерский язык","вокал","высшая математика","география","геометрия","гитара","голландский язык","греческий язык","датский язык","иврит","история","итальянский язык","китайския язык","компьютерная графика","корейский язык","латынь","литература","логика","макроэкономика","математический анализ","менеджмент","микроэкономика","начертательная геометрия","норвежский язык","оригами","подготовка к школе","польский язык","португальский язык","правоведение","психология","рисование","риторика","рки","сербский язык","скрипка1","сольфеджио","сопротивление материалов","статистика","теоретическая механика","теория вероятностей","турецкий язык","философия","финский язык","флейта","фортепиано","хинди","черчение","чешский язык","шахматы","шведский язык","эконометрика","экономика","электротехника","японский язык"]
        #value : $form : pupil : 'newBid.subjects.0.subject'
        value : $urlform : mainFilter : 'subject.0'
      ###choose_subject  : @module '../selected_tag'  :
        selector  : 'choose_subject'
        id        : '123'
        text      : 'Алгебра'
        close     : true

      ###
      tutor_status_text : $urlform : mainFilter : 'tutor_status_text'
      tutor_status : [
        @module 'tutor/forms/checkbox'  :
          text      : 'Студент'
          selector  : 'small'
          value : $urlform : mainFilter : 'tutor_status.student'
        @module 'tutor/forms/checkbox'  :
          text      : 'Частный преподаватель'
          selector  : 'small'
          value : $urlform : mainFilter : 'tutor_status.private_teacher'
        @module 'tutor/forms/checkbox'  :
          text      : 'Преподаватель школы'
          selector  : 'small'
          value : $urlform : mainFilter : 'tutor_status.school_teacher'
        @module 'tutor/forms/checkbox'  :
          text      : 'Преподаватель ВУЗа'
          selector  : 'small'
          value : $urlform : mainFilter : 'tutor_status.university_teacher'
      ]
      place : [
        @module 'tutor/forms/checkbox'  :
          text      : 'У себя'
          selector  : 'small'
          value : $urlform : mainFilter : 'place.pupil'
        @module 'tutor/forms/checkbox'  :
          text      : 'У репетитора'
          selector  : 'small'
          value : $urlform : mainFilter : 'place.tutor'
        @module 'tutor/forms/checkbox'  :
          text      : 'Удалённо'
          selector  : 'small'
          value : $urlform : mainFilter : 'place.remote'
        #@module 'tutor/forms/checkbox'  :
        #  text      : 'Другое'
        #  selector  : 'small'
      ]
      price : [
        @module 'tutor/forms/checkbox'  :
          text      : 'до 500'
          selector  : 'small'
        @module 'tutor/forms/checkbox'  :
          text      : 'от 500 до 1000'
          selector  : 'small'
        @module 'tutor/forms/checkbox'  :
          text      : 'от 1000 до 2000'
          selector  : 'small'
        @module 'tutor/forms/checkbox'  :
          text      : 'от 2000'
          selector  : 'small'
      ]
      empty_choose_subject : @module '../selected_tag' :
        selector  : 'choose_subject'
        id        : ''
        text      : ''
        close     : true
      link_forward    :  '/second_step'
      issue_bid_button : @module 'link_button' :
        selector  : 'add_button_bid'
        text      : 'ЗАРЕГИСТРИРОВАТЬСЯ'
        active    : true
        href      : '/main_tutor'

    info_panel  : @state './info_panel'
