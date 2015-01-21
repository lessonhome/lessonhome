class @main extends EE
  constructor : ->
  show : =>
    @details_block = @dom.find ".details_block"
    @details_block.first().css("display", "block")