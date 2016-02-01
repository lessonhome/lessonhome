class @main extends EE
  Dom : =>
    @input  = @found.input
    @input  ?= @dom.find 'input'
    @val    = @input.val()
    @label  = @dom.find ">label"
    @labelCommon = @found.text1
    @tree.match   ?= {}
    @tree.replace ?= {}
    @tree.error_align     = 'left'
    if typeof @tree.match =='string'
      @tree.match = 0:@tree.match
    for key,val of @tree.match
      @tree.match[key] = new RegExp val
#    @tree.saveReplace ?= @tree.replace
#    @tree.replace = @tree.saveReplacee
    @replace = @parseRegexpObj @tree.replace
    @patterns = @parseRegexpObj @tree.patterns
    @replaceCursor = @parseRegexpObj @tree.replaceCursor,''
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
    return
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
  saveValue : (val) =>
    if (value = if val then val else @getValue()) isnt ''
      @input.attr 'data-value', value
  getSaved : =>
    @input.attr 'data-value'
  onInput   : =>
    @replaceInput?()
    setTimeout @checkChange,0
  onKeyDown : (e)=>
    @hideError()
    @_emittedEnd = ""
    switch e.keyCode
      when 13
        e.preventDefault()
        @emit 'submit',@input.val()
    setTimeout @checkChange,0
  clearPing : =>
    clearTimeout @pingTimer if @pingTimer? && @pingTimer>0
    @input.css 'box-shadow','none'
  onKeyPress : (e)=>
    return if e?.ctrlKey || e?.altKey
    try position = @input.getCursorPosition()

    val = @input.val()
    _char = ""
    if e.charCode? && e.charCode
      _char = String.fromCharCode(e.charCode)
    else if e.key? && e.key && e.key.length == 1
      _char = e.key
    try
      start = @input.getSelectionStart()
      end = @input.getSelectionEnd()
      unless start? || end?
        start = val.length
        end = val.length
      str = val.substr(0,start)+_char+val.substr(end)
    catch e
      console.error e
      str = val+_char
    rstr = @matchReplace str
    if rstr == str
      return
    else if val == rstr
      @showError 'Недопустимые символы'
      return e.preventDefault()
    else
      e.preventDefault()
      @replaceInput val,rstr,position,true
  doMatch : =>
    for key,val of @patterns
      unless @val.match val[0]
        return @showError val[1]
    return true

  addPattern : (str,error="")=>
    if typeof str == 'string'
      str = new RegExp str,'mg'
    i = Object.keys(@patterns).length
    @patterns[i] = [str,error]
  addReplace : (reg,replace="")=>
    if typeof reg == 'string'
      reg = new RegExp reg,'mg'
    i = Object.keys(@replace).length
    @replace[i] = [reg,replace]
  addError : (name,text="")=>
    @tree.errors?= {}
    @tree.errors[name] = text
  showError : (error)=>
    @labelCommon.attr 'data-error', error if error?
    @input.addClass('invalid')
    return false
  hideError : =>
     @input.removeClass('invalid')
  matchReplace : (rstr)=>
    for key,v of @replace
      nv = rstr?.replace? v[0],v[1]
      rstr = nv
    return rstr
  replaceInput : (val,rstr,position,forceCursor=false)=>
    val     ?= @input.val()
    rstr    ?= @matchReplace val
    position?= @input.getCursorPosition()
    return if @input.val()==rstr
    @input.val rstr
    rc = false
    if forceCursor then for key,v of @replaceCursor
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
