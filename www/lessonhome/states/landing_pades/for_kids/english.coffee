class @main extends @template 'lp/landing_version_two'
  route : '/anglijskij-detyam'
  model : 'main/registration'
  title : "Репетитор по английскому для детей | Репетитор по английскому для ребенка | lessonhome.ru"
  tree: =>
    description: 'Индивидуальный подбор репетиторов по английскому языку для вашего ребенка. Бесплатно и в день обращения!'
    keywords: '<meta name="keywords" content="репетитор по английскому для детей, репетитор по английскому языку для ребенка, требуется репетитор по английскому языку для ребенка, найти репетитора по английскому языку для ребенка, ищу репетитора по английскому языку для ребенка" />'
    title: '<span>Бесплатный подбор </span><br />репетитора по <br />английскому языку <br />для вашего ребенка'
    top_img: '/lp/landing_screen/for_kid_01.jpg'
    top_right: true
    tutors_title: 'Мы работаем только с профессионалами'
    title_color: 'color_green'
    bg_color: '#4b9302'
    top_right: true
    title_custom_position: true
    bg_position: 'center'
    shadow_bg: true
    #dotted_bg: true
    filter :
      subject  : ['английский язык']
      course   : ['школьный курс']
