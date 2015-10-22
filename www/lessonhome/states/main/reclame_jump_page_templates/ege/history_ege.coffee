
class @main extends @template 'lp/all'
  route : '/repetitory-istoriya-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по истории ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_history.jpg'
    alt               : 'Репетиторы по истории ЕГЭ'
    title             : 'Для чего нужен репетитор по истории?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'ЕГЭ по истории необходимо школьникам, которые хотят обучаться таким популярным специальностям как дизайн, архитектура, юриспруденция. Это один из немногих экзаменационных предметов, которого практически не коснулись изменения в ЕГЭ 2016 года. Однако была изменена структура заданий, они приведены в соответствие с требованиями нового Историко-культурного стандарта. Также попыток хорошо сдать экзамен стало больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Ознакомиться с особенностями сдачи ЕГЭ и с ориентировочными заданиями, вы можете здесь - http://www.examen.ru/add/ege/ege-po-istorii Если мечта вашего ребенка – высшее образование, вам обязательно стоит найти хорошего репетитора по истории. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы для подготовки к ЕГЭ по истории'
    filter :
      subject : [
        'история'
      ]
