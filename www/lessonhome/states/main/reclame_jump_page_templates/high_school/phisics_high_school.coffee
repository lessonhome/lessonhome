
class @main extends @template 'lp/all'
  route : '/repetitory-fizika-starshie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по физике гиа"
  tree : =>
    photo_src         : 'reclame_jump_page/land_physics.jpg'
    alt               : 'Репетиторы по физике старшие классы'
    title             : 'Для чего нужен репетитор по физике?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Репетитор по физике 10-11 класса необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. Хороший балл на ЕГЭ по физике – требование для поступления на техническую специальность в любом ВУЗе. В 2016 году экзамен претерпел ряд изменений, например, сократилось число заданий с 35 до 32. По данному предмету сохранились тестовые вопросы, содержащие несколько вариантов ответов. Еще одна прекрасная новость - попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза. Если мечта вашего ребенка – высшее техническое образование, вам обязательно стоит найти хорошего репетитора по физике  10-11 класса. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Цена репетитора по физике 10-11 класса зависит от квалификации преподавателя и его опыта работы. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по физике:<br><small>подготовка к ЕГЭ, экзаменам и олимпиадам</small>'
    filter :
      subject : [
        'физика'
      ]
      course : [
      ]