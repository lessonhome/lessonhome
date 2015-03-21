class @main extends EE
  show : =>
    beginMatchCssClass = 'custom-option__begin-match'
    @label = @dom.find "label"
    @list = @label.find ".drop_down_list"
    @input = @list.find "input"

    @scrollReinit = @tree.scroll?.class.reinit
    #console.log @tree.scroll?.class.tree.test

    @input.on 'focus', =>
      if @label.is '.filter_top'
        @list.addClass 'filter_top_focus'
      else
        @list.addClass 'focus'

    @input.on 'focusout', =>
      if @label.is '.filter_top'
        @list.removeClass 'filter_top_focus'
      else
        @list.removeClass 'focus'

    curInput = @input
    if @tree.default_options?
      do (curInput) =>

        ### Share ###
        unit =
          enterCode: 13
          tabCode: 9
          arrowDown: 40
          arrowUp: 38
          esc: 27

        startsWith = (str, sBegin)->
          res = true
          i = 0
          len = sBegin.length
          if str.length < len
            res = false
          else
            while i < sBegin.length
              if str[i].toLocaleUpperCase() != sBegin[i].toLocaleUpperCase()
                res = false
                break
              i++
          res
        #############

        ### Default data for filtration (using into valuesGenerator) ###
        ###
        data =
          {
           '0': {value: 'math', text: 'математика'},
           '1': {value: 'algebra', text: 'алгебра'},
           '2': {value: 'arithmetic', text: 'арифметика'},
           '3': {value: 'anatomy', text: 'анатомия'}
          }
        ###
        data = @tree.default_options

        getCurInput = ->
          #$('.select-sets_input')
          curInput

        #required refactor
        findOptionsContent = ($dom)->
          $dom.find('.options')

        ### Getting current select elect with options (using pattern Decorator) ###
        findSelectSets = ($dom)->
          $dom.find('.select-sets__options')

        getCurSel = =>
          (findSelectSets @dom)

        getCurSelOptions = =>
          $input = getCurInput();
          ### Create select with options for input (if there are no) ###
          if !($sel = $input.data 'select')?
            $sel = findOptionsContent(findSelectSets @dom)
            $input.data 'select', $sel
          $sel

        getIconBox = ->
          getCurInput().siblings('.icon_box')

        valuesGenerator = (sBegin) ->
          dataAr = []
          for key, val of data
            dataAr.push val
          dataAr.filter (str) ->
            startsWith str.text, sBegin

        ############## CustomSelect component ###############
        optionsCount = ($sel) ->
          $sel.find('.custom-option').size()

        options = ($sel) ->
          $sel.find('.custom-option')

        optionIndex = ($sel, $opt) ->
          (options $sel).index $opt

        markSelected = ($opt) =>
          $opt.addClass('custom-option__selected')

        markUnselected = ($opt) =>
          $opt.removeClass('custom-option__selected')

        makeUnselected = ($sel, idx) ->
          $opt = options($sel).eq(idx)
          $opt.removeAttr 'selected'
          markUnselected $opt

        makeUnselectedCurrent = ($sel) ->
          makeUnselected $sel, selectedIndex($sel)

        makeSelected = ($sel, idx) ->
          makeUnselectedCurrent $sel
          $opt = options($sel).eq(idx)
          $opt.attr 'selected','selected'
          markSelected $opt

        findSelected = ($selOpts) ->
          #$sel.find(':selected')
          $selOpts.find('[selected="selected"]')

        findOptionsByOpt = ($opt) ->
          $opt.parent()

        selectedIndex = ($sel) ->
          $opt = findSelected($sel)
          options($sel).index($opt)

        setCurrentOption = ($sel, idx) ->
          chSelected = ->
            makeSelected $sel, idx
          setTimeout chSelected, 0

        prevSelectedIndex = ($sel, idx) ->
          selLen = optionsCount($sel)
          newSelectedIndex = ((idx - 1) + selLen) % selLen

        nextSelectedIndex = ($sel, idx) ->
          selLen = optionsCount($sel)
          newSelectedIndex = (idx + 1) % selLen

        prevSelected = ($sel) ->
          curIdx = selectedIndex($sel)
          makeUnselected $sel, curIdx
          setCurrentOption $sel, prevSelectedIndex($sel, curIdx)

        nextSelected = ($sel) ->
          curIdx = selectedIndex($sel)
          makeUnselected $sel, curIdx
          setCurrentOption $sel, nextSelectedIndex($sel, curIdx)
        #########################################

        ### Event handling #####################################
        getCurInput().keyup (event) ->
          $sel = getCurSel()
          $selOpts = getCurSelOptions()
          if $sel.data 'was-enter'
            $sel.data 'was-enter', false
            return
          switch event.keyCode
            when unit.arrowDown
              nextSelected $selOpts
            when unit.arrowUp
              prevSelected $selOpts
            when unit.esc
              $sel.hide()
            else
              if $(this).val() != ''
                showSelectOptions()
              else $sel.hide()
              return

        getCurInput().on 'keydown', (event) ->
          switch event.keyCode
            when unit.enterCode
              selectedOptionToInput()

        getCurSelOptions().on 'click', (event) ->
          $sel = getCurSel()
          $sel.data 'was-click', true
          selectedOptionToInput()

        getCurSelOptions().keydown (event) ->
          switch event.keyCode
            when unit.enterCode
              selectedOptionToInput()
            when unit.esc
              $(this).hide()
          return

        bindHandlers = ($sel) ->
          $opts = options($sel)
          $opts.on 'mouseenter', (event) ->
            $opt = $(this)
            $sel = findOptionsByOpt($opt)
            makeSelected $sel, (optionIndex $sel, $opt)

        if getIconBox()?
          getIconBox().click (event) =>
            if getCurSel().is(':visible')
              getCurSel().hide()
            else
              showSelectOptions()

        ### Hiding on click out of label (drop_down_list component) ###
        $('body').on 'click.drop_down_list', (event)=>
          if $(event.target).closest(@label).size() == 0
            getCurSel().hide()
        #########################################

        showSelectOptions = () =>
          $selOpts = getCurSelOptions()
          strBegin = getCurInput().val()
          correctSelectOptions strBegin, $selOpts, valuesGenerator
          bindHandlers $selOpts
          @scrollReinit?()

        startSelection = (sel) ->
          $sel = $(sel)
          if optionsCount($sel) == 1
            makeSelected($sel, 0)
          else
            makeSelected($sel, 1)

        correctSelectOptions = (strBegin, $selOpts, fnValuesGenerator) ->
          fillOptions $selOpts, (fnValuesGenerator strBegin), strBegin
          if optionsCount($selOpts) > 0
            makeSelected($selOpts, 0)
            getCurSel().show()
          return

        markBeginText = (str, startStr)->
          startLen = startStr.length
          startStr = str.substr(0, startLen)
          endStr = str.substr(startLen)
          "<span class='#{beginMatchCssClass}''>#{startStr}</span>#{endStr}"

        fillOptions = ($selOpts, options, sBegin) ->
          html = ''
          options.forEach (optVal) ->
            optValText = markBeginText(optVal.text, sBegin)
            html += "<div class='custom-option' value='#{optVal.value}'>#{optValText}</div>"
            return
          $selOpts.html html
          return

        selectedOptionToInput = () ->
          $sel = getCurSel()
          $option = findSelected(getCurSelOptions())
          $input = getCurInput()
          $input.val $option.text()
          $sel.hide()
          $sel.data 'was-enter', true
          $input.focus()
          return
  focusInput: =>
    @input.focus()
