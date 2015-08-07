class @main
  forms : [{tutor:['subject','isTag','srange','isPlace','sduration','scourse']}]
  tree : => @module '$' :
    subject_name : $form : tutor : 'subject.name'
    course     : @module 'tutor/forms/drop_down_list_with_tags' :
      list     : @module 'tutor/forms/drop_down_list' :
        text      : 'Направление подготовки :'
        placeholder : 'Например ЕГЭ'
        smart : true
        self : true
        selector  : 'first_reg'
        items : ['JLPT', 'JLPT N1', 'JLPT N2', 'JLPT N3', 'JLPT N4', 'JLPT N5', 'TOPIK', 'TOPIK I', 'TOPIK II', 'HSK', 'HSK Высший', 'HSK Начальный/средний', 'HSK Базовый', 'DELE', 'DELE A', 'DELE B', 'DELE C', 'TOEFL','IELTS', 'FCE', 'TOEIC', 'Business English', 'GMAT', 'GRE', 'SAT', 'DELF', 'DELF A', 'DELF B', 'DALF ', 'DSH', 'TestDaF', 'CILS', 'CILS B1', 'CILS B2', 'CILS C1', 'CILS C2', 'CEPRE-Bras', 'CEPRE-Bras Средний', 'CEPRE-Bras Выше среднейго', 'CEPRE-Bras Продвинутый', 'CEPRE-Bras Выше продвинутого', 'ЕГЭ', 'ОГЭ (ГИА)', 'Разговорный', 'Бизнес', 'С нуля']
      $form : tutor : 'scourse'
    pre_school      : @module 'tutor/forms/checkbox' :
      text      : 'дошкольники'
      selector  : 'small font_16'
      $form : tutor : 'isTag.school:0'
    junior_school   : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'младшая школа'
      $form : tutor : 'isTag.school:1'
    medium_school   : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'средняя школа'
      $form : tutor : 'isTag.school:2'
    high_school     : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'старшая школа'
      $form : tutor : 'isTag.school:3'
    student         : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'студент'
      $form : tutor : 'isTag.student'
    adult           : @module 'tutor/forms/checkbox' :
      selector  : 'small font_16'
      text      : 'взрослый'
      $form : tutor : 'isTag.adult'
    price_slider   : @state 'main/slider_main' :
      selector      : 'price_fast_reg'
      default :
        left : 400
        right : 5000
      dash          : '-'
      measurement   : 'руб.'
      division_value : 50
      type : 'default'
      #handle        : true
      min : 400
      max : 5000
      # надо подключить к правильным полям
      left : $form : tutor : 'srange.left'
      right : $form : tutor : 'srange.right'

    duration    : @state 'main/slider_main' :
      selector      : 'price_fast_reg'
      default :
        left : 60
        right : 120
      dash          : '-'
      measurement   : 'мин.'
      division_value : 5
      type : 'default'
      #handle        : true
      min : 30
      max : 240
      left : $form : tutor : 'sduration.left'
      right : $form : tutor : 'sduration.right'



    place_tutor      : @module 'tutor/forms/checkbox' :
      text      : 'у себя'
      selector  : 'small font_16'
      $form : tutor : 'isPlace.tutor'
    place_pupil      : @module 'tutor/forms/checkbox' :
      text      : 'у ученика'
      selector  : 'small font_16'
      $form : tutor : 'isPlace.pupil'
    place_remote      : @module 'tutor/forms/checkbox' :
      text      : 'удалённо'
      selector  : 'small font_16'
      $form : tutor : 'isPlace.remote'
    place_cafe      : @module 'tutor/forms/checkbox' :
      text      : 'другое место'
      selector  : 'small font_16'
      $form : tutor : 'isPlace.other'
    group_learning         : @module 'tutor/forms/drop_down_list' :
      text      : 'Групповые занятия :'
      selector  : 'first_reg'
      self      : true
      default_options     : {
        '0': {value: '0', text: 'не проводятся'},
        '1': {value: '1', text: '2-4 ученика'},
        '2': {value: '2', text: 'до 8 учеников'},
        '3': {value: '3', text: 'от 10 учеников'}
      }
      $form : tutor : 'subject.groups.0.description' : (val)-> val || 'не проводятся'
    comments          : @module 'tutor/forms/textarea' :
      height    : '80px'
      text      : 'Комментарии :'
      selector  : 'first_reg'
      $form : tutor : 'subject.description'
