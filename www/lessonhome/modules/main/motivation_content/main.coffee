class @main extends EE
  Dom: =>
    $('div.rep').first().hide()
    @motivation_block_start = @tree.motivation_block_start.class

    @best = yield Feel.dataM.getBest(4)

    i = 1
    for prep in @best
      cloned = @tree.reps[0].class.$clone()
      cloned.setValue prep
      rep = $('<div class="rep"></div>')
      rep.append cloned.dom
      rep.appendTo('div.reps')
      rep.css('visibility', 'visible')
      rep.animate({opacity : 1}, 200*i)
      i *= 2

  show : =>
    Feel.HashScrollControl @dom
    #@motivation_block_start.submit()
