class @main extends @template 'lp/landing_version_two'
  route : '/text_right'
  model : 'main/registration'
  title : "Шаблон загловка справа"
  tree: =>
    title: '<span>Бесплатный подбор </span><br />репетитора по <br />английскому языку <br />для вашего ребенка'
    top_img: '/lp/school.jpg'
    top_right: true
    tutors_title: 'Мы работаем только с профессионалами'
    title_custom_position: true
    shadow_bg: true
    filter :
      subject  : ['английский язык']
      course   : ['школьный курс']
