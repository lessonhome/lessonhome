
class @main extends @template 'lp/all'
  route : '/repetitory-himiya-gia'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по химии ГИА"
  tree : =>
    photo_src         : 'reclame_jump_page/land_chemistry.jpg'
    alt               : 'Репетиторы по химии ГИА'
    title             : 'Для чего нужнен репетитор по химии?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Услуги репетитора по химии в 8-9 классе особенно необходимы тем школьникам, которые планируют сдавать ГИА по данному предмету. В 2016 году девятиклассники столкнутся с серьезными изменениями в государственной итоговой аттестации, в частности с увеличением количества экзаменов. Химия не относится к обязательным для сдачи предметам. Но ее нужно сдать тем, кто планирует обучение в профильном классе либо хочет поступить в медицинское училище или колледж. Чтобы успешно справиться со всеми частями экзамена, нужен репетитор по химии для подготовки к ГИА, который сможет помочь ученику освоить учебный материал и набрать хороший балл по экзаменационным заданиям. В нашей базе вы можете ознакомиться с анкетами лучших репетиторов по химии, обладающих значительным практическим опытом и знаниями, необходимыми для работы со школьниками. Здесь легко найти репетитора по химии для подготовки к ГИА, полностью соответствующего требованиям к педагогу, занимающемуся с вашим ребенком. Подбор преподавателя осуществляется бесплатно!'
    title_suit_tutors : 'Репетиторы по химии:<br><small>подготовка к ОГЭ (ГИА)</small>'
    landing_img       : 'reclame_background/chemis.png'
    title_position    : 'top'
    filter :
      subject : [
        'химия'
      ]
