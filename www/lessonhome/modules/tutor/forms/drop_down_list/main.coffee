class @main extends EE
  constructor : ->
    @unit =
      enterCode : 13
      tabCode   : 9
      arrowDown : 40
      arrowUp   : 38
      esc       : 27

  Dom : =>
    @label        = @dom.find ">label"
    @list         = @found.drop_down_list
    @input        = @found.input
    @icon_box     = @found.icon_box
    @select_sets  = @found.select_sets
    @options      = @found.options
    @items        = @options.find '>div'
  show : =>
    @scroll = @tree.scroll?.class
    @isFocus = false
    @input.on 'focus', =>
      return if @isFocus
      @isFocus = true
      @label.addClass 'focus'
      @showSelectOptions()

    @input.on 'focusout', =>
      return if !@isFocus
      @isFocus = false
      if !@bodyListenMD
        @bodyListenMD = true
        $('body').on 'mousedown.drop_down_list', (t)=>
          return if $.contains @dom[0],t.target
          $('body').off 'mousedown.drop_down_list'
          @bodyListenMD = false
          @label.removeClass 'focus'
          @select_sets.hide()

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
          for key,opt of @tree.default_options
            d = @getDistance(opt.text, sBegin)
            if 0<=d<=0.33
              o = {d,opt}
              arr.push o if o?
            break if sBegin.length > 2 && arr.length > 5
            break if arr.length > 10
          return [] unless arr.length
          for i in [0...arr.length-1]
            for j in [i+1...arr.length]
              if arr[i].d > arr[j].d
                k = arr[i]
                arr[i] = arr[j]
                arr[j] = k
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
        @input.keyup (event) =>
          if @select_sets.data 'was-enter'
            @select_sets.data 'was-enter', false
            return
          switch event.keyCode
            when @unit.arrowDown
              event.preventDefault()
            when @unit.arrowUp
              event.preventDefault()
            when @unit.esc
              @select_sets.hide()
            else
              #if !(@select_sets.is(':visible'))
              showSelectOptions()
              return

        @input.on 'keydown', (event) =>
          switch event.keyCode
            when @unit.arrowDown
              event.preventDefault()
              nextSelected @options
              selectedOptionToInput(false)
            when @unit.arrowUp
              event.preventDefault()
              prevSelected @options
              selectedOptionToInput(false)
            when @unit.enterCode
              selectedOptionToInput()
            when @unit.tabCode
              if @select_sets.is(':visible')
                if event.shiftKey
                  prevSelected @options
                else nextSelected @options
                event.preventDefault()


        @options.keydown (event) =>
          switch event.keyCode
            when @unit.enterCode
              selectedOptionToInput()
            when @unit.esc
              $(this).hide()
          return

        bindHandlers = ($sel) =>
          @items.on 'mouseenter', (event)->
            makeSelected optionIndex $(this)
          that = this
          @items.on 'click', (event)->
            makeSelected optionIndex $(this)
            that.select_sets.data 'was-click', true
            selectedOptionToInput()

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
            @items.css 'line-height', @list.height()+"px"
          return

        markBeginText = (str, startStr)=>
          startLen = startStr.length
          startStr = str.substr(0, startLen)
          endStr = str.substr(startLen)
          "<span class='begin'>#{startStr}</span>#{endStr}"

        fillOptions = ($selOpts, options, sBegin) =>
          html = ''
          options.forEach (optVal) ->
            optValText = markBeginText(optVal.text, sBegin)
            html += "<div class='custom-option' value='#{optVal.value}'>#{optValText}</div>"
            return
          @options.empty()
          @items = $ html
          @options.append @items
          return
        selectedOptionToInput = (hide=true)=>
          $option = @items.filter('.selected')
          @input.val $option.text()
          if hide
            @select_sets.hide()
            @select_sets.data 'was-enter', true
            @input.focus()
          return
  ####### FUNCTIONS #############
  focusInput: =>
    @input.focus()
  getDistance : (from,to)=>
    Feel.diff.match from,to


