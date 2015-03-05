class @main extends EE
  show : =>
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
            $sel = $('<select></select>')
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
            str.text.startsWith sBegin

        ### Event handling #####################################
        getCurInput().keyup (event) ->
          $sel = getCurSel()
          if $sel.data 'was-enter'
            $sel.data 'was-enter', false
            return
          switch event.keyCode
            when unit.arrowDown
              if $sel.is(':visible')
                $sel.focus();
                startSelection $sel[0]
            when unit.esc
              $sel.hide()
            else
              showSelectOptions event
              return

        getCurSel().keydown (event) ->
          sel = $(this)[0]
          selLen = sel.options.length;
          switch event.keyCode
            when unit.arrowDown
              newSelectedIndex = (sel.selectedIndex + 1) % selLen
              fn = ->
                setCurrentOption($(sel), newSelectedIndex)
              setTimeout fn, 0

            when unit.arrowUp
              newSelectedIndex = ((sel.selectedIndex - 1) + selLen) % selLen
              setCurrentOption($(sel), newSelectedIndex)


            when unit.enterCode
              $(this).data 'was-enter', true
              selectedOptionToInput()

            when unit.esc
              $(this).hide()
          return

        getCurSel().click (event) ->
          selectedOptionToInput()

        if getIconBox()?
          getIconBox().click (event) ->
            if getCurSel().is(':visible')
              getCurSel().hide()
            else
              showSelectOptions event
          getCurInput().focus()
        #########################################

        showSelectOptions = (event) ->
          correctSelectOptions event, getCurSel(), valuesGenerator

        setCurrentOption = ($sel, idx) ->
          chSelected = ->
            $sel[0].options.selectedIndex = idx
          setTimeout chSelected, 0

        startSelection = (sel) ->
          if sel.options.length == 1
            sel.selectedIndex = 0;
          else
            sel.selectedIndex = 1

        correctSelectOptions = (event, $sel, fnValuesGenerator) ->
          configSelect(getCurSel())
          strBegin = getCurInput().val()
          fillOptions $sel, (fnValuesGenerator strBegin)
          if $sel[0].options.length > 0
            $sel[0].selectedIndex = 0
            $sel.show()
          return

        fillOptions = (sel, options) ->
          html = ''
          options.forEach (optVal) ->
            html += "<option value='#{optVal.value}'>#{optVal.text}</option>"
            return
          $(sel).html html
          return

        selectedOptionToInput = () ->
          $sel = getCurSel()
          $option = $sel.find(':selected')
          $input = getCurInput()
          $input.val $option.text()
          $sel.hide()
          $input.focus()
          return

