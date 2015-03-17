###
API:
  pattern : <regexp> #required
  min : <minimum_if_pattern_is_digits> #optional
  max : <maximum_if_pattern_is_digits> #optional
  errMessage : <message_about_error> #optional
  allowSymbolsPattern : <chars allowed for input> #optional
  hint : <hint_popup_on_focus>
  --------------------------

  or:
  validators {
    '0': {
      pattern : <regexp>
      min : <minimum_if_pattern_is_digits>
      max : <maximum_if_pattern_is_digits>.
      errMessage : <message_about_error>
    },
    '1': {
      pattern : <regexp>
      min : <minimum_if_pattern_is_digits>
      max : <maximum_if_pattern_is_digits>.
      errMessage : <message_about_error>
    };
    ...
      'x': {
      ...
    };
    'errMessage': <General error message>
    'allowSymbolsPattern': <chars allowed for input>
    'hint' : <hint_popup_on_focus>
  }
Example:
  pattern     : '^\d{1,2}$' #required using some like: (dataObject 'checker').patterns.digits
  min         : 0
  max         : 24
  errMessage  : 'Укажите кол-во часов в диапазоне от 0 до 24
###

class @main extends EE
  constructor : ->
  Dom : =>
    @box    = @found.box
    @input  = @box.children "input"
    #@box   = @dom.find ".box"
    @outputErr    = @box.next('.output-error')
    @hint         = @box.siblings('.input__hint')
    @hintMessage  = @hint.find('.hint-message')
    @val    = @input.val()
  show : =>
    @input.on 'focus', => @box.addClass 'focus'
    @input.on 'focusout', => @box.removeClass 'focus'

    @input.on 'focus', =>
      if @tree.hint?
        @hint.fadeIn()

    @input.on 'focusout', =>
      @hint.hide()
    #Check allowed input chars
    @input.on 'keypress', (event)=>
      allowPatt = @getValidators().allowSymbolsPattern
      if !allowPatt?
        return true
      else return (new RegExp(allowPatt).test String.fromCharCode(event.keyCode))

    @input.on 'focus', (event)=>
      @setNormalState()
    @input.on 'blur', @checkInput

    keyDownTime = 0
    keyDownDT   = 500
    keyDownTimeout = =>
      t = new Date().getTime()
      return if (t-keyDownTime)<keyDownDT
      @checkInput()

    @input.on 'keydown', =>
      keyDownTime = new Date().getTime()
      setTimeout keyDownTimeout,keyDownDT


  ############## Share ###############
  getObjectNumIndexes : (obj)->
    Object.keys(obj).filter (key)->
      !(isNaN Number(key))
  ####################################

  outErr : (err)=>
    @outputErr.text(err)
    @outputErr.addClass('output-error__show')

  cleanErr : =>
    @outputErr.removeClass('output-error__show')
    @outputErr.text('')

  addStyleBadInput : =>
    @box.addClass('bad-input')

  removeStyleBadInput : =>
    @box.removeClass('bad-input')

  # Note!
  #If module instance saved into 'first_name' property then pattern maybe finded by this path:
  #Feel.root.tree.content.popup.content.first_name.pattern
  getValidators : =>
    res = @tree.validators
    if res?
      return res
    {
      '0': {
        pattern: @tree.pattern
        min: @tree.min
        max: @tree.max
        errMessage: @tree.errMessage
      },
      'allowSymbolsPattern': @tree.allowSymbolsPattern
    }

  maybeOutputErrMessage : (errMessage)=>
    if errMessage? then @outErr errMessage
  setNormalState : =>
    @removeStyleBadInput()
    @cleanErr()


  checkInput : =>
    check = Feel.checker.check
    checkMinMax = Feel.checker.checkMinMax
    checkDigits = Feel.checker.checkDigits
    validators = @getValidators()
    val = @input.val()
    return if val == @val
    @val = val
    if (val? && val != '') && validators?
      res = []
      for idx in @getObjectNumIndexes(validators)
        curValidator = validators[idx]
        patt = curValidator.pattern
        if patt?
          min = curValidator.min
          max = curValidator.max
          isBadInput = !(check patt, val)
          ### Extra check if exist min and max ###
          if !isBadInput && (min? || max?) && (checkDigits val)
            isBadInput = !(checkMinMax min, val, max)
          if isBadInput then res.push curValidator
      if (res.length > 0) && (res.length == @getObjectNumIndexes(validators).length)
        @addStyleBadInput @box
        if validators.errMessage?
          @maybeOutputErrMessage validators.errMessage
        else
          @maybeOutputErrMessage res[0].errMessage
      else
        @setNormalState()
    else
      @setNormalState()
    #################
    @emit 'change',@val

  setValue: (value)=>
    @checkInput()
    return if value == @val
    @found.box.children('input').val(value)
    @checkInput()

  getValue: =>
    @checkInput()
    return @val
    #@found.box.children('input').val()
