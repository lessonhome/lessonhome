
class @main extends @template 'lp/all'
  route : '/repetitory-fizika'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по физике"
  tree : =>
    photo_src         : 'reclame_jump_page/land_physics.jpg'
    alt               : 'Репетиторы по физике'
    title             : 'Для чего нужен репетитор по физике?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : '<p>Услуги репетитора по физике в 8-9 классе особенно необходимы тем школьникам, которые планируют сдавать ГИА по данному предмету.</p> <p>В 2016 году девятиклассники столкнутся с серьезными изменениями в государственной итоговой аттестации, в частности с увеличением количества экзаменов.</p> <p>Физика не относится к обязательным для сдачи предметам. Но ее нужно сдать тем, кто планирует обучение в профильном физматклассе либо хочет поступить в техническое училище или колледж.</p> <p>Чтобы успешно справиться со всеми частями экзамена, нужен репетитор по физике для подготовки к ГИА, который сможет помочь ученику освоить учебный материал и набрать хороший балл по экзаменационным заданиям. В нашей базе вы можете ознакомиться с анкетами лучших репетиторов по физике, обладающих значительным практическим опытом и знаниями, необходимыми для работы со школьниками. Здесь легко найти репетитора по физике для подготовки к ГИА, полностью соответствующего требованиям к педагогу, занимающемуся с вашим ребенком.</p> <p>Подбор преподавателя осуществляется бесплатно!</p>'
    title_suit_tutors : 'Репетиторы по физике:<br><small>подготовка к экзаменам и олимпиадам</small>'
    filter :
      subject : [
        'физика'
      ]
      course : [
      ]
