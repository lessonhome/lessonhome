
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
    @link_more.on 'click', (e)=>
      e.preventDefault()
      @save().then (ok)=>
        Feel.go @link_more.attr 'href' if ok

    # click outside popup element
    @dom.find('>.background').on 'click',  @check_place_click


  check_place_click :(e) =>
    if (!@address_box.is(e.target) && @address_box.has(e.target).length == 0)
      Feel.go '/tutor/profile/second_step'
      # @link_popup.href('/tutor/profile/second_step')



  save :() => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          return true
        if errs?.length
          @parseError errs
        return false
    else
      return false

  check_form :() =>
    errs = @js.check @getData()
    #if link
    #  if !@mobile_phone.doMatch() then errs.push "bad_mobile"
    #if !@country.exists() && @country.getValue().length!=0
    #  errs.push 'bad_country'
    #if !@city.exists() && @city.getValue().length!=0
    #  errs.push 'bad_city'
    for e in errs
      @parseError e
    return errs.length==0


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
      #empty
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





