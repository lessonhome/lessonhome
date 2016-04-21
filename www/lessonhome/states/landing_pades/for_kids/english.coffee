class @main extends @template 'lp/landing_version_two'
  route : '/anglijskij-detyam'
  model : 'main/registration'
  title : "Lessonhome - бесплатный подбор репетитора по аглийскому языку"
  tree: =>
    title: '<span>Бесплатный подбор </span><br />репетитора по <br />английскому языку <br />для вашего ребенка'
    dark_title_style: true
    top_img: '/lp/landing_screen/for_kid_01.jpg'
    top_right: true
    tutors_title: 'Мы работаем только с профессионалами'
    title_color: 'color_green'
    bg_color: '#4b9302'
    shadow_bg: true
    filter :
      subject  : ['английский язык']
      course   : ['школьный курс']
