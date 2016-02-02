class @main extends EE
  show : =>
    @report_block_show_control @dom
    @details_block_show_control @dom

  change_visibility: (element)=>
    console.log element.css("display")
    if element.css("display") == "none"
      element.css("display", "block")
    else
      element.css("display", "none")

  report_block_show_control: (dom)=>
    basic_block = dom.find ".basic_block"
    report_block = dom.find ".report_block"

    basic_block.on 'click', => @change_visibility report_block

  details_block_show_control: (dom)=>
    details_block = dom.find ".details_block"
    details_block_background = dom.find ".details_block_background"
    details_block_header = details_block_background.find ".header"
    details_block_header.on 'click', =>
      @change_visibility details_block
      if details_block_background.hasClass("details_closed")
        details_block_background.removeClass("details_closed")
        details_block_background.addClass("details_open")
      else
        details_block_background.removeClass("details_open")
        details_block_background.addClass("details_closed")