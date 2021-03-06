
class @main extends @template 'lp/all'
  route : '/repetitory-geografiya-starshie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по географии старшие классы"
  tree : =>
    photo_src         : 'reclame_jump_page/land_geography.jpg'
    alt               : 'Репетиторы по географии старшие классы'
    title             : 'Для чего нужен репетитор по географии?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'В первую очередь репетитор по географии в 10-11 классах необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. ЕГЭ по географии – не самый популярный среди школьников экзамен, но он необходим для поступления на такие направления, как экология, картография, география и т.д. Это один из немногих экзаменационных предметов, которого практически не коснулись изменения в ЕГЭ 2016 года. Положительным моментом стало увеличение числа попыток успешной сдачи теста до трех раз. Положительным моментом стало увеличение числа попыток успешной сдачи теста до трех раз. Ознакомиться с особенностями сдачи ЕГЭ и с ориентировочными заданиями, вы можете здесь - http://www.examen.ru/add/ege/ege-po-geografii Если мечта вашего ребенка – высшее образование, вам обязательно стоит найти хорошего репетитора по географии в 10, 11 классе. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Цена репетитора по географии 10-11 класса зависит от квалификации преподавателя и его опыта работы. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по географии:<br><small>подготовка к ЕГЭ, экзаменам и олимпиадам</small>'
    landing_img       : 'reclame_background/georgaph-boy.png'
    title_position    : 'bottom'
    button_color      : 'georgaph_color'
    filter :
      subject : [
        'география'
      ]
