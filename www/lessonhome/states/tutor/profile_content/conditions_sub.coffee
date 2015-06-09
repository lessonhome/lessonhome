class @main extends @template '../show_tutor_pupil'
  tree : =>
    content           : @state './conditions_content'
    have_small_button : true
    menu_conditions   : 'popup_conditions_tutor'