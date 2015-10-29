
class @main extends @template 'lp/all'
  route : '/repetitory-francuzskij-starshie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по французскому языку старшие классы"
  tree : =>
    photo_src         : 'reclame_jump_page/land_french.jpg'
    alt               : 'Репетиторы по французскому языку старшие классы'
    title             : 'Для чего нужен репетитор по французскому?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'В первую очередь репетитор по французскому языку в 10-11 классах необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. ЕГЭ по французскому языку в 2016 году претерпел некоторые изменения – добавилась довольно сложная устная часть, изменилась суть ряда заданий. Зато и попыток хорошо сдать экзамен стало больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Егэ по французскому, как и все экзамены по иностранным языкам разделен на пять этапов, проверяющих разные аспекты знаний школьника. Если вы хотите, чтобы школьник успешно справился со всеми частями экзамена, вам обязательно стоит найти хорошего репетитора по французскому языку. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по французскому языку:<br><small>подготовка к ЕГЭ, экзаменам и олимпиадам</small>'
    filter :
      subject : [
        'французский язык'
      ]
      course : [
      ]