

class @main extends EE
  Dom : =>
    @button = @found.button.parent()
    @checkbox = @found.checkbox
    @tree.value ?= {}
    @tree.default ?= {}
    @tree.default.selector ?= @tree.selector
    @tree.default = @getValue()
    #@tree.default.text = @found.button.
  show : =>
    @button.on  'mousedown', @mdown
    @button.on 'click',(e)=>
      return if e.button!=0
      e.preventDefault()
      @emit 'submit'
    @button.on 'click',  @check_place_click

  check_place_click :(e) =>
    if (!@checkbox.is(e.target) && @checkbox.has(e.target).length == 0)
      @tree.checkbox.class.changeValue()

  setActiveCheckbox : =>
    @tree.checkbox.class.setValue true

  setDeactiveCheckbox : =>
    @tree.checkbox.class.setValue false
  mdown : =>
    @button.addClass('press')
    $('body').on  'mouseup.tutor_button', @mup
    $('body').on  'mouseleave.tutor_button', @mup
    
  mup   : =>
    $('body').off  'mouseup.tutor_button'
    $('body').off  'mouseleave.tutor_button'
    @button.removeClass('press')
  setValue : (value={})=>
    o = {}
    @tree.value ?= {}
    oldSelector = (@tree.value?.selector ? @tree.default.selector) ? ''
    o[key] = val for key,val of @tree.default
    o[key] = val for key,val of value
    @tree.value = o
    if @tree.value.text?
      @found.button.find('.text').text @tree.value.text
    if @tree.value.pressed
      @found.button.addClass 'pressed'
    else
      @found.button.removeClass 'pressed'
    @found.button.removeClass oldSelector
    if @tree.value.selector?
      @found.button.addClass @tree.value.selector
    if @tree.value.color?
      @found.button.css 'background-color',@tree.value.color
    if @tree.value.text_color?
      @found.button.find('.text').css 'color',@tree.value.text_color
  getValue : =># @tree.value ? {}
    o = {}
    o[key] = val for key,val of (@tree.value ? {})
    o[key] = val for key,val of @tree.default
    o.text = @found.button.find('.text').text()
    o.text_color = @found.button.find('.text').css('color')
    o.color = @found.button.css('background-color')
    o.pressed = @found.button.hasClass 'pressed'
    return o


