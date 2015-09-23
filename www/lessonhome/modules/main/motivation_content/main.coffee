class @main extends EE
  Dom: =>
    @motivation_block_start = @tree.motivation_block_start.class

    @best = yield Feel.dataM.getBest(4)

    cloned = @tree.reps[0].class.$clone()

    $('<div class="reps"></div>').append cloned.dom

    cloned.setValue @best[0]
  show : =>
    Feel.HashScrollControl @dom
    #@motivation_block_start.submit()
