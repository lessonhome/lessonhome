class @main extends @template 'lp/all'
  route : '/repetitory-matematika-starshie-klassy-10-11'
#tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по математике 10-11 классы."
  tree : =>
    photo_src         : 'reclame_jump_page/math.jpg'
    alt               : 'Репетиторы по математике 10-11 классы.'
    title             : 'Репетиторы по математике для 10-11 классов.'
    #sub_title         : 'подготовка к ЕГЭ.'
    text              : 'Репетитор по математике 10-11 класса необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. В 2016 году задания ЕГЭ по математике представлены в двух видах – основном для всех школьников и профильном для тех, чья цель обучение в ВУЗе. Кроме этого, поднят проходной минимум баллов – теперь он равен 27. Но реальная перспектива поступления светит лишь тем, кто набрал от 47 баллов, а на попадание в десятку лучших ВУЗов страны смогут претендовать счастливчики с баллами от 80. Зато и попыток хорошо сдать экзамен станет больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Если мечта вашего ребенка – высшее образование, вам обязательно стоит найти хорошего репетитора по математике 11 класса. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Цена репетитора по математике 10-11 класса зависит от квалификации преподавателя и его опыта работы. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по математике:<br><small>подготовка к ЕГЭ, экзаменам и олимпиадам</small>'
    landing_img       : 'reclame_background/mat.png'
    title_position    : 'top'
    button_color      : 'mat_color'
    filter :
      subject : [
        'математика'
      ]
      course : [
        'егэ'
      ]