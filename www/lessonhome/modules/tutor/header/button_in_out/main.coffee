class @main extends EE
  show : =>
    @click_box = @dom.find ".click_box"
    @popup_box = @dom.find ".popup_box"
    @.close_box = @dom.find ".close_box"
    @click_box.on 'click', => @change_visibility(@popup_box)
    @close_box.on 'click', => @change_visibility(@popup_box)


  change_visibility : (element)=>
    if element.css('display') == 'none'
      element.css('display', 'block' )
    else
      element.css('display', 'none' )
