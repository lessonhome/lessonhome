class @main
  route : '/all_forms_test'
  model   : 'main/first_step'
  title : "Тест всех форм"
  access : ['other','pupil','tutor']

  tree : -> @module '$' :
    drop_down_list_with_tags : @state 'tutor/forms/drop_down_list_with_tags' :
      list: @module 'tutor/forms/drop_down_list:test1'  :
        selector        : 'list_course'
        smart : true
        self  : true
        placeholder     : 'Например ЕГЭ'
        value     : ''
      tags: ''


