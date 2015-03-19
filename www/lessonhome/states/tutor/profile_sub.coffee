class @main extends template './show_tutor_pupil'
  tree : ->
    content           : state './profile_content' :
      count_review  : 10
    have_small_button : false
    menu_profile      : 'popup_profile_tutor'