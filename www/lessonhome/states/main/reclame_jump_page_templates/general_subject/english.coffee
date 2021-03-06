
class @main extends @template 'lp/all'
  route : '/repetitory-anglijskij'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по английскому языку"
  tree : =>
    photo_src         : 'reclame_jump_page/land_english.jpg'
    alt               : 'Репетиторы по английскому языку'
    title             : 'Для чего нужен репетитор по английскому?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'В современном мире необходимо знать английский язык. Но этот предмет невозможно освоить без дополнительных занятий, обучаясь только по школьной программе. Частный репетитор по английскому языку поможет освоить те моменты, которые не смог объяснить учитель, ведь школьный педагог не всегда успевает поработать с каждым учеником. При этом найти репетитора по английскому языку стоит заранее – школьнику необходимы регулярные занятия, чтобы освоить предмет и успешно сдать единый экзамен. Сейчас необязательно приглашать учителя домой – уроки с репетитором английского языка по скайпу в онлайн режиме могут быть не менее эффективны, а стоимость их при этом будет меньше. Цена репетитора по английскому языку зависит от опыта и квалификации преподавателя, если вы обращаетесь к студенту, конечно, стоимость будет ниже. Но опытный педагог лучше подаст материал и легче найдет подход к ребенку, поможет ему заложить фундамент серьезных знаний. Это важно, ведь итоговый экзамен придется сдать каждому школьнику. В нашей базе вы найдете лучших репетиторов по английскому языку Москвы – мы бесплатно подберем вам преподавателя, учитывая все ваши пожелания.'
    title_suit_tutors : 'Репетиторы по английскому языку:<br><small>подготовка к экзаменам и олимпиадам.</small>'
    landing_img       : 'reclame_background/english.png'
    title_position    : 'bottom'
    button_color      : 'english_color'
    filter :
      subject : [
        'английский язык'
      ]
      course : [
      ]
