
class @main extends @template 'lp/all'
  route : '/repetitory-obshchestvoznanie-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по обществознанию ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_society_ege.jpg'
    alt               : 'Репетиторы по обществознанию ЕГЭ'
    title             : 'Для чего нужен репетитор по обществознанию?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'ЕГЭ по обществознанию – самый популярный экзамен, который выбирает из списка необязательных предметов большинство учащихся. В 2016 году он претерпел ряд изменений, например, сократилось общее число заданий. Соответственно, уменьшился и максимальный балл – он будет равен 42 баллам. Также увеличилось время на выполнение заданий. Еще одна прекрасная новость - попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза. Если мечта вашего ребенка – высшее образование, вам обязательно стоит найти хорошего репетитора по обществознанию. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по обществознанию для подготовки к ЕГЭ'
    filter :
      subject : [
        'обществознание'
      ]
