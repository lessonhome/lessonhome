class @main
  tree : -> @module '$' :
    bottom_block_attached : @module 'main/attached' :
      bottom_bar  : @state 'main/attached/bar'
      popup       : @state 'main/attached/popup'
    lib      : @state 'lib'
    header      : @state './tutor/header' :
      items : [
        @module 'tutor/header/button' : {
          title : 'О нас'
          href  : '/about_us'
          tag: 'pupil:about_us'
        }
        @module 'tutor/header/list_button' : {
          title : 'Найти репетитора'
          href  : '/second_step'
          tag: 'pupil:main_search'
        }
        @module 'tutor/header/button' : {
          title : 'Помощь'
          href  : '/support'
          tag: 'support'
        }
        @module 'tutor/header/list_button' : {
          tag   : 'pupil:main_tutor'
          title : 'Репетиторам'
          href  : '/main_tutor'
        }
      ]
    attach_tutor : @module 'main/add_tutors'  :
      tutors : [
        @module 'main/add_tutors/tutor_small' :
          src : '#'
        @module 'main/add_tutors/tutor_small' :
          src : '#'
        @module 'main/add_tutors/tutor_small' :
          src : '#'
      ]
    popup            : @exports()              # show info about tutor in main page
    popup_close_href : @exports()              # in pair with popup
    filter_top       : @exports()              # top filter in main page
    info_panel       : @exports()              # info panel in main page
    content          : @exports()              # after info panel block in main page
    footer           : @state 'footer'         # footer in main page