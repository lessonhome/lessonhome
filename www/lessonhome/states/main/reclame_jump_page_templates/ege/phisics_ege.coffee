
class @main extends @template 'lp/all'
  route : '/repetitory-fizika-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по физике ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_physics.jpg'
    alt               : 'Репетиторы по физике ЕГЭ'
    title             : 'Для чего нужен репетитор по физике?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : '<p>Хороший балл <b>ЕГЭ по физике</b> — требование для поступления на техническую специальность в любом ВУЗе.</p> <p>В 2016 году экзамен претерпел ряд изменений, например, сократилось число заданий с 35 до 32. По данному предмету сохранились тестовые вопросы, содержащие несколько вариантов ответов.</p> <p>Еще одна прекрасная новость — попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза.</p> 
<p><i>Ознакомиться с особенностями сдачи ЕГЭ по физике, а также с пробными заданиями вы можете <a href="http://www.examen.ru/add/ege/ege-po-fizike" target="_blank">здесь</a></i>.</p><p>Если мечта вашего ребенка — высшее техническое образование, вам обязательно стоит найти хорошего репетитора по физике. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве. </p><p><b>Наша база профессиональных педагогов — лучший вариант для поиска наставника, организующего должный уровень подготовки. </b></p> <p>Подбор репетитора абсолютно бесплатно!</p>'
    title_suit_tutors : 'Репетиторы для подготовки к ЕГЭ по физике'
    filter :
      subject : [
        'физика'
      ]
      course : [
        'егэ'
      ]
