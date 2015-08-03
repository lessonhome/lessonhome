class @main extends EE
  constructor : ->
    @unit =
      enterCode : 13
      tabCode   : 9
      arrowDown : 40
      arrowUp   : 38
      esc       : 27
    @_list = {}


  setItems : (items)=>
    return unless items?.length>=0
    @tree.items = items
    @tree.default_options = {}
    i = 0
    for key,item of @tree.items
      @tree.default_options[i++] = {
        value : ''+item
        text  : ''+item
      }
    @_list = {}
    for key,opt of @tree.default_options
      @_list[opt.text]= true
    leng = Object.keys(@tree?.default_options ? {}).length
    @list_length = leng
    unless (@list_length > 0) && (!@tree.self)
      @found.icon_box.hide()
    else
      @found.icon_box.show()
  Dom : =>
    @tree.sorting = @tree.sort if @tree.sort?
    @tree.smart     ?= false
    if @tree.smart
      @tree.filter ?= true
      @tree.sorting ?= true
    @tree.sorting   ?= false
    @tree.filter    ?= false
    @tree.self      ?= false
    @closed = true
    if @tree.items?
      @tree.default_options = {}
      i = 0
      for key,item of @tree.items
        @tree.default_options[i++] = {
          value : ''+item
          text  : ''+item
        }
    @tree.default_options ?= {}
    for key,opt of @tree.default_options
      @_list[opt.text]= true
    leng = Object.keys(@tree?.default_options ? {}).length
    @list_length = leng
    unless (@list_length > 0) && (!@tree.self)
      @found.icon_box.hide()
    else
      @found.icon_box.show()
      
    @label        = @dom.find ">label"
    @list         = @found.drop_down_list
    @input        = @found.input
    @icon_box     = @found.icon_box
    @select_sets  = @found.select_sets
    @options      = @found.options
    @items        = @options.find '>div'
    @input.on 'click',=>
      if @closed
        @showSelectOptions()
  closeList : =>
    $('body').off 'mousedown.drop_down_list'
    $('body').off 'mouseleave.drop_down_list'
    @emitChange()

    @bodyListenMD = false
    @label.removeClass 'focus'
    @select_sets.hide()
    @closed = true
    @emit 'blur'
    @emit 'focusout'
  emitChange : =>
    @lastChange ?= ""
    val = @getValue()
    return if val == @lastChange
    @lastChange = val
    if (!@tree.self) && (@list_length > 0)
      return unless @exists()
    console.log 'change'
    @emit 'change',val
  onBlur : =>
    if (!@tree.self) && (@list_length > 0)
      return unless @exists()
    @emit 'end', @getValue()

  show : =>
    @maxListHeight = @list.height()*5

    @scroll = @tree.scroll?.class
    @isFocus = false
    @on 'blur',@onBlur
    @input.on 'focus', =>
      return if @isFocus
      @isFocus = true
      @label.addClass 'focus'
      @showSelectOptions?()
      @emit 'focus'
    @input.on 'focus', @hideError
    @input.on 'focusout', =>
      return if !@isFocus
      @isFocus = false
      if !@bodyListenMD
        @bodyListenMD = true
        Feel.popupAdd @dom[0],@closeList
        ###
        f = (t)=>
          return if $.contains @dom[0],t.target
          @closeList()
        $('body').on 'mousedown.drop_down_list', f
        $('body').on 'mouseleave.drop_down_list', @closeList
        ###

    if @tree.default_options?
      do =>
        ### Default data for filtration (using into valuesGenerator) ###
        ###
        @tree.default_options =
          {
           '0': {value: 'math', text: 'математика'},
           '1': {value: 'algebra', text: 'алгебра'},
           '2': {value: 'arithmetic', text: 'арифметика'},
           '3': {value: 'anatomy', text: 'анатомия'}
          }
        ###

        ### Getting current select elect with options (using pattern Decorator) ###

        valuesGenerator = (sBegin)=>
          arr = []
          arr2 = []
          leng = Object.keys(@tree?.default_options ? {}).length
          @list_length = leng
          for key,opt of @tree.default_options
            if (leng > 5) && (@tree.filter) && (sBegin)
              if @tree.smart
                d = @getDistance(opt.text, sBegin)
                o = {d,opt}
                if 0<=d<=0.33
                  arr.push o if o?
                else
                  arr2.push o if o?
              else
                if opt.text?.indexOf?(sBegin) == 0
                  arr.push {0,opt}
                else
                  arr2.push {0,opt}
            else
              arr.push {0,opt}
          #if arr.length < 5
          #  arr = [arr...,arr2.slice(0)]
          #  #break if sBegin.length > 2 && arr.length > 5
          #  #break if arr.length > 10
          if @tree.sort
            arr = arr.sort (a,b)=> Math.abs(a.d)-Math.abs(b.d)
            arr2 = arr2.sort (a,b)=> Math.abs(a.d)-Math.abs(b.d)
          if arr.length < 5
            arr = [arr...,arr2.slice(0,(5-arr.length))...]
          return [] unless arr.length
          ret = []
          for it in arr
            ret.push it.opt
          return ret

        ############## CustomSelect component ###############
        optionsCount = ($sel) => @items.size()

        options = ($sel) => @items

        optionIndex = ($opt)=>
          @items.index $opt


        makeSelected = (idx) =>
          @items.removeClass 'selected'
          idx = @items.size()-1 if idx>= @items.size()
          if idx>=0
            $opt = @items.eq idx
            $opt.addClass 'selected'
            bottom = @options.height()-$opt.position().top-$opt.height()
            top    = $opt.position().top
            if bottom<0
              @options.scrollTop @options.scrollTop()-bottom
            if top<0
              @options.scrollTop @options.scrollTop()+top
          else
            @input.val ''

        selectedIndex = ($sel) =>
          $opt = @items.filter('.selected')
          if $opt.length
            @items.index($opt)
          else -1

        prevSelected = =>
          curIdx = selectedIndex @options
          @items.removeClass 'selected'
          makeSelected curIdx-1

        nextSelected = =>
          curIdx = selectedIndex @options
          @items.removeClass 'selected'
          makeSelected curIdx+1
        #########################################

        ### Event handling #####################################
        @input.on 'input', @emitChange
        @input.keyup (event) =>
          if @select_sets.data 'was-enter'
            @select_sets.data 'was-enter', false
          #  return
          switch event.keyCode
            when @unit.arrowDown
              event.preventDefault()
            when @unit.arrowUp
              event.preventDefault()
            when @unit.esc
              @select_sets.hide()
            when @unit.enterCode
              @select_sets.hide()
            else
              #if !(@select_sets.is(':visible'))
              showSelectOptions()
              return

        @input.on 'keydown', (event) =>
          switch event.keyCode
            when @unit.arrowDown
              event.preventDefault()
              if @closed
                @showSelectOptions()
              nextSelected @options
              selectedOptionToInput(false)
            when @unit.arrowUp
              event.preventDefault()
              if @closed
                @showSelectOptions()
              prevSelected @options
              selectedOptionToInput(false)
            when @unit.enterCode
              @emit 'press_enter'
              selectedOptionToInput(if @tree.self then 'self' else undefined)
            when @unit.tabCode
              if @select_sets.is(':visible')
                event.preventDefault()
                nextSelected @options if @exists()
                selectedOptionToInput(false)
              #if @select_sets.is(':visible')
              #  if event.shiftKey
              #    prevSelected @options
              #  else nextSelected @options
              #  event.preventDefault()


        @options.keydown (event) =>
          switch event.keyCode
            when @unit.enterCode
              selectedOptionToInput(if @tree.self then 'self' else undefined)
            when @unit.esc
              $(this).hide()
          return

        bindHandlers = ($sel) =>
          @items.on 'mouseenter', (event)->
            makeSelected optionIndex $(this)
          that = this
          @items.on 'click', (event)->
            event.preventDefault()
            makeSelected optionIndex $(this)
            that.select_sets.data 'was-click', true
            selectedOptionToInput()
            return false

        @icon_box?.click? (event) =>
          if @select_sets.is(':visible')
            hideSelect()
          else
            showSelectOptions()

        ### Hiding on click out of label (drop_down_list component) ###
        $('body').on 'click.drop_down_list', (event)=>
          if $(event.target).closest(@label).size() == 0
            hideSelect()
        #########################################
        hideSelect = =>
          @select_sets.hide()
          @label.removeClass 'open_select'
          @closed = true
        @showSelectOptions = showSelectOptions = =>
          @label.addClass 'open_select'
          strBegin = @input.val()
          correctSelectOptions strBegin, @options, valuesGenerator
          bindHandlers @options
          optHeight = @items.height()
          @select_sets.height(optHeight * @tree.options_count)
          @scroll?.reinit?()


        startSelection = (sel) =>
          $sel = $(sel)
          if @items.size() == 1
            makeSelected 0
          else
            makeSelected 1

        correctSelectOptions = (strBegin, $selOpts, fnValuesGenerator) =>
          fillOptions $selOpts, (fnValuesGenerator strBegin), strBegin
          if @items.size() > 0
            makeSelected 0
            @select_sets.show()
            @closed = false
            lh = @list.height()*@items.size()
            @items.css 'line-height', @list.height()+"px"
            h = @maxListHeight
            h = lh if lh < h
            @options.height h
          else hideSelect()
          return

        markBeginText = (str, startStr)=>
          startLen = startStr.length
          startStr = str.substr(0, startLen)
          endStr = str.substr(startLen)
          "<span class='begin'>#{startStr}</span>#{endStr}"

        fillOptions = ($selOpts, options, sBegin) =>
          html = ''
          options.forEach (optVal) ->
            optValText = markBeginText(optVal.text, "")
            html += "<div class='custom-option' value='#{optVal.value}'>#{optValText}</div>"
            return
          @options.empty()
          @items = $ html
          @options.append @items
          return
        selectedOptionToInput = (hide=true,...,self=false)=>
          unless typeof hide == 'boolean'
            hide = true
          if (@list_length > 0) && (self != 'self')
            $option = @items.filter('.selected')
            @input.val $option.text()
          if hide
            @select_sets.hide()
            @select_sets.data 'was-enter', true
            @input.focus()
            @closeList()
          return
  ####### FUNCTIONS #############
  focusInput: =>
    @input.focus()

  getDistance : (from,to)=>
    Feel.diff.match from,to



  exists : => @_list[@getValue()]?

  err_effect       : => @label.addClass 'err_effect'
  clean_err_effect : => @label.remove 'err_effect'


  ########

  setValue : (val)=>
    unless typeof @tree.default == 'string'
      @tree.default = ""
    unless typeof val == 'string'
      val = @tree.default
    @tree.value =  val
    @val = val
    @input.val val
    @emitChange()

  getValue : => @input.val()

  showError : (error)=>
    if @errorDiv?
      @errorDiv.text error
      @errorDiv.show()
    @label.addClass 'err_effect'
  hideError : =>
    if @errorDiv?
      @errorDiv.hide()
      @errorDiv.text ""
    @label.removeClass 'err_effect'
  setErrorDiv : (div)=>
    @errorDiv = $ div

