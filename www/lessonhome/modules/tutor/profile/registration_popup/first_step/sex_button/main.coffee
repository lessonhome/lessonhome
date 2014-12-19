

class @main
  constructor : ->
    @clickArray = []

  Dom : =>

    @button = @dom.find '.button'
    @button.click =>
      @button.addClass 'active'
      for foo in @clickArray
        foo @tree.selector

    console.log @button

  disable : =>
    @button.removeClass 'active'
  enable : =>
    @button.addClass 'active'
  onClick : (foo)=>
    @clickArray.push foo
