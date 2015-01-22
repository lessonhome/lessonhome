class @main extends EE
  show : =>
    Feel.FirstBidBorderRadius(@dom)

    @details_block = @dom.find ".details_block"
    @details_block.first().css("display", "block")