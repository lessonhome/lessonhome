
class @main extends @template 'lp/all'
  route : '/repetitory-obshchestvoznanie-gia'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по обществознанию ГИА"
  tree : =>
    photo_src         : 'reclame_jump_page/land_society_ege.jpg'
    alt               : 'Репетиторы по обществознанию ГИА'
    title             : 'Для чего нужен репетитор по обществознанию?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Услуги репетитора по обществознанию в 8-9 классе особенно необходимы тем школьникам, которые планируют сдавать ГИА по данному предмету. В 2016 году девятиклассники столкнутся с серьезными изменениями в государственной итоговой аттестации, в частности с увеличением количества экзаменов. Обществознание не относится к обязательным для сдачи предметам. Но ее нужно сдать тем, кто планирует обучение в профильном классе или хочет лучше подготовиться к сдаче ЕГЭ. Чтобы успешно справиться со всеми частями экзамена, нужен репетитор по обществознанию для подготовки к ГИА, который сможет помочь ученику освоить учебный материал и набрать хороший балл по экзаменационным заданиям. На нашем сайте вы можете ознакомиться с анкетами лучших репетиторов по обществознанию, обладающих значительной практикой и знаниями, необходимыми для работы со школьниками. Здесь легко найти репетитора по обществознанию для подготовки к ГИА, полностью соответствующего требованиям к педагогу, занимающемуся с вашим ребенком. Подбор преподавателя осуществляется бесплатно!'
    title_suit_tutors : 'Репетиторы по обществознанию:<br><small>подготовка к ОГЭ (ГИА)</small>'
    landing_img       : 'reclame_background/social.png'
    title_position    : 'bottom'
    button_color      : 'social_color'
    opacity_form      : 'rgba(0,0,0,0.5)'
    filter :
      subject : [
        'обществознание'
      ]
