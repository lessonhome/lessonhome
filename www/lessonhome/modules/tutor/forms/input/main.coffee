###
API:
  pattern : <regexp>
  min : <minimum_if_pattern_is_digits>
  max : <maximum_if_pattern_is_digits>.
  errMessage : <message_about_error>
Example:
  pattern     : '^\d{1,2}$' #required using some like: (dataObject 'checker').patterns.digits
  min         : 0
  max         : 24
  errMessage  : 'Укажите кол-во часов в диапазоне от 0 до 24
###

class @main extends EE
  constructor : ->
  show : =>
    @box = @dom.find ".box"
    @input = @box.children "input"

    @input.on 'focus', => @box.addClass 'focus'
    @input.on 'focusout', => @box.removeClass 'focus'

    check = Feel.checker.check
    checkMinMax = Feel.checker.checkMinMax
    checkDigits = Feel.checker.checkDigits
    # Note!
    #If module instance saved into 'first_name' property then pattern maybe finded by this path:
    #Feel.root.tree.content.popup.content.first_name.pattern

    @input.on 'blur', (event)=>
      val = @input.val()
      min = @tree.min
      max = @tree.max
      patt = @tree.pattern
      if patt?
        isBadInput = !(check patt, val)
        if (checkDigits val) && (min? || max?)
          isBadInput = !(checkMinMax min, val, max)

        if isBadInput
          @input.addClass('bad-input')
          console.log @tree.errMessage
        else
          @input.removeClass('bad-input')

  setValue: (value)=>
    @input.html(value)
