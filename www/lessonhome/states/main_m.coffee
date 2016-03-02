class @main extends @template 'lp'
  route : '/'
  model : 'main_m'
  title : "LessonHome - Главная страница"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    filter = @const('filter')
    content : @module '$':
      id_page: 'main_p'
      hide_head_button: true
      subject_list: filter.subjects
      training_direction : filter.course
      short_form : @state 'short_form' :
        param_popup : 'main'
      value :
        subjects : $urlform : tutorsFilter: 'subjects'
        metro : $urlform : tutorsFilter: 'metro'
      metro_lines : @const('metro').lines
      comments: @state 'lp/comments':
        not_page_refresh: true
