class @main
  constructor : ->
    $W @
  show : =>
    @id = 0
    @clone = @tree.review.class
    @found.review_block.remove()
    @reviews = []
    @found.add_button.click => @add()
    reviews = (yield @$send './save') ? []
    console.log reviews
    @add r for r in reviews
  add : (data)=>
    c = @clone.$clone()
    c.setValue()
    c.id = @id++
    r = $('<div class="review_block"></div>')
    r.append c.dom
    @reviews.push c
    @found.reviews.append r
    c.on 'remove',=>
      r.remove()
      for cs,i in @reviews
        if cs.id == c.id
          @reviews.splice i,1
          break
    if data?
      c.setValue data
  save : =>
    {status,errs,err} = yield @$send './save', reviews:yield @getData()
    return true if status == 'success'
    console.log errs,err
    return false
  getData : =>
    reviews = []
    for r in @reviews
      reviews.push r.getValue()
    return reviews
    
