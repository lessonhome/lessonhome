class @main extends @template 'lp/landing_version_two'
  route : '/text_left'
  model : 'main/registration'
  title : "Lessonhome - бесплатный подбор репетитора по аглийскому языку"
  tree: =>
    title: '<span>Бесплатный подбор </span><br />репетитора по <br />английскому языку <br /> для сдачи ЕГЭ'
    top_img: '/lp/school.jpg'
    tutors_title: 'Lessonhome рекомендует'
    title_custom_position: true
    shadow_bg: true
    filter :
      subject : ['английский язык']
      course  : ['ЕГЭ']
