class @main extends EE
  constructor : ->
  show : =>
    @box = @dom.find ".box"
    @input = @box.children "input"

    @input.on 'focus', => @box.addClass 'focus'
    @input.on 'focusout', => @box.removeClass 'focus'

    check = Feel.checker.check
    # Note!
    #If module instance saved into 'first_name' property then pattern maybe finded by this path:
    #Feel.root.tree.content.popup.content.first_name.pattern

    @input.on 'blur', (event)=>
      if @tree.pattern?
        if check @tree.pattern, @input.val()
          @input.removeClass('bad-input');
        else
          @input.addClass('bad-input');

  setValue: (value)=>
    @input.html(value)