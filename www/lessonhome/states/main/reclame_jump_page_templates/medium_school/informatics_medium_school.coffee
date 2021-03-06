
class @main extends @template 'lp/all'
  route : '/repetitory-informatika-srednie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по информатике средние классы"
  tree : =>
    photo_src         : 'reclame_jump_page/land_informatics.jpg'
    alt               : 'Репетиторы по информатике средние классы'
    title             : 'Для чего нужен репетитор по информатике?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Информатика – один из предметов средней школы и его знание обязательно для каждого школьника. Услуги репетитора по информатике в 5-8 классе помогут освоить те моменты, которые не смог объяснить учитель, ведь школьный педагог не всегда успевает поработать с каждым учеником. При этом репетитор по информатике нужен с 5 класса, особенно если школьник планирует сдавать единый экзамен по этому предмету. Репетитор по информатике в 8 классе поможет школьнику успешно подготовиться к обучению в старших классах. Сейчас необязательно приглашать учителя домой – уроки по скайпу в онлайн режиме могут быть не менее эффективны, а стоимость их при этом будет меньше. Если вы обращаетесь к студенту в качестве репетитора по информатике на дому, конечно, стоимость будет ниже. Но опытный педагог лучше подаст материал и легче найдет подход к ребенку, поможет ему заложить фундамент серьезных знаний. В нашей базе вы найдете лучших репетиторов по информатике 5, 6, 7, 8 классов – мы бесплатно подберем вам преподавателя, учитывая все ваши пожелания.'
    title_suit_tutors : 'Репетиторы по информатике:<br><small>подготовка к ОГЭ (ГИА), экзаменам и олимпиадам</small>'
    landing_img       : 'reclame_background/inform.png'
    title_position    : 'bottom'
    button_color      : 'inform_color'
    filter :
      subject : [
        'информатика'
      ]
