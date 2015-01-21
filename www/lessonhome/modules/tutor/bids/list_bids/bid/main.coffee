class @main extends EE
  constructor : ->
  show : =>
    @basic_block = @dom.find ".basic_block"
    @details_block = @dom.find ".details_block"

    @basic_block.on 'click', @onclick
  onclick : =>
    @change_visibility @details_block

  change_visibility: (element)=>
    console.log element.css("display")
    if element.css("display") == "none"
      element.css("display", "block")
    else
      element.css("display", "none")
    return 1
