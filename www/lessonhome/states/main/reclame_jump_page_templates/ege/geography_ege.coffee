
class @main extends @template '../first_template'
  route : '/repetitory-geografiya-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по географии ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_geography.jpg'
    alt               : 'Репетиторы по географии ЕГЭ'
    title             : 'Репетиторы по географии'
    sub_title         : 'подготовка к ЕГЭ'
    text              : 'ЕГЭ по географии – не самый популярный среди школьников экзамен, но он необходим для поступления на такие направления, как экология, картография, география и т.д. Это один из немногих экзаменационных предметов, которого практически не коснулись изменения в ЕГЭ 2016 года. Однако попыток хорошо сдать экзамен станет больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Ознакомиться с особенностями сдачи ЕГЭ и с ориентировочными заданиями, вы можете здесь - http://www.examen.ru/add/ege/ege-po-geografii Если мечта вашего ребенка – высшее образование, вам обязательно стоит найти хорошего репетитора по географии. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы, готовящие к сдаче ЕГЭ от 80 баллов'
    filter :
      subject : [
        'география'
      ]
      course : [
        'егэ'
      ]
