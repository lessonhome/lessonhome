
class @main extends @template 'lp/all'
  route : '/repetitory-russkij-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по русскому языку ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_russian.jpg'
    alt               : 'Репетиторы по русскому языку ЕГЭ'
    title             : 'Для чего нужен репетитор по русскому?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              :  'В 2016 году из заданий ЕГЭ по русскому языку будет убрана тестовая часть – та, в которой имеются варианты ответов. Так предполагается повысить качество проверки знаний – ученик лишается шанса угадать правильный вариант. Кроме этого, в 2016 году будет увеличен проходной балл, его итоговая величина пока не известна. Зато и попыток хорошо сдать экзамен станет больше – теперь каждый школьник может попробовать набрать нужный балл три раза. Если мечта вашего ребенка – высшее образование, вам обязательно стоит найти хорошего репетитора по русскому языку. Наша база профессиональных педагогов - лучший вариант для поиска наставника, организующего должный уровень подготовки. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. Подбор репетитора абсолютно бесплатно!'
    title_suit_tutors : 'Репетиторы по русскому языку для подготовки к ЕГЭ'
    filter :
      subject : [
        'русский язык'
      ]
      course : [
        'егэ'
      ]
