
class @main extends @template 'lp/all'
  route : '/repetitory-informatika'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по информатике"
  tree : =>
    photo_src         : 'reclame_jump_page/land_informatics.jpg'
    alt               : 'Репетиторы по информатике'
    title             : 'Для чего нужен репетитор по информатике?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Сдать ЕГЭ по информатике необходимо для поступления в ВУЗ на многие новые перспективные специальности. В 2016 году экзамен претерпел ряд изменений, например, сократилось число базовых заданий с 32 до 27. По данному предмету максимально можно будет набрать 35 баллов. Еще одна прекрасная новость - попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза. Если мечта вашего ребенка – образование, связанное с инновационными технологиями, вам обязательно стоит найти хорошего репетитора по информатике. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по информатике:<br><small>подготовка к экзаменам и олимпиадам.</small>'
    filter :
      subject : [
        'информатика'
      ]
