class @main extends @template '../fast_bid'
  route : '/fast_bid/first_step'
  model : 'main/application/1_step'
  title : "быстрое оформление заявки: первый шаг"
  access : ['other', 'pupil','admin']
  forms : ['pupil','person', {account:['fast_bid_progress']}]
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : ->
    #progress : $form : account : 'fast_bid_progress'
    progress : 1
    style_button_back   : 'fast_bid_nav inactive'
    href_button_back    : ''
    style_issue_bid     : 'fast_bid_issue'
    href_issue_bid      : 'fourth_step'
    style_button_next   : 'fast_bid_nav'
    href_button_next    : 'second_step'
    b_selector  : 'book'
    content : @module '$' :
      name : @module 'tutor/forms/input' :
        text1      : 'Имя :'
        selector  : 'fast_bid'
        pattern   : '^[_a-zA-Z0-9а-яА-ЯёЁ ]{1,15}$'
        errMessage: 'Введите корректное имя (имя может содержать только цифры, символы алфавита и _)'
        value     : $urlform : pupil : 'name'  #$form : person : 'first_name'
      phone : @module 'tutor/forms/input':
        text1: 'Телефон :'
        selector  : 'fast_bid'
        value     : $urlform : pupil : 'phone'  #$form : person : 'first_name'
        #value     : $form : pupil : 'newBid.phone_call.phones.0' #'phone_call_phones_first'
        ###
        replace : [
          {"^(8|7)(?!\\+7)":"+7"}
          {"^(.*)(\\+7)":"$2$1"}
          "\\+7"
          "[^\\d_]"
          {"^(.*)$":"$1__________"}
          {"^([\\d_]{0,10})(.*)$": "$1"}
          {"^([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)([\\d_]?)$":"+7 ($1$2$3) $4$5$6-$7$8-$9$10"}
        ]
        replaceCursor     : [
          "(_)"
        ]
        selectOnFocus : true
        patterns : [
          "^\\+7 \\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d-\\d\\d$" : "Введите телефон <br>в формате +7 (926) 123-45-45"
        ]
        ###
      call_time : @module 'tutor/forms/textarea':
        text: 'В какое время Вам звонить :'
        selector  : 'fast_bid'
        #value     : $form : pupil : 'newBid.phone_call.description'
        value     : $urlform : pupil : 'phone_comment'  #$form : person : 'first_name'
      email : @module 'tutor/forms/input':
        text1: 'E-mail :'
        selector  : 'fast_bid'
        replace   : [
         { "(^[^\\w])" : ""}
         { "(\\@[^\\w])" : "@"}
         { "([^\\w\\d-\\.@])" : ""}
        ]
        errors :
          bad : "Введите корректный email"
        patterns  : [
          "\\w.*@\\w+\\.\\w+" : "bad"
        ]
        errMessage  : 'Пожалуйста введите корректный email'
        #value : $form : person : 'email_first'
        value     : $urlform : pupil : 'email'  #$form : person : 'first_name'
        
      subject :@module 'tutor/forms/drop_down_list':
        selector  : 'fast_bid'
        smart : true
        self : true
        sort : true
        filter : true
        items : ["английский язык","математика","русский язык","музыка","физика","химия","немецкий язык","начальная школа","франзузский язык","обществознание","информатика","программирование","испанский язык","биология","логопеды","актёрское мастерство","алгебра","арабский язык","бухгалтерский учёт","венгерский язык","вокал","высшая математика","география","геометрия","гитара","голландский язык","греческий язык","датский язык","иврит","история","итальянский язык","китайския язык","компьютерная графика","корейский язык","латынь","литература","логика","макроэкономика","математический анализ","менеджмент","микроэкономика","норвежский язык","оригами","подготовка к школе","польский язык","португальский язык","правоведение","психология","рисование","риторика","сербский язык","скрипка1","сольфеджио","статистика","теоретическая механика","теория вероятностей","турецкий язык","философия","финский язык","флейта","фортепиано","хинди","черчение","чешский язык","шахматы","шведский язык","эконометрика","экономика","электротехника","японский язык"]
        #value : $form : pupil : 'newBid.subjects.0.subject'
        value     : $urlform : pupil : 'subject'  #$form : person : 'first_name'
        
        
        

      comments : @module 'tutor/forms/textarea':
        text: 'Комментарии :'
        selector  : 'fast_bid'
        value : $urlform : pupil : 'subject_comment'
    #hint : 'Вы можете<br>отправить заявку<br>в любой момент!<br>Но чем подробнее вы<br>её заполните, тем<br>лучше мы сможем<br>подобрать Вам<br>подходящего<br>репетитора :)'



