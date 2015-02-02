class @main extends EE
  show : =>
    @dom.on 'click', => @checkbox_click @dom

  checkbox_click: (dom)=>
    checkbox = dom.find("div").first()
    check = dom.find(".check")


    if checkbox.hasClass("edit_settings") then @change_check_activities check, "edit_settings_active"
    if checkbox.hasClass("bid") then  @change_check_activities check, 'bid_active'
    if checkbox.hasClass("check_in") then  @change_check_activities check, 'check_in_active'
    if checkbox.hasClass("bid_form") then  @change_check_activities check, 'bid_form_active'

  change_check_activities: (check, selector)=>
    if check.hasClass(selector)
      check.removeClass(selector)
    else check.addClass(selector)

