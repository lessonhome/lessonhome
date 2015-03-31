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
#
#
#


class @main extends EE
  Dom : =>
    @input  = @found.input
    @label  = @dom.find ">label"
    @tree.match   ?= {}
    @tree.replace ?= {}
    if typeof @tree.match =='string'
      @tree.match = 0:@tree.match
    for key,val of @tree.match
      @tree.match[key] = new RegExp val
    @tree.replace = @parseRegexpObj @tree.replace
    @tree.replaceCursor = @parseRegexpObj @tree.replaceCursor,''
  parseRegexpObj : (obj,ext='mg')=>
    obj ?= {}
    if typeof obj =='string'
      obj = 0:obj
    nobj = {}
    for key,val of obj
      if typeof val == 'string'
        reg = new RegExp val,ext
        s   = ""
      else
        reg = Object.keys val
        s   = val[reg[0]]
        reg = new RegExp reg[0],ext
      nobj[key] = [reg,s]
    return nobj
  show    : =>
    @input.on 'focus',    @onFocus
    @input.on 'focusout', @onBlur
    @input.on 'blur', @onBlur
    @input.on 'input',    @onInput
    @input.on 'keypress',  @onKeyPress
    @input.on 'keydown',  @onKeyDown
    @input.on 'keyup',    @onKeyUp
    @input.on 'paste',    @onPaste
  onPaste : =>
    setTimeout =>
      @emit 'paste'
      @input.setCursorPosition @input.val().length
    ,1
  onFocus : =>
    @emit 'focus'
    @label.addClass 'focus'
    if @tree.selectOnFocus
      setTimeout =>
        @input.setSelection(0,@input.val().length)
      ,0
  onBlur  : =>
    @emit 'blur'
    @label.removeClass 'focus'
    console.log 'blur'
  onInput   : =>
    @replaceInput()
    setTimeout @checkChange,0
  onKeyDown : (e)=>
    switch e.keyCode
      when 13
        e.preventDefault()
        @emit 'submit',@input.val()
    setTimeout @checkChange,0
  onKeyPress : (e)=>
    try position = @input.getCursorPosition()

    val = @input.val()
    try
      start = @input.getSelectionStart()
      end = @input.getSelectionEnd()
      unless start? || end?
        start = val.length
        end = val.length
      str = val.substr(0,start)+String.fromCharCode(e.keyCode)+val.substr(end)
    catch e
      console.error e
      str = val+String.fromCharCode(e.keyCode)
    rstr = @matchReplace str
    if rstr == str
      return
    else if val == rstr
      return e.preventDefault()
    else
      e.preventDefault()
      @replaceInput val,rstr,position,true
  matchReplace : (rstr)=>
    for key,v of @tree.replace
      nv = rstr.replace v[0],v[1]
      rstr = nv
    return rstr
  replaceInput : (val,rstr,position,forceCursor=false)=>
    val     ?= @input.val()
    rstr    ?= @matchReplace val
    position?= @input.getCursorPosition()
    return if @input.val()==rstr
    @input.val rstr
    rc = false
    if forceCursor then for key,v of @tree.replaceCursor
      if m = rstr.substr(position).match v[0]
        rc = true
        position += m.index
    if forceCursor then if !rc && Math.abs(val.length-rstr.length)<=1
      position ?= val.length
      if rstr.length > val.length
        position++
      else if rstr.length==val.length
        if rstr.substr(0,position+1)!= val.substr(0,position+1)
          position++
      @input.setCursorPosition position
    if (rc && forceCursor) || !forceCursor
      @input.setCursorPosition position
    
      @input.setCursorPosition position

    ###
    e.preventDefault()
    console.log "nval: '#{str}'"
    console.log @input
    ###
    #console.log 'kdown',e,"'#{@input.val()}'#{String.fromCharCode(e.keyCode)}'"
  onKeyUp   : =>
  checkChange : =>
    val = @input.val()
    if @val != val
      @val = val
      @emit 'change',@val
  setValue : (val)=>
    @checkChange()
    if val != @val
      @input.val val
      @replaceInput()
      @checkChange()
  getValue : => @val

###
class @main extends EE
  constructor : ->
  Dom : =>
    @label        = @dom.find ">label"
    @box          = @found.box
    @input_box    = @found.input_box
    @input        = @found.input
    @outputErr    = @found.output_error
    @hint         = @found.input_hint
    @hintMessage  = @found.hint_message
    @val          = @input.val()

  show : =>
    @input.on 'focus', =>
      @label.addClass 'focus'
      if @tree.hint?
        @hint.fadeIn()
    @input.on 'keydown', (e)=>
      console.log e.keyCode
      if e.keyCode == 13 then @emit 'pressingEnter'


    @input.on 'focusout', =>
      @label.removeClass 'focus'
      @hint.hide()
    #Check allowed input chars
    @input.on 'keypress', (event)=>
      allowPatt = @getValidators().allowSymbolsPattern
      if !allowPatt?
        return true
      else return (new RegExp(allowPatt).test String.fromCharCode(event.keyCode))

    @input.on 'focus', (event)=>
      @setNormalState()
    #@input.on 'blur', @checkInput

    keyDownTime = 0
    keyDownDT   = 500
    keyDownTimeout = =>
      t = new Date().getTime()
      return if (t-keyDownTime)<keyDownDT
      @checkInput()

    @input.on 'keydown', =>
      keyDownTime = new Date().getTime()
      setTimeout keyDownTimeout,keyDownDT


  getObjectNumIndexes : (obj)->
    Object.keys(obj).filter (key)->
      !(isNaN Number(key))

  outErr : (err)=>
    console.log err
    @outputErr.text(err)
    @outputErr.addClass('output_error_show')

  cleanErr : =>
    @outputErr.removeClass('output_error_show')
    @outputErr.text('')

  addStyleBadInput : =>
    @input_box.addClass('bad-input')

  removeStyleBadInput : =>
    @input_box.removeClass('bad-input')

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
    return if @_checkInput
    @_checkInput = true
    check = Feel.checker.check
    checkMinMax = Feel.checker.checkMinMax
    checkDigits = Feel.checker.checkDigits
    validators = @getValidators()
    val = @input.val()
    return @_checkInput = false if val == @val
    @val = val
    @checkFilters()
    @setValue @val unless val == @val
    val = @val
    if (val? && val != '') && validators?
      res = []
      for idx in @getObjectNumIndexes(validators)
        curValidator = validators[idx]
        patt = curValidator.pattern
        if patt?
          min = curValidator.min
          max = curValidator.max
          isBadInput = !(check patt, val)
          ## Extra check if exist min and max ##
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
    @emit 'change',@val
    @_checkInput = false
  setValue: (value)=>
    #@checkInput()
    return if value == @val
    @val = value
    @checkFilters()
    @input.val(value)
    @checkInput()

  getValue: =>
    @checkInput()
    return @val
    #@found.box.children('input').val()

  checkFilters : =>
    val = @val
    if @tree.filters?
      for i,filter of @tree.filters
        val = @['filter_'+filter](val)
    #if val != @val
    @val = val
      #@setValue val
  setFocus: =>
    @input.focus()
    @input.select()
  clearField: =>
    @input.val('')

  filter_digits : (val)-> ""+1*(""+val).replace /[^\d]/mg,''
  filter_number : (val)-> ""+1*(""+val).replace /[^\d\.]/mg,''
###
