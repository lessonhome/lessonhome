class @main extends @template 'lp/landing_version_two'
  route : '/anglijskij-egeh'
  model : 'main/registration'
  title : "Lessonhome - бесплатный подбор репетитора по аглийскому языку"
  tree: =>
    title: '<span>Бесплатный подбор </span><br />репетитора по <br />английскому языку'
    top_img: '/lp/landing_screen/english_ege_01.jpg'
    tutors_title: 'Lessonhome рекомендует'
    filter :
      subject : ['английский язык']
      course  : ['ЕГЭ']
