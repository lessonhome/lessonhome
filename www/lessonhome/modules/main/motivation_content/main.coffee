class @main extends EE
  Dom: =>
    @motivation_block_start = @tree.motivation_block_start.class
  show : =>
    Feel.HashScrollControl @dom
    #@motivation_block_start.submit()
