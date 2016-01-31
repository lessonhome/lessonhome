class @main extends @template '../show_tutor_pupil'
  tree : ->
    content           : @state './reviews_content'
    have_small_button : true
    menu_reviews      : 'popup_reviews_tutor'
