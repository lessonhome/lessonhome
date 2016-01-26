
class @main
  Dom : =>
    @out_err_country  = @found.out_err_country
    @out_err_city     = @found.out_err_city
    @link_more        = @found.link_more
    @address_box    = $ @dom.find '>div>.address_box'
    @link_popup       = $('a').hasClass('link_more')

  show : =>
    @mobile_phone = @tree.mobile_phone.class
    @extra_phone  = @tree.extra_phone.class
    @post         = @tree.post.class
    @skype        = @tree.skype.class
    # drop_down_list
    @country      = @tree.country.class
    @city         = @tree.city.class

    # clear error
    @country.input.on 'focus',  => @country.hideError()
    @city.input.on    'focus',  => @city.hideError()

    # error div
    @country.setErrorDiv @out_err_country
    @city.setErrorDiv @out_err_city


    # link more address
    @link_more.on 'click', (e)=> Q.spawn =>
      e.preventDefault()
      ok = yield @save(true)
      Feel.go @link_more.attr 'href' if ok

    # click outside popup element
    if @found.href_back?
      @found.href_back?.attr? 'href', Feel.getBack @tree.href_back
      console.log @found.href_back
    @dom.find('>.background').on 'click', @check_place_click


  check_place_click :(e) =>
    if (!@address_box.is(e.target) && @address_box.has(e.target).length == 0)
      Feel.goBack  @tree.href_back


  save : (quiet=false)=> do Q.async =>
    return false unless quiet || @check_form()
    {status,errs} = yield @$send('./save',@getData(),quiet)
    if status=='success'
      return true
    @showError errs
    return false

  check_form :() =>
    errs = @js.check @getData()
    @showError errs
    return errs.length==0

  showError : (errs) =>
    errs = [errs] if typeof(errs) is 'string'

    if errs?.length
      Feel.sendAction 'error_on_page'
      for e in errs
        @parseError e

  getData : =>
    return {
      mobile_phone  : @mobile_phone.getValue()
      extra_phone   : @extra_phone.getValue()
      post          : @post.getValue()
      skype         : @skype.getValue()
      country       : @country.getValue()
      city          : @city.getValue()
    }

  parseError : (err)=>
    switch err
      #short
      when "bad_mobile"
        @mobile_phone.showError "Неккоректный телефон"
      when "bad_extra_phone"
        @extra_phone.showError "Неккоректный доп. телефон"
      when "bad_post"
        @post.showError "Некорректный email"
      when "bad_skype"
        @skype.showError "Неккоректный скайп"
      when "bad_country"
        @country.showError "Введите правильную страну"
      when "bad_city"
        @city.showError "Введите правильный город"
      when "empty_mobile"
        @mobile_phone.showError "Введите телефон"
      when "empty_extra_phone"
        @extra_phone.showError "Введите доп. телефон"
      when "empty_post"
        @post.showError "Введите email"
      when "empty_skype"
        @skype.showError "Введите скайп"
      when "empty_country"
        @country.showError "Выберите страну"
      when "empty_city"
        @city.showError "Выберите город"





