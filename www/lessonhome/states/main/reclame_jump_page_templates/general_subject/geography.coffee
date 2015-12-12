
class @main extends @template 'lp/all'
  route : '/repetitory-geografiya'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по географии"
  tree : =>
    photo_src         : 'reclame_jump_page/land_geography.jpg'
    alt               : 'Репетиторы по географии'
    title             : 'Для чего нужен репетитор по географии?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'География – один из основных предметов средней школы и его знание обязательно для каждого школьника. Частный репетитор по географии поможет освоить те моменты, которые не смог объяснить учитель, ведь школьный педагог не всегда успевает поработать с каждым учеником. При этом найти репетитора по географии стоит заранее – школьнику необходимы регулярные занятия, чтобы освоить предмет и успешно сдать единый экзамен. Сейчас необязательно приглашать учителя домой – уроки с репетитором географии по скайпу в онлайн режиме могут быть не менее эффективны, а стоимость их при этом будет меньше. Цена репетитора по географии зависит от опыта и квалификации преподавателя, если вы обращаетесь к студенту, конечно, стоимость будет ниже. Но опытный педагог лучше подаст материал и легче найдет подход к ребенку, поможет ему заложить фундамент серьезных знаний. Это важно, ведь итоговый экзамен придется сдать каждому школьнику. В нашей базе вы найдете лучших репетиторов по географии Москвы – мы бесплатно подберем вам преподавателя, учитывая все ваши пожелания.'
    title_suit_tutors : 'Репетиторы по географии:<br><small>подготовка к экзаменам и олимпиадам</small>'
    landing_img       : 'reclame_background/georgaph-boy.png'
    title_position    : 'bottom'
    button_color      : 'georgaph_color'
    filter :
      subject : [
        'география'
      ]
