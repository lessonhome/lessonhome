
class @main extends @template '../first_template'
  route : '/repetitory-fizika-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по физике ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_physics.jpg'
    alt               : 'Репетиторы по физике ЕГЭ'
    title             : 'Репетиторы по физике'
    sub_title         : 'подготовка к ЕГЭ'
    text              : 'Хороший балл на ЕГЭ по физике – требование для поступления на техническую специальность в любом ВУЗе. В 2016 году экзамен претерпел ряд изменений, например, сократилось число заданий с 35 до 32. По данному предмету сохранились тестовые вопросы, содержащие несколько вариантов ответов. Еще одна прекрасная новость - попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза. Если мечта вашего ребенка – высшее техническое образование, вам обязательно стоит найти хорошего репетитора по физике. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы, готовящие к сдаче ЕГЭ от 80 баллов'
    filter :
      subject : [
        'физика'
      ]
      course : [
        'егэ'
      ]