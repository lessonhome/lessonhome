
class @main extends @template 'lp/all'
  route : '/repetitory-nemeckij-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по немецкому языку ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_german.jpg'
    alt               : 'Репетиторы по немецкому языку ЕГЭ'
    title             : 'Для чего нужен репетитор по немецкому языку?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : '<p><b>ЕГЭ по немецкому языку</b> вызывает значительные трудности у большинства школьников. Согласно статистике, немногие способны набрать на нем 100 баллов. В 2016 году экзамен претерпел некоторые изменения — к нему добавили довольно сложную устную часть, изменилась суть ряда заданий. Зато и попыток хорошо сдать экзамен стало больше — теперь каждый школьник может попробовать набрать нужный балл три раза.</p> 
<p><i>Ознакомиться с особенностями сдачи ЕГЭ по немецкому языку, а также с пробными заданиями вы можете <a href="http://www.examen.ru/add/ege/ege-po-nemeckomu-jazyku" target="_blank">здесь</a></i>.</p> <p>Если вы хотите, чтобы школьник успешно справился с пятью непростыми частями экзамена, вам обязательно стоит найти хорошего репетитора по немецкому языку. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве.</p> <p><b>Наша база профессиональных педагогов — лучший вариант для поиска наставника, организующего должный уровень подготовки.</b> </p> <p>Подбор репетитора абсолютно бесплатно!</p>'
    title_suit_tutors : 'Репетиторы для подготовки к ЕГЭ по немецкому языку'
    filter :
      subject : [
        'немецкий язык'
      ]
