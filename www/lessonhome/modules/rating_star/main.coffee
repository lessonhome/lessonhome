

class @main
  Dom : =>
    window.RS = @
  show : =>

  setValue : (value={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    if @tree.value?.rating?
      r = @tree.value.rating
      @tree.value.rating = Math.ceil(r*60)/60
      @tree.filling = @tree.value.rating*100/5
    tf = @tree.filling*5
    tf = Math.round(tf*20/100)*100/20
    sf = tf/100
    np = Math.floor sf
    p = 4
    ws = 18
    switch @tree.selector
      when 'padding_no'
        p = 0
        ws = 22
      when 'padding_no_small'
        p = 0
        ws = 10
      when 'padding_1px_small'
        p = 1
        ws = 10
    if sf != np
      wcf = sf*ws+np*p
    else
      wcf = sf*ws+np*p-p
    @dom.find('.cut_filling').width wcf





