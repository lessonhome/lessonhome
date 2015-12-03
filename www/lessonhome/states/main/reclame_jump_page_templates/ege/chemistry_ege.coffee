
class @main extends @template 'lp/all'
  route : '/repetitory-himiya-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по химии ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_chemistry.jpg'
    alt               : 'Репетиторы по химии ЕГЭ'
    title             : 'Для чего нужен репетитор по химии?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : '<p><b>ЕГЭ по химии</b> необходим при поступлении в ВУЗ на такие естественно-научные направления, как, например: химия, биология, геология, почвоведение и т.д.</p> <p>В 2016 году экзамен претерпел ряд изменений, например, сократилось число базовых заданий с 28 до 26. По данному предмету максимальная возможная оценка составит 64 балла. Еще одна прекрасная новость — попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза.</p>
<p><i>Ознакомиться с особенностями сдачи ЕГЭ по химии, а также с пробными заданиями вы можете <a href="http://www.examen.ru/add/ege/ege-po-himii" target="_blank">здесь</a></i>.</p> <p>Если мечта вашего ребенка — высшее медицинское или химическое образование, вам обязательно стоит найти хорошего репетитора по химии. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве.<p><b>Наша база профессиональных педагогов — лучший вариант для поиска наставника, организующего должный уровень подготовки.</b> </p> <p>Подбор репетитора абсолютно бесплатно!</p>'
    title_suit_tutors : 'Репетиторы для подготовки к ЕГЭ по химии'
    landing_img       : 'reclame_background/chemis.png'
    title_position    : 'top'
    filter :
      subject : [
        'химия'
      ]

