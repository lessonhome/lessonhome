class @main
  forms : [{'tutor':['all_subjects']}]
  tree : => @module '$' :
    btn_add : @module 'tutor/button' :
      text : "Добавить предмет"
    data : $form : tutor : 'all_subjects'
    subject : @state './subject_tutor_test'
