
class @main extends @template 'lp/all'
  route : '/repetitory-ispanskij-starshie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по испанскому старшие классы"
  tree : =>
    photo_src         : 'reclame_jump_page/land_spanish.jpg'
    alt               : 'Репетиторы по испанскому старшие классы'
    title             : 'Для чего нужен репетитор по испанскому языку?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'В первую очередь репетитор по испанскому языку в 10-11 классах необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. ЕГЭ по испанскому языку выбирает небольшое количество школьников, хотя знание этого языка в настоящее время довольно востребовано. В 2016 году экзамен немного поменялся – добавочным элементом стала устная часть, вызывающая особые сложности у школьников. Также смысл нескольких этапов теста был изменен. Положительным моментом стало увеличение числа попыток успешной сдачи теста до трех раз. ЕГЭ по испанскому состоит из пяти частей, проверяющих разные аспекты знаний ученика. Если вы хотите, чтобы школьник успешно справился со всеми частями экзамена, вам обязательно стоит найти хорошего репетитора по испанскому языку. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по испанскому:<br><small>подготовка к ЕГЭ, экзаменам и олимпиадам</small>'
    landing_img       : 'reclame_background/span.png'
    title_position    : 'top'
    button_color      : 'spanish_color'
    bg_position       : 'right'
    filter :
      subject : [
        'испанский язык'
      ]
