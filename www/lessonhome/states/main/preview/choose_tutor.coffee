class @main
  tree : => module '$' :
    src         : @exports()
    all_rating  : module 'rating_star'  :
      selector    : 'padding_1px_small'
    filling     : @exports()

  init : =>
    @tree.all_rating.filling = @tree.filling