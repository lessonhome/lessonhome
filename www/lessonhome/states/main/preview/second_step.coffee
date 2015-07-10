class @main extends @template '../preview'
  route : '/second_step'
  model : 'main/second_step'
  forms : ['pupil']
  title : "выберите статус преподавателя"
  tags  : -> 'pupil:main_search'
  access : ['pupil','other']
  redirect : {
    'tutor' : 'tutor/profile'
  }
  tree : ->
    popup       : @exports()
    tag         : 'pupil:main_search'
    advanced_filter : @state '../advanced_filter'
    ###
      filter_top  : @state '../filter_top':
        title : 'Выберите статус преподавателя :'
        tutor_status : @module 'tutor/forms/drop_down_list' :
          selector    : 'filter_top'
          placeholder : 'студент'
          default_options     : {
            '0': {value: 'student', text: 'студент'},
            '1': {value: 'graduate', text: 'аспирант'},
            '2': {value: 'school_teacher', text: 'школьный преподаватель'},
            '3': {value: 'high_school_teacher', text: 'преподаватель вуза'},
            '4': {value: 'private_teacher', text: 'частный преподаватель'}
          }
          $form : pupil : 'requirements_for_tutor.status'
        choose_subject  : @module 'selected_tag'  :
          selector  : 'choose_subject'
          text      : 'Преподаватель вуза'
          close     : true
        link_forward    :  '/third_step'
        link_back       :  '/first_step'
    ###