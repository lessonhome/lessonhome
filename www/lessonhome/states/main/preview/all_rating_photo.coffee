


class @main
  tree : => @module '$' :
    image         : @exports()
    close         : @exports()
    count_review  : @exports()
    selector      : @exports 'extract'
    rev_selector  : @exports()
    ###
      all_rating    : @module 'rating_star'  :
        selector  : @exports()
        value :
          rating    : @exports()
        filling   : @exports()
    ###