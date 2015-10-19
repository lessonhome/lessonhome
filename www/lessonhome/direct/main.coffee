
@$subject  = require './subjects'
@$phrases   = require './phrases'
@$postfix   = require './postfix'
@$photos    = require './photos'
@$classes = ['1','2','3']


@pages = [
  {
    title : '$phrases.repetitory $classes $subject:dative $postfix'
    subtitle : ''
    photo : '$photos.math'
    text : '$File:math'
    filter : {
      subject : ['$subject']
    }
    href  : '/$phrases.repetitory:dative:en'
    direct:
      group_name    : '$subject'
      title         : ''
      title2        : ''
      text          : ''
      text2         : ''
      keys          : [
        '$phrases.podgotovka $postfix $subject'
      ]
      minus : '2016 $$[classes]'
  }
  {
    title : '$phrases.repetitory $subject:dative и $$subject:dative $postfix'
    subtitle : ''
    photo : '$photos.math'
    text : '$File:math'
    filter : {
      subject : ['$subject','$subject','$subject']
    }
    href  : '/$phrases.repetitory:dative:en'
    direct:
      group_name    : '$subject'
      title         : ''
      title2        : ''
      text          : ''
      text2         : ''
      keys          : [
        '$phrases.podgotovka $postfix $subject'
      ]
      minus : ''
  }
]
