
class @main extends @template '../../main'
  access : ['other','pupil', 'tutor']
  redirect : {
  }
  tree : =>
    #materialize : @module 'lib/materialize'
    content : @module '$'  :
      filter : @exports()
      relevant_info : @module '$/relevant_info'  :
        photo_src : @exports()
        title : @exports()
        sub_title : @exports()
        text  : @exports()
      tutors : $form : tutors : 'tutor'
      title_suit_tutors : @exports()
      suit_tutors : @state 'main/preview/tutors_result' :
        image : {
          src: ''
          w: 1000
          h: 800
        }
        rating : 3.5
        reclame : true
        selector  : 'jump_visit_card'
        extract : 'jump_visit_card'
      # вытянуть значение
      #filling           : 100 # вытянуть значение
        cost      : 1000 # вытянуть значение
        value :
          name :
            first   : 'Андрей'
            middle  : 'Юрьевич'
            last    : 'Чехов'
          price_per_hour : 913.123
          subjects :
            'математика' :
              price :
                left : 900
          location :
            city : 'Москва'
        #tutor_name        : 'Чехов Андрей Юрьевич' # вытянуть значение
          with_verification : 'rgb(183, 210, 120)' # вытянуть значение
          tutor_subject     : 'Математика' # вытянуть значение
          status      : 'cтудент' # вытянуть значение
          experience         : 3 # вытянуть значение
          tutor_place       : 'МО Зеленоград' # вытянуть значение
          tutor_title       : 'Быстро устраню пробелы в школьной программе' # вытянуть значение
          about        : 'Коллектив выступает с несколькими программами. В танцевальной программе выступают 2 пары, исполняющие мексиканские танцы (харибе тапатио), возможен мастер-класс по латиноамериканским танцам' # вытянуть значение
          tutor_price       : 1500 # вытянуть значение
      button_bids : @module 'link_button' :
        href  : 'fast_bid/first_step'
        selector  : 'invite'
        text  : 'Оставить заявку'
        active  : true





