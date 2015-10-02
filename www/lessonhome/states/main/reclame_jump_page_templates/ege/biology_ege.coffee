
class @main extends @template '../first_template'
  route : '/repetitory-biologiya-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по биологии ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_biology.jpg'
    alt               : 'Репетиторы по биологии ЕГЭ'
    title             : 'Репетиторы по биологии'
    sub_title         : 'подготовка к ЕГЭ'
    text              : 'ЕГЭ по биологии необходимо школьникам, которые хотят обучаться специальностям медицинского направления. С каждым годом этот экзамен становится сложнее: исключаются тестовые задания с несколькими вариантами решения на выбор, становится больше вопросов с требованием развернутого полного ответа. Также попыток хорошо сдать экзамен стало больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Ознакомиться с особенностями сдачи ЕГЭ и с ориентировочными заданиями, вы можете здесь - http://www.examen.ru/add/ege/ege-po-biologii Если мечта вашего ребенка – высшее медицинское образование, вам обязательно стоит найти хорошего репетитора по биологии. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы, готовящие к сдаче ЕГЭ от 80 баллов'
    filter :
      subject : [
        'биология'
      ]
      course : [
        'егэ'
      ]
