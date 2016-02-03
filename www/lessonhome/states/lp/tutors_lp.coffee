class @main  extends @template '../lp'
  route : '/tutors_lp'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Репетиторам"
  access : ['other', 'pupil']
  redirect : {
    tutor: '/tutor/profile'
  }
  tree : =>
    ###
    test : $defer : =>
      taskTypes = yield Feel.getAllTaskTypes()
      ret = {}
      for type in taskTypes
        struct = yield Feel.getTaskStruct type
        ret[type] = @module 'task': struct
      return ret
    ###
    content : @module '$':
      enter_button_show: true
      id_page: 'lp_tutors'
      top_form  : @module 'register/content' :
        landing_page: true
        depend : [
          @module 'lib/crypto'
          @module 'lib/lzstring'
        ]
        login           : @module 'tutor/forms/input_m' :
          replace : [
            "[^\\d-\\(\\)\\@\\w\\+А-Яа-яёЁ\\s\\.]"
          ]
          name        : 'email'
          selector    : 'registration'
          text1       : 'Введите ваш телефон или email адрес'
          input_icon  : 'mail_outline'
        password        : @module 'tutor/forms/input_m' :
          name        :'password'
          type        : 'password'
          selector    : 'registration'
          text1       : 'Придумайте пароль'
          input_icon  : 'lock_outline'
        agree_checkbox        : @module 'tutor/forms/checkbox' :
          value : true
          selector: 'small'
        create_account  : @module 'link_button_m' :
          href      : 'tutor/profile/first_step'
          selector  : 'main_page_motivation_test'
          text      : 'СОЗДАТЬ АККАУНТ'
      value :
        phone : $urlform : pupil : 'phone'
        name : $urlform : pupil : 'name'

