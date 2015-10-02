class @main
  constructor : ->
    $W @
  show : =>
    @clone = @found.review_block
    @clone.remove()
    @found.add_button.click =>
      r = @clone.clone true,true
      r.removeClass 'hidden'
      r.find('.remove_button').click => r.remove()
      @found.reviews.append r

  save : =>
    {status,errs,err} = yield @$send './save', yield @getData()
    return true if status == 'success'
    console.log errs,err
    return false
  getData : =>
    
