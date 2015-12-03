
class @main extends @template 'lp/all'
  route : '/repetitory-istoriya-srednie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по истории средняя школа"
  tree : =>
    photo_src         : 'reclame_jump_page/land_history.jpg'
    alt               : 'Репетиторы по истории средняя школа'
    title             : 'Для чего нужен репетитор по истории?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              :  'В первую очередь репетитор по истории в 10-11 классах необходим школьникам, чтобы сдать самый главный школьный экзамен по этому предмету. ЕГЭ по истории необходимо школьникам, которые хотят обучаться таким популярным специальностям как дизайн, архитектура, юриспруденция. Это один из немногих экзаменационных предметов, которого практически не коснулись изменения в ЕГЭ 2016 года. Однако была изменена структура заданий, они приведены в соответствие с требованиями нового Историко-культурного стандарта. Также попыток хорошо сдать экзамен стало больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Ознакомиться с особенностями сдачи ЕГЭ и с ориентировочными заданиями, вы можете здесь - http://www.examen.ru/add/ege/ege-po-istorii  Если мечта вашего ребенка – высшее образование, вам обязательно стоит найти хорошего репетитора по истории в 10, 11 классе. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Цена репетитора по истории 10-11 класса зависит от квалификации преподавателя и его опыта работы. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по истории:<br><small>подготовка к ОГЭ (ГИА), экзаменам, олимпиадам</small>'
    landing_img       : 'reclame_background/history.png'
    title_position    : 'top'
    button_color      : 'history_color'
    filter :
      subject : [
        'история'
      ]
      course : [
      ]
