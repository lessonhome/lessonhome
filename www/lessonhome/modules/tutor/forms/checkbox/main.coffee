class @main extends EE
  show : =>
    @dom.on 'click', => @checkbox_click @dom

  checkbox_click: (dom)=>
    check = dom.find(".check")
    if check.hasClass('active')
      check.removeClass('active')
    else
      check.addClass('active')


