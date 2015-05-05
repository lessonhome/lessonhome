

class @main extends EE
  Dom : =>
    @button = @found.button.parent()
  show : =>
    @button.on  'mousedown', @mdown
    @button.on 'click',(e)=>
      return if e.button!=0
      e.preventDefault()
      @emit 'submit'
  mdown : =>
    @button.addClass('press')
    $('body').on  'mouseup.tutor_button', @mup
    $('body').on  'mouseleave.tutor_button', @mup
    
  mup   : =>
    $('body').off  'mouseup.tutor_button'
    $('body').off  'mouseleave.tutor_button'
    @button.removeClass('press')

