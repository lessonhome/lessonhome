
class @main extends @template 'lp/all'
  route : '/repetitory-obshchestvoznanie-starshie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по обществознанию старшие классы"
  tree : =>
    photo_src         : 'reclame_jump_page/land_society_ege.jpg'
    alt               : 'Репетиторы по обществознанию старшие классы'
    title             : 'Для чего нужен репетитор по обществознанию?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'В первую очередь репетитор по обществознанию в 10-11 классах необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. ЕГЭ по обществознанию – самый популярный экзамен, который выбирает из списка необязательных предметов большинство учащихся. В 2016 году он претерпел ряд изменений, например, сократилось общее число заданий. Соответственно, уменьшился и максимальный балл – он будет равен 42 баллам. Также увеличилось время на выполнение заданий. Еще одна прекрасная новость - попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза. Если мечта вашего ребенка – высшее гуманитарное образование, вам обязательно стоит найти хорошего репетитора по обществознанию в 10, 11 классе. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Цена репетитора по обществознанию 10-11 класса зависит от квалификации преподавателя и его опыта работы. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по обществознанию:<br><small>подготовка к ЕГЭ, экзаменам и олимпиадам</small>'
    landing_img       : 'reclame_background/social.png'
    title_position    : 'bottom'
    button_color      : 'social_color'
    opacity_form      : 'rgba(0,0,0,0.5)'
    filter :
      subject : [
        'обществознание'
      ]
