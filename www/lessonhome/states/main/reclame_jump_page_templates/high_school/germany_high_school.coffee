
class @main extends @template 'lp/all'
  route : '/repetitory-nemeckij-starshie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по немецкому языку старшие классы"
  tree : =>
    photo_src         : 'reclame_jump_page/land_german.jpg'
    alt               : 'Репетиторы по немецкому языку старшие классы'
    title             : 'Для чего нужен репетитор по немецкому языку?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'В первую очередь репетитор по немецкому языку в 9-11 классах необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. ЕГЭ по немецкому языку вызывает значительные трудности у большинства школьников. Согласно статистике, немногие способны набрать на нем 100 баллов. В 2016 году экзамен претерпел некоторые изменения – к нему добавилась довольно сложная устная часть, изменилась суть ряда заданий. Зато и попыток хорошо сдать экзамен стало больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Если вы хотите, чтобы школьник успешно справился с пятью непростыми частями экзамена, вам обязательно стоит найти хорошего репетитора по немецкому языку. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по немецкому языку:<br><small>подготовка к ЕГЭ, экзаменам и олимпиадам</small>'
    filter :
      subject : [
        'немецкий язык'
      ]