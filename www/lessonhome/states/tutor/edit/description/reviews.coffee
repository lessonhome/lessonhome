class @main extends @template '../edit_description'
  route : '/tutor/edit/reviews'
  model   : 'tutor/edit/description/career'
  title : "редактирование отзывов"
  tags : -> 'edit: reviews'
  access : ['admin']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
    'tutor' : '/enter'
  }
  forms : [{person:['reviews']}]
  tree : => tutor_edit : @module '$':
    subject : @state 'tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'list_course'
        placeholder     : 'Например, физика'
        value     : ''
        smart : true
        filter : true
        sort : true
        self : true
        items : ["английский язык","математика","русский язык","музыка","физика","химия","немецкий язык","начальная школа","франзузский язык","обществознание","информатика","программирование","испанский язык","биология","логопеды","актёрское мастерство","алгебра","арабский язык","бухгалтерский учёт","венгерский язык","вокал","высшая математика","география","геометрия","гитара","голландский язык","греческий язык","датский язык","иврит","история","итальянский язык","китайския язык","компьютерная графика","корейский язык","латынь","литература","логика","макроэкономика","математический анализ","менеджмент","микроэкономика","норвежский язык","оригами","подготовка к школе","польский язык","португальский язык","правоведение","психология","рисование","риторика","сербский язык","скрипка","сольфеджио","статистика","теоретическая механика","теория вероятностей","турецкий язык","философия","финский язык","флейта","фортепиано","хинди","черчение","чешский язык","шахматы","шведский язык","эконометрика","экономика","электротехника","японский язык"]
      tags: ''
      value : $form : person : 'reviews.0.subject'
    course : @state 'tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:type1'  :
        selector        : 'advanced_filter_form'
        placeholder     : 'Например, ЕГЭ'
        smart : true
        self : true
        value     : ''
      tags: ''
      value : $form : person : 'reviews.0.course'

    review : @module 'tutor/forms/textarea':
      selector : 'fast_bid'
      value : $form : person : 'reviews.0.review'
      height : '150px'
    name : @module 'tutor/forms/input':
      selector : 'fast_bid'
      value : $form : person : 'reviews.0.name'
    date : @module 'tutor/forms/input':
      selector : 'fast_bid'
      value : $form : person : 'reviews.0.date'
    comment : @module 'tutor/forms/textarea':
      selector : 'fast_bid'
      value : $form : person : 'reviews.0.comment'
      height : '150px'
     
    add_button : @module 'tutor/button' :
      text : 'Добавить предмет'
      selector : 'edit_save'
    remove_button : @module 'tutor/button' :
      text : 'удалить'
      selector : 'edit_save'
