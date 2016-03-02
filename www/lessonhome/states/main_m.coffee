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
      _custom_head__markup : '
<!-- Schema.org markup for Google+ -->
<meta itemprop="name" content="Lessonhome - Репетиторы на каждый предмет">
<meta itemprop="description" content="Подбор репетиторов для детей и взрослых, от английского языка до менеджмента">
<meta itemprop="image" content="https://lessonhome.ru/apple-touch-icon-180x180.png">
<!-- Twitter Card data -->
<meta name="twitter:card" content="summary">
<meta name="twitter:site" content="@lesson_home">
<meta name="twitter:title" content="Lessonhome - Репетиторы на каждый предмет">
<meta name="twitter:description" content="Подбор репетиторов для детей и взрослых, от английского языка до менеджмента">
<meta name="twitter:image" content="https://lessonhome.ru/apple-touch-icon-180x180.png">

<!-- Open Graph data -->
<meta property="og:title" content=""Lessonhome - Репетиторы на каждый предмет">
<meta property="og:type" content="article">
<meta property="og:url" content="http://lessonhome.ru/">
<meta property="og:locale" content="ru_RU">
<meta property="og:image" content="https://lessonhome.ru/apple-touch-icon-180x180.png">
<meta property="og:image:width" content="180"> 
<meta property="og:image:height" content="180">
<meta property="og:description" content="Подбор репетиторов для детей и взрослых, от английского языка до менеджмента">
<meta property="og:site_name" content="Lessonhome">
'
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
