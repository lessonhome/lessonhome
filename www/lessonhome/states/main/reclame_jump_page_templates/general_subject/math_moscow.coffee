class @main extends @template 'lp/all'
  route : '/repetitory-matematika-moskva'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по математике в Москве."
  tree : =>
    photo_src         : 'reclame_jump_page/math.jpg'
    alt               : 'Репетиторы по математике в Москве.'
    title             : 'Для чего нужен репетитор по математике в Москве?'
    #sub_title         : 'подготовка к ЕГЭ, ГИА, олимпиадам.'
    text              : '<p>Освоение математики вызывает трудности у большинства школьников — не каждый обладает логическим складом ума и способен сразу понять материал.</p> <p>Частный репетитор по математике поможет освоить те моменты, которые не смог объяснить учитель, ведь школьный педагог не всегда успевает поработать с каждым учеником. При этом найти репетитора по математике стоит заранее — школьнику необходимы регулярные занятия, чтобы освоить предмет и успешно сдать единый экзамен.</p> <p>Сейчас необязательно приглашать учителя домой или ездить к нему — уроки с репетитором математики по скайпу в онлайн режиме могут быть не менее эффективны, а стоимость их при этом будет меньше. Цена репетитора по математике зависит от опыта и квалификации преподавателя, если вы обращаетесь к студенту, конечно, стоимость будет ниже. Но опытный педагог лучше подаст материал и легче найдет подход к ребенку, поможет ему заложить фундамент серьезных знаний. Это важно, ведь итоговый экзамен придется сдать каждому школьнику.</p> <p>В нашей базе вы найдете лучших репетиторов по математике Москвы — мы бесплатно подберем вам преподавателя, учитывая все ваши пожелания.</p>'
    title_suit_tutors : 'Репетиторы по математике:<br><small>подготовка к экзаменам и олимпиадам</small>'
    landing_img       : 'reclame_background/mat.png'
    title_position    : 'top'
    button_color      : 'mat_color'
    filter :
      subject : [
        'математика'
      ]
