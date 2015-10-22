
@$subject  = require './subjects'
@$phrases   = require './phrases'
@$postfix   = require './postfix'
@$photos    = require './photos'
@$classes = ['1','2','3']

@pages = [
  # репетиторы +по предмет репетиторы предмет
  {
    title : '$phrases.repetitory по $subject.name:dative'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_general'
    filter : {
      subject : ['$subject.name']
    }
    href  : '/$phrases.repetitory:en-$subject.name:en'
    direct:
      group_name    : '$phrases.repetitory $subject.name'
      title1        : '$phrases.repetitory по $subject.name:dative'
      title2        : '$phrases.repetitory $subject.name:genitive'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative по $subject.name:dative бесплатно в Москве'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $subject.name:genitive бесплатно.'
      keys          : [
        '$phrases.repetitory +по $subject.name:genitive'
        '$phrases.repetitory $subject.name:genitive'
      ]
      minus : ''
  }
  # репетиторы егэ предмет
  {
    title : '$phrases.repetitory $course.ege по $subject.name:dative'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$phrases.repetitory:en-$course.ege:en-$subject.name:en'
    direct:
      group_name    : '$phrases.repetitory $course.ege $subject.name'
      title1        : '$phrases.repetitory $course.ege по $subject.name:dative'
      title2        : '$phrases.repetitory $course.ege $subject.name:genitive'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege по $subject.name:dative бесплатно в Москве'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege $subject.name:genitive бесплатно.'
      keys          : [
        '$phrases.repetitory $course.ege +по $subject.name:dative'
        '$phrases.repetitory $course.ege $subject.name:genitive'
      ]
      minus : ''
  }

  # подготовка к егэ
  {
    title : '$phrases.repetitory по $subject.name:dative подготовка к $course.ege'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$phrases.repetitory:en-$subject.name:en-podgotovka-$course.ege:en'
    direct:
      group_name    : 'Подготовка $course.ege $subject.name'
      title1        : 'Подготовка к $course.ege по $subject.name:dative'
      title2        : 'Подготовка $course.ege $subject.name:genitive'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege по $subject.name:dative бесплатно в Москве'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege $subject.name:genitive бесплатно.'
      keys          : [
        'Подготовка +к $course.ege +по $subject.name:dative'
        'Подготовка +к $course.ege +по $subject.name:dative в Москве'
        'Подготовка $course.ege $subject.name:genitive'
        'Подготовка $course.ege $subject.name:genitive в Москве'
      ]
      minus : ''
  }

  # подготовка к егэ базовый уровень математика
  {
    title : '$phrases.repetitory по математике подгтовка к $course.ege $postfix.base уровень'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$phrases.repetitory:en-$subject.name:en-podgotovka-$course.ege:en-postfix.base:en'
    direct:
      group_name    : 'Подготовка $course.ege  $subject.name postfix.base'
      title1        : 'Подготовка к $course.ege по математике postfix.base уровень'
      title1        : 'Подготовка к $course.ege по математике postfix.base'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege postfix.base уровнь бесплатно в Москве'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege postfix.base уровнь бесплатно'
      keys          : [
        'Подготовка +к $course.ege +по математике postfix.base уровень'

      ]
      minus : ''
  }

  # репетитор егэ по предмет в москве
  {
    title : '$phrases.repetitory $course.ege по $subject.name:dative в $place.city'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$phrases.repetitory:en-$course.ege:en-$subject.name:en-place.city:en'
    direct:
      group_name    : '$phrases.repetitory $course.ege $subject.name place.city'
      title1        : '$phrases.repetitory $course.ege по $subject.name:dative в place.city'
      title2        : '$phrases.repetitory $course.ege по $subject.name:dative в place.city'
      title3        : '$phrases.repetitory $course.ege по $subject.name:dative'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege по $subject.name:dative бесплатно в Москве'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $course.ege $subject.name:genitive бесплатно.'
      keys          : [
        '$phrases.repetitory $course.ege +по $subject.name:dative в Москве'
        '$phrases.repetitory $course.ege $subject.name:genitive в Москве'
      ]
      minus : ''
  }
  # репетитор по предмет онлайн подготовка к ЕГЭ
  {
    title : '$phrases.repetitory по $subject.name:dative postfix.online подготовка к course.ege'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
      place : remote : true
    }
    href  : '/$phrases.repetitory:en-$subject.name:en-$course.ege:en'
    direct:
      group_name    : '$phrases.repetitory $subject.name postfix.online подготовка к course.ege'
      title1        : '$phrases.repetitory по $subject.name:dative postfix.online'
      title2        : '$phrases.repetitory $subject.name:genitive'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative по $subject.name:dative postfix.online. Подгоовка к course.ege.'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $subject.name:genitive postfix.online.'
      keys          : [
        '$phrases.repetitory +по $subject.name:dative postfix.online подготовка к course.ege'
      ]
      minus : ''
  }

  # репетитор по предмет подготовка к ЕГЭ 2016
  {
    title : '$phrases.repetitory по $subject.name:dative подготовка к course.ege 2016'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$phrases.repetitory:en-$subject.name:en-$course.ege:en-2016'
    direct:
      group_name    : '$phrases.repetitory $subject.name подготовка к course.ege 2016'
      title1        : '$phrases.repetitory по $subject.name:dative course.ege 2016'
      title2        : '$phrases.repetitory $subject.name:genitive course.ege'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative по $subject.name:dative. Подгоовка к course.ege 2016.'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative $subject.name:genitive course.ege 2016.'
      keys          : [
        '$phrases.repetitory +по $subject.name:dative подготовка к course.ege 2016'
      ]
      minus : ''
  }

  # профильный репетитор ЕГЭ по предмет
  {
    title : '$postfix.profi $phrases.repetitory по $subject.name:dative course.ege'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$postfix.profi:en-$phrases.repetitory:en-$subject.name:en-$course.ege:en'
    direct:
      group_name    : '$postfix.profi $phrases.repetitory $subject.name course.ege'
      title1        : '$postfix.profi $phrases.repetitory по $subject.name:dative course.ege'
      title2        : '$phrases.repetitory $subject.name:genitive course.eg'
      text1         : 'Занятия от 400 р/час. Найди $postfix.profi:accusative $phrases.repetitory:accusative по $subject.name:dative.'
      keys          : [
        '$phrases.repetitory +по $subject.name:dative подготовка к course.ege 2016'
      ]
      minus : ''
  }

  # репетитор по предмет эксперт ЕГЭ
  {
    title : '$phrases.repetitory по $subject.name:dative course.ege'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$phrases.repetitory:en-$subject.name:en-postfix.expert:en-$course.ege:en'
    direct:
      group_name    : '$phrases.repetitory $subject.name postfix.expert course.ege'
      title1        : '$phrases.repetitory по $subject.name:dative postfix.expert course.ege'
      title2        : '$phrases.repetitory $subject.name:genitive postfix.expert course.ege'
      title3        : '$phrases.repetitory $subject.name:genitive course.ege'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative по $subject.name:dative postfix.expert course.ege.'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative по $subject.name:dative postfix.expert'
      keys          : [
        '$phrases.repetitory +по $subject.name:dative подготовка к course.ege 2016'
      ]
      minus : ''
  }

  # репетитор по предмет эксперт ЕГЭ
  {
    title : '$phrases.repetitory по $subject.name:dative course.ege'
    subtitle : ''
    photo : '$subject.photo'
    text : '$subject.text_ege'
    filter : {
      subject : ['$subject.name']
      course : ['егэ']
    }
    href  : '/$phrases.repetitory:en-$subject.name:en-postfix.expert:en-$course.ege:en'
    direct:
      group_name    : '$phrases.repetitory $subject.name postfix.expert course.ege'
      title1        : '$phrases.repetitory по $subject.name:dative postfix.expert course.ege'
      title2        : '$phrases.repetitory $subject.name:genitive postfix.expert course.ege'
      title3        : '$phrases.repetitory $subject.name:genitive course.ege'
      text1         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative по $subject.name:dative postfix.expert course.ege.'
      text2         : 'Занятия от 400 р/час. Найди $phrases.repetitory:accusative по $subject.name:dative postfix.expert'
      keys          : [
        '$phrases.repetitory +по $subject.name:dative подготовка к course.ege 2016'
      ]
      minus : ''
  }
]
