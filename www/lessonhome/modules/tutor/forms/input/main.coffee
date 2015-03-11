###
API:
  pattern : <regexp> #required
  min : <minimum_if_pattern_is_digits> #optional
  max : <maximum_if_pattern_is_digits> #optional
  errMessage : <message_about_error> #optional
  allowSymbolsPattern : <chars allowed for input> #optional
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
  }
Example:
  pattern     : '^\d{1,2}$' #required using some like: (dataObject 'checker').patterns.digits
  min         : 0
  max         : 24
  errMessage  : 'Укажите кол-во часов в диапазоне от 0 до 24
###

class @main extends EE
  constructor : ->
  show : =>
    #@box = @dom.find ".box"
    @box = @found.box
    @input = @box.children "input"

    @input.on 'focus', => @box.addClass 'focus'
    @input.on 'focusout', => @box.removeClass 'focus'

    @defaultBoxStyle = {
      'border-color': @box.css('border-color')
    }
    ############## Share ###############
    getObjectNumIndexes = (obj) ->
      Object.keys(obj).filter (key) ->
        !(isNaN Number(key))
    ####################################

    addStyleBadInput = ($box) =>
      #@box.addClass('bad-input')
      $box.css 'border-color', 'red'

    removeStyleBadInput = ($elt) =>
      #@box.removeClass('bad-input')
      $elt.css @defaultBoxStyle

    check = Feel.checker.check
    checkMinMax = Feel.checker.checkMinMax
    checkDigits = Feel.checker.checkDigits
    # Note!
    #If module instance saved into 'first_name' property then pattern maybe finded by this path:
    #Feel.root.tree.content.popup.content.first_name.pattern
    getValidators = =>
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

    maybeOutputErrMessage = (errMessage) ->
      if errMessage? then console.log errMessage

    #Check allowed input chars
    @input.on 'keypress', (event)=>
      allowPatt = getValidators().allowSymbolsPattern
      if !allowPatt?
        return true
      else return (new RegExp(allowPatt).test String.fromCharCode(event.keyCode))

    @input.on 'change', (event)=>
      validators = getValidators()
      val = @input.val()
      if (val? && val != '') && validators?
        res = []
        for idx in getObjectNumIndexes(validators)
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
        if (res.length > 0) && (res.length == getObjectNumIndexes(validators).length)
          #@box.addClass('bad-input')
          addStyleBadInput @box
          if validators.errMessage?
            maybeOutputErrMessage validators.errMessage
          else
            maybeOutputErrMessage res[0].errMessage
        else
          #@box.removeClass('bad-input')
          removeStyleBadInput @box
      else
        #@box.removeClass('bad-input')
        removeStyleBadInput @box
      #################
      @emit 'change'

  setValue: (value)=>
    @input.val(value)

  getValue: ()=>
    @input.val()
