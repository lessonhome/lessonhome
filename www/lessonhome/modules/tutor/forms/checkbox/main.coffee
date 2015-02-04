class @main extends EE
  show : =>
    @dom.on 'click', => @checkbox_click @dom

  checkbox_click: (dom)=>
    checkbox = dom.find("div")
    if checkbox.hasClass('active')
      checkbox.removeClass('active')
    else
      checkbox.addClass('active')


