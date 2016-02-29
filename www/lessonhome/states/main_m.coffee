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
      #carousel : @module 'lib/jquery/plugins/slick'
      id_page: 'main_p'
      hide_head_button: true
      subject_list: filter.subjects
      training_direction : filter.course
      short_form : @state 'short_form' :
        param_popup : 'main'
      value : $urlform : pupil: ''
      metro_lines : @const('metro').lines
      comments: @state 'lp/comments'
