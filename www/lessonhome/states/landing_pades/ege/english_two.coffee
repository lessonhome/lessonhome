class @main extends @template 'lp/landing_version_two'
  route : '/anglijskij-yazyk-ege'
  model : 'main/registration'
  title : "Lessonhome - бесплатный подбор репетитора по аглийскому языку"
  tree: =>
    title: '<span>Бесплатный подбор </span><br />репетитора по <br />английскому языку <br /> для сдачи ЕГЭ'
    top_img: '/lp/landing_screen/english_ege_01.jpg'
    tutors_title: 'Lessonhome рекомендует'
    work_steps_show: true
    result_show: true
    filter :
      subject : ['английский язык']
      course  : []