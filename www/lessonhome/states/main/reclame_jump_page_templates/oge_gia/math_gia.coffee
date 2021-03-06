class @main extends @template 'lp/all'
  route : '/repetitory-matematika-gia'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по математике 9 классы."
  tree : =>
    photo_src         : 'reclame_jump_page/math.jpg'
    alt               : 'Репетиторы по математике 9 классы.'
    title             : 'Для чего нужен репетитор по математике 8-9 классы?'
    #sub_title         : 'подготовка к ГИА'
    text              : 'Услуги репетитора математики в 8-9 классе особенно необходимы школьнику – ведь впереди его ждет ГИА, от результатов которой зависит его переход в старшие классы. В следующем учебном году девятиклассники столкнутся с серьезными изменениями в государственной итоговой аттестации, в частности с увеличением количества экзаменов. Математика останется обязательным для сдачи предметом, а с 2017 года полученная на экзамене оценка будет включена в аттестат школьника. Чтобы успешно сдать все части экзамена, нужен репетитор по математике 9 класса, который сможет помочь ученику подготовиться и набрать хороший балл по экзаменационным заданиям. В нашей базе вы можете ознакомиться с анкетами лучших репетиторов по математике 9 класса, обладающих значительным практическим опытом и знаниями, необходимыми для работы со школьниками. Здесь легко найти репетитора математики 9 класса, полностью соответствующего требованиям к педагогу, занимающемуся с вашим ребенком. Подбор преподавателя осуществляется бесплатно!'
    title_suit_tutors : 'Репетиторы по математике:<br><small>подготовка к ОГЭ (ГИА)</small>'
    landing_img       : 'reclame_background/mat.png'
    title_position    : 'top'
    button_color      : 'mat_color'
    filter :
      subject : [
        'математика'
      ]
      course : [
        'гиа'
      ]
