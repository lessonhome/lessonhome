class @main
  tree : => @module '$' :
    btn_uploads : @module 'tutor/button' :
      text : 'Добавить предмет'
    subjects : [
      @state './subject_tutor_test'
    ]
