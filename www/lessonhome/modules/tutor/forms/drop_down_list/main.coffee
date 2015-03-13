class @main extends EE
  show : =>
    beginMatchCssClass = 'custom-option__begin-match'
    @label = @dom.find "label"
    @list = @label.find ".drop_down_list"
    @input = @list.find "input"


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
          (new RegExp('^'+sBegin, 'i')).test str
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

        ### Getting current select elect with options (using pattern Decorator) ###
        getCurSel = ->
          $input = getCurInput();
          ### Create select with options for input (if there are no) ###
          if !($sel = $input.data 'select')?
            $sel = $('<div class="custom-select"></div>')
            startConfigSelect $sel
            $input.after $sel
            $input.data 'select', $sel
          $sel

        getIconBox = ->
          getCurInput().siblings('.icon_box')

        ### Configuring select after creating ###
        startConfigSelect = ($sel) ->
          $sel.attr
            'multiple': true
            'class': 'select-sets__options'
          $sel.css
            display: 'none'
            position: 'absolute'
            width: getCurInput().css('width')

        ### Correct select after show ###
        configSelect = ($sel) ->

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

        findSelected = ($sel) ->
          #$sel.find(':selected')
          $sel.find('[selected="selected"]')

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
          if $sel.data 'was-enter'
            $sel.data 'was-enter', false
            return
          switch event.keyCode
            when unit.arrowDown
              nextSelected $sel
              ###
              if $sel.is(':visible')
                $sel.focus();
                startSelection $sel[0]
              ###
            when unit.arrowUp
              prevSelected $sel
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

        getCurSel().on 'click', (event) ->
          selectedOptionToInput()

        getCurSel().keydown (event) ->
          $sel = $(this)
          sel = $(this)[0]
          selLen = options($sel).length;
          ###
          when unit.arrowDown
            nextSelected $sel

          when unit.arrowUp
            prevSelected $sel
          ###
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
          getIconBox().click (event) ->
            if getCurSel().is(':visible')
              getCurSel().hide()
            else
              showSelectOptions()
          getCurInput().focus()
        #########################################

        showSelectOptions = () ->
          $sel = getCurSel()
          strBegin = getCurInput().val()
          correctSelectOptions strBegin, $sel, valuesGenerator
          bindHandlers $sel

        startSelection = (sel) ->
          $sel = $(sel)
          if optionsCount($sel) == 1
            makeSelected($sel, 0)
          else
            makeSelected($sel, 1)

        correctSelectOptions = (strBegin, $sel, fnValuesGenerator) ->
          configSelect(getCurSel())
          fillOptions $sel, (fnValuesGenerator strBegin), strBegin
          if optionsCount($sel) > 0
            makeSelected($sel, 0)
            $sel.show()
          return

        markBeginText = (str, startStr)->
          startLen = startStr.length
          startStr = str.substr(0, startLen)
          endStr = str.substr(startLen)
          "<span class='#{beginMatchCssClass}''>#{startStr}</span>#{endStr}"

        fillOptions = (sel, options, sBegin) ->
          html = ''
          options.forEach (optVal) ->
            optValText = markBeginText(optVal.text, sBegin)
            html += "<div class='custom-option' value='#{optVal.value}'>#{optValText}</div>"
            return
          $(sel).html html
          return

        selectedOptionToInput = () ->
          $sel = getCurSel()
          $option = findSelected($sel)
          $input = getCurInput()
          $input.val $option.text()
          $sel.hide()
          $sel.data 'was-enter', true
          $input.focus()
          return
  focusInput: =>
    @input.focus()
