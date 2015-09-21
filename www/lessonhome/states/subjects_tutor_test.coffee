class @main
  forms : [{'tutor':['all_subjects']}]
  tree : => @module '$' :
    btn_uploads : @module 'tutor/button' :
      text : "Добавить предмет"
    btn_send : @module 'tutor/button' :
      text : "Отправить"
    data : $form : tutor : 'all_subjects'
    subject : @state './subject_tutor_test'
