
class @main extends @template 'lp/all'
  route : '/repetitory-geografiya-gia'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по географии ГИА"
  tree : =>
    photo_src         : 'reclame_jump_page/land_geography.jpg'
    alt               : 'Репетиторы по географии ГИА'
    title             : 'Для чего нужен репетитор по географии?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Услуги репетитора по географии в 8-9 классе особенно необходимы тем школьникам, которые планируют сдавать ГИА по данному предмету. В 2016 году девятиклассники столкнутся с серьезными изменениями в государственной итоговой аттестации, в частности с увеличением количества экзаменов. География не относится к обязательным для сдачи предметам. Ее нужно сдать тем, кто планирует обучение в профильном классе. Чтобы успешно справиться со всеми частями экзамена, нужен репетитор по географии для подготовки к ГИА, который сможет помочь ученику освоить учебный материал и набрать хороший балл по экзаменационным заданиям. В нашей базе вы можете ознакомиться с анкетами лучших репетиторов по географии, обладающих значительным практическим опытом и знаниями, необходимыми для работы со школьниками. Здесь легко найти репетитора по географии для подготовки к ГИА, полностью соответствующего требованиям к педагогу, занимающемуся с вашим ребенком. Подбор преподавателя осуществляется бесплатно!'
    title_suit_tutors : 'Репетиторы по географии:<br><small>подготовка к ОГЭ (ГИА)</small>'
    landing_img       : 'reclame_background/georgaph-boy.png'
    title_position    : 'bottom'
    button_color      : 'georgaph_color'
    filter :
      subject : [
        'география'
      ]
