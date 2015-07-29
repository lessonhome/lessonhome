class @main extends @template '../../tutor'
  route : '/tutor/conditions'
  model   : 'tutor/profile/conditions'
  title : "условия"
  tags   : -> 'tutor:conditions'
  access : ['tutor']
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }

  tree : ->
    items : [
      @module 'tutor/header/button' :
        title : 'Описание'
        href  : '/tutor/profile'
      @module 'tutor/header/button' :
        title : 'Условия'
        href  : '/tutor/conditions'
        tag   : 'tutor:conditions'
      @module 'tutor/header/button' :
        title : ''
        href  : ''
      @module 'tutor/header/button' :
        title : 'Отзывы'
        href  : '/tutor/reviews'
    ]
    content : @state './conditions_content'  :
      address_time_title : $form : person : 'area'
      address: $form : person : 'address'
      calendar:  $form : tutor : 'calendar'
      outside_work_areas: $form : tutor : 'check_out_the_areas'
      subject       : @module 'tutor/profile_content/title_block'  :
        title     : $form : tutor : 'subject.name'
        details   : $form : tutor : 'subject.tags.0'
        selector  : 'subject'
      details_data  : @module 'tutor/profile_content/conditions_content/details_data' :
        line_horizon  :  @module 'tutor/separate_line' :
          selector  : 'horizon'
        price_from : $form : tutor : 'srange.left'
        price_till : $form : tutor : 'srange.right'
        subject_data        : @module 'tutor/profile_content/info_block' :
          section :
            'Категория ученика :'           : $form : tutor : 'scategory_of_student'
            'Комментарии :'                 : $form : tutor : 'subject.description'
            'Групповые занятия :'           : $form : tutor : 'subject.groups.0.description'
            'Место занятий :'               : $form : tutor : 'splace'
            'Продолжительность :'           : $form : tutor : 'sduration' : ({left,right})-> "#{left} - #{right} минут."
          selector : 'subject_class'
          line_horizon  :  @module 'tutor/separate_line' :
            selector  : 'horizon'
        line_vertical : @module 'tutor/separate_line':
          selector  : 'vertical'
#edit  : true
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'
