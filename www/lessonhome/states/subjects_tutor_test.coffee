class @main
  forms : [{'tutor':['subjects']}]
  tree : => @module '$' :
    btn_uploads : @module 'tutor/button' :
      text : "Добавить предмет"
    data : $form : tutor : 'subjects'
    subject : @state './subject_tutor_test'
