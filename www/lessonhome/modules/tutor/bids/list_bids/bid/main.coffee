class @main extends EE
  show : =>
    @details_block_show_control @dom

  change_visibility: (element)=>
    console.log element.css("display")
    if element.css("display") == "none"
      element.css("display", "block")
    else
      element.css("display", "none")

  details_block_show_control: (dom)=>
    basic_block = dom.find ".basic_block"
    details_block = dom.find ".details_block"

    basic_block.on 'click', => @change_visibility details_block