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
    @val    = @input.val()
    @label  = @dom.find ">label"
    @tree.match   ?= {}
    @tree.replace ?= {}
    @tree.error_align     = 'left'
    if typeof @tree.match =='string'
      @tree.match = 0:@tree.match
    for key,val of @tree.match
      @tree.match[key] = new RegExp val
    @tree.replace = @parseRegexpObj @tree.replace
    @tree.patterns = @parseRegexpObj @tree.patterns
    @tree.replaceCursor = @parseRegexpObj @tree.replaceCursor,''
    @tree.selectOnFocus ?= true
    @hint         = @found.hint
    @hintMessage  = @found.hint_message
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
    @input.on 'blur',     @onBlur
    @input.on 'input',    @onInput
    @input.on 'keypress', @onKeyPress
    @input.on 'keydown',  @onKeyDown
    @input.on 'keyup',    @onKeyUp
    @input.on 'paste',    @onJQPaste
    @on 'submit',         @onSubmit
    @on 'change',         @onChange
    @on 'paste',          @onPaste
    @on 'end',            @onEnd
  focus : =>
    @input.focus()
  onJQPaste : =>
    setTimeout =>
      @emit 'paste'
    ,1
  onPaste   : =>
    @input.setCursorPosition @input.val().length
    @_emittedEnd = ""
    @emitEnd()
  onFocus : =>
    @emit 'focus'
    @label.addClass 'focus'
    @hint?.fadeIn?()  if @tree.hint?
    if @tree.selectOnFocus
      setTimeout =>
        @input.setSelection(0,@input.val().length)
      ,0
  onBlur    : =>
    @emit 'blur'
    @hint?.fadeOut?() if @tree.hint?
    @label.removeClass 'focus'
    console.log 'blur'
    @emitEnd()
  onChange : =>
    @_emittedEnd = ""
  onSubmit : =>
    @emitEnd()
  emitEnd   : =>
    return if @val == ""
    @_emittedEnd ?= ""
    return unless @doMatch()
    if @val != @_emittedEnd
      @_emittedEnd = @val
      @emit 'end',@val
  onEnd     : (val)=>
    console.log 'end',val
  onInput   : =>
    @replaceInput()
    setTimeout @checkChange,0
  onKeyDown : (e)=>
    @hideError()
    @_emittedEnd = ""
    switch e.keyCode
      when 13
        e.preventDefault()
        @emit 'submit',@input.val()
    setTimeout @checkChange,0
  ping : (alpha)=>
    @clearPing() if !alpha?
    return @clearPing() if alpha < 0.01
    alpha ?= 1.0
    @input.css 'box-shadow',"0 0 15px rgba(255,50,50,#{alpha})"
    @pingTimer = setTimeout (=>@ping alpha*0.9) ,33
  clearPing : =>
    clearTimeout @pingTimer if @pingTimer? && @pingTimer>0
    @input.css 'box-shadow','none'
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
      @ping()
      return e.preventDefault()
    else
      e.preventDefault()
      @replaceInput val,rstr,position,true
  doMatch : =>
    for key,val of @tree.patterns
      unless @val.match val[0]
        return @showError val[1]
    return true

  addPattern : (str,error="")=>
    if typeof str == 'string'
      str = new RegExp str,'mg'
    i = Object.keys(@tree.patterns).length
    @tree.patterns[i] = [str,error]
  addReplace : (reg,replace="")=>
    if typeof reg == 'string'
      reg = new RegExp reg,'mg'
    i = Object.keys(@tree.replace).length
    @tree.replace[i] = [reg,replace]
  addError : (name,text="")=>
    @tree.errors?= {}
    @tree.errors[name] = text
  showError : (error="",error_align=@tree.error_align)=>
    @clearPing()
    str = error
    if @tree.errors?[error]?
      str = @tree.errors[error]
    @emit 'error', error,str
    @found.text3.html str
    @found.level3.attr 'hide','false'
    @label.addClass 'error'
    console.log 'error',@val,str
    return false
  hideError : =>
    @label.removeClass 'error'
    @found.level3.attr 'hide','hide'
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
    if errMessage? then @showError errMessage
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
