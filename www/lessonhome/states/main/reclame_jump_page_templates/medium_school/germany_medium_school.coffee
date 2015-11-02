
class @main extends @template 'lp/all'
  route : '/repetitory-nemeckij-srednie-klassy'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по немецкому языку средние классы"
  tree : =>
    photo_src         : 'reclame_jump_page/land_german.jpg'
    alt               : 'Репетиторы по немецкому языку средние классы'
    title             : 'Для чего нужен репетитор по немецкому языку?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : ''
    title_suit_tutors : 'Репетиторы по немецкому языку:<br><small>подготовка к ОГЭ (ГИА), экзаменам и олимпиадам</small>'
    filter :
      subject : [
        'немецкий язык'
      ]
