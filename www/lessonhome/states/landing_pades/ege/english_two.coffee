class @main extends @template 'lp/landing_version_two'
  route : '/anglijskij-yazyk-egeh'
  model : 'main/registration'
  title : "Репетитор английского ЕГЭ | Репетитор подготовка к ЕГЭ английский | lessonhome.ru"
  tree: =>
    keywords: '<meta name="keywords" content="репетитор английского егэ, репетитор английский язык егэ, репетитор подготовка к егэ английский, репетитор по английскому языку подготовка к егэ, репетитор английский язык ГИА" />'
    title: '<span>Бесплатный подбор </span><br />репетитора по <br />английскому языку <br /> для сдачи ЕГЭ'
    top_img: '/lp/school.jpg'
    tutors_title: 'Lessonhome рекомендует'
    work_steps_show: true
    result_show: true
    top_right: true
    title_custom_position: true
    shadow_bg: true
    bottom_custom_text: 'Подготовка к ЕГЭ с репетитором &mdash; вклад в Будущее Вашего ребенка'
    bottom_bg: '/lp/school.jpg'
    comments_show: true
    filter :
      subject : ['английский язык']
      course  : ['ЕГЭ']
