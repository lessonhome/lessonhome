
class @main extends @template 'lp/all'
  route : '/repetitory-obshchestvoznanie-ege'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по обществознанию ЕГЭ"
  tree : =>
    photo_src         : 'reclame_jump_page/land_society_ege.jpg'
    alt               : 'Репетиторы по обществознанию ЕГЭ'
    title             : 'Для чего нужен репетитор по обществознанию?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : '<p><b>ЕГЭ по обществознанию</b> — самый популярный экзамен, который выбирает из списка необязательных предметов большинство учащихся. Выбирая данный экзамен, вы сможете подать документы в ВУЗы на такие специальности, как "Менеджмент", "Экономика", "Реклама и связи с общественностью", "Юриспруденция", "Психология", "Социология" и другие.</p> <p>В 2016 году экзамен претерпел ряд изменений, например, сократилось общее число заданий. Соответственно, уменьшился и максимальный балл — стал равен 42. Также увеличилось время на выполнение заданий.</p> <p>Еще одна прекрасная новость — попыток хорошо сдать экзамен станет больше, каждый школьник может попробовать набрать нужный балл три раза.</p> 
<p><i>Ознакомиться с особенностями сдачи ЕГЭ по обществознанию, а также с пробными заданиями вы можете <a href="http://www.examen.ru/add/ege/ege-po-obwestvoznaniju" target="_blank">здесь</a></i>.</p><p>Если мечта вашего ребенка — высшее образование по перечисленным выше специальностям, вам обязательно стоит найти хорошего репетитора по обществознанию. Благодаря его усилиям, школьник получит знания, которые позволят набрать нужные баллы и стать студентом выбранного университета в Москве.</p> 
<p><b>Наша база профессиональных педагогов — лучший вариант для поиска наставника, организующего должный уровень подготовки.</b></p>
<p>Подбор репетитора абсолютно бесплатно!</p>'
    title_suit_tutors : 'Репетиторы для подготовки к ЕГЭ по обществознанию'
    landing_img       : 'reclame_background/social.png'
    title_position    : 'bottom'
    button_color      : 'social_color'
    opacity_form      : 'rgba(0,0,0,0.5)'
    filter :
      subject : [
        'обществознание'
      ]
