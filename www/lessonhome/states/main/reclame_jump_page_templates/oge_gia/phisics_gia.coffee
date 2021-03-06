
class @main extends @template 'lp/all'
  route : '/repetitory-fizika-gia'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по физике гиа"
  tree : =>
    photo_src         : 'reclame_jump_page/land_physics.jpg'
    alt               : 'Репетиторы по физике гиа'
    title             : 'Для чего нужен репетитор по физике?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Услуги репетитора по физике в 8-9 классе особенно необходимы тем школьникам, которые планируют сдавать ГИА по данному предмету. В 2016 году девятиклассники столкнутся с серьезными изменениями в государственной итоговой аттестации, в частности с увеличением количества экзаменов. Физика не относится к обязательным для сдачи предметам. Но ее нужно сдать тем, кто планирует обучение в профильном физматклассе либо хочет поступить в техническое училище или колледж. Чтобы успешно справиться со всеми частями экзамена, нужен репетитор по физике для подготовки к ГИА, который сможет помочь ученику освоить учебный материал и набрать хороший балл по экзаменационным заданиям. В нашей базе вы можете ознакомиться с анкетами лучших репетиторов по физике, обладающих значительным практическим опытом и знаниями, необходимыми для работы со школьниками. Здесь легко найти репетитора по физике для подготовки к ГИА, полностью соответствующего требованиям к педагогу, занимающемуся с вашим ребенком. Подбор преподавателя осуществляется бесплатно!'
    title_suit_tutors : 'Репетиторы по физике:<br><small>подготовка к ОГЭ (ГИА)</small>'
    landing_img       : 'reclame_background/physics.png'
    title_position    : 'bottom'
    button_color      : 'physics_color'
    filter :
      subject : [
        'физика'
      ]
      course : [
      ]
