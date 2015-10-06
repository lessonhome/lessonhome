


class @main
  tree : => @module '$' :
    showrating    : @exports()
    image         : @exports()
    showsubject       : @exports()
    close         : @exports()
    count_review  : @exports()
    cost          : @exports()
    selector      : @exports 'extract'
    rev_selector  : @exports()

    all_rating    : @module 'rating_star'  :
      selector  : @exports()
      value :
        rating    : @exports()
      filling   : @exports()