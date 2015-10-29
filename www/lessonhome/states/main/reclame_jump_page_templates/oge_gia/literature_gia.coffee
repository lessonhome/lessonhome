
class @main extends @template 'lp/all'
  route : '/repetitory-literatura-gia'
  #tags  : -> ['registration']
  model : 'main/registration'
  title : "Репетиторы по литературе ГИА"
  tree : =>
    photo_src         : 'reclame_jump_page/land_literature.jpg'
    alt               : 'Репетиторы по литературе ГИА'
    title             : 'Для чего нужен репетитор по литературе?'
    #sub_title         : 'подготовка к ЕГЭ'
    text              : 'Услуги репетитора по литературе в 8-9 классе особенно необходимы школьнику, если онпланирует сдачу ГИА по данному предмету. В 2016 году девятиклассники столкнутся с серьезными изменениями в государственной итоговой аттестации, в частности с увеличением количества экзаменов. Литература относится к необязательным для ГИА предметом, однако, сдать ее нужно для поступления в профильные классы или средние учебные учреждения. Чтобы успешно сдать все части экзамена, нужен репетитор по литературе для подготовки к ГИА. Опытный преподаватель сможет помочь ученику освоить учебный материал и набрать хороший балл по экзаменационным вопросам. В нашей базе вы можете ознакомиться с анкетами лучших репетиторов по литературе, обладающих значительным практическим опытом и знаниями, необходимыми для работы со школьниками. Здесь легко найти репетитора по литературе для подготовки к ГИА, полностью соответствующего требованиям к педагогу, занимающемуся с вашим ребенком. Подбор преподавателя осуществляется бесплатно!'
    title_suit_tutors : 'Репетиторы по литературе:<br><small>подготовка к ОГЭ (ГИА)</small>'
    filter :
      subject : [
        'литература'
      ]
      course : [
      ]