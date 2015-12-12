
class @main extends @template 'lp/all'
  route : '/repetitory-geografiya-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по географии ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_geography.jpg'
    alt               : 'Репетиторы по географии ЕГЭ'
    title             : 'Для чего нужен репетитор по географии?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : '<p><b>ЕГЭ по географии</b> — не самый популярный среди школьников экзамен, но он необходим для поступления на такие направления, как экология, картография, география и т.д. </p> <p>Это один из немногих экзаменационных предметов, которого практически не коснулись изменения в ЕГЭ 2016 года, однако попыток хорошо сдать экзамен станет больше — теперь каждый школьник может попробовать набрать нужный балл три раза. <p><i>Ознакомиться с особенностями сдачи ЕГЭ по географии, а также с пробными заданиями вы можете <a href="http://www.examen.ru/add/ege/ege-po-geografii" target="_blank">здесь</a></i>.</p> <p>Если мечта вашего ребенка — высшее образование, вам обязательно стоит найти хорошего репетитора по географии. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. </p><p><b>Наша база профессиональных педагогов — лучший вариант для поиска наставника, организующего должный уровень подготовки.</b> </p> <p>Подбор репетитора абсолютно бесплатно!</p>'
    title_suit_tutors : 'Репетиторы для подготовки к ЕГЭ по географии'
    landing_img       : 'reclame_background/georgaph-boy.png'
    title_position    : 'bottom'
    button_color      : 'georgaph_color'
    filter :
      subject : [
        'география'
      ]
