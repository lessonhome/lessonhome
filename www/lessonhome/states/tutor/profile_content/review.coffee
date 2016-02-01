class @main
  tree : => @module '$' :
    photo_src     : @exports()
    mini_rating_review  : @module 'rating_star':
      selector  : 'padding_no_small'
      filling   : @exports()
    user_name     : @exports()
    review_text   : @exports()
    creation_date : @exports()
