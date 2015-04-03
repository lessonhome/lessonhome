class @main
  Dom : =>
    @out_err = @found.out_err

  show : =>
    @mobile_phone = @tree.mobile_phone.class
    @mobile_phone.input.on 'focusout',@check_form

    @extra_phone = @tree.extra_phone.class
    @extra_phone.input.on 'focusout',@check_form

    @post = @tree.post.class
    @post.input.on 'focusout',@check_form

    @skype = @tree.skype.class
    @skype.input.on 'focusout',@check_form

    @site = @tree.site.class
    @site.input.on 'focusout',@check_form

    @country = @tree.country.class
    @country.input.on 'focusout',@check_form
    @country.input.on 'focus',@clearOutErrDate

    @city = @tree.city.class
    @city.input.on 'focusout',@check_form
    @city.input.on 'focus',@clearOutErrDate



  save : => Q().then =>
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

  check_form : =>
    errs = @js.check @getData()
    if !@country.suitability()
      errs.push 'bad_country'
    if !@city.suitability()
      errs.push 'bad_city'
    for e in errs
      @parseError e
    return errs.length==0


  getData : =>
    mobile_phone  : @mobile_phone.getValue()
    extra_phone   : @extra_phone.getValue()
    post          : @post.getValue()
    skype         : @skype.getValue()
    site          : @site.getValue()
    country       : @country.getValue()
    city          : @city.getValue()


  parseError : (err)=>
    switch err
      when "wrong_mobile"
        @mobile_phone.showError "Неккоректный телефон"
      when "wrong_extra_phone"
        @extra_phone.showError "Неккоректный доп. телефон"
      when "wrong_post"
        @post.showError "Некорректный email"
      when "wrong_skype"
        @skype.showError "Только английские буквы"
      when "wrong_site"
        @site.showError "Неверный формат названия"
      when "bad_country"
        @outErrDate "Введите правильную страну"
      when "bad_city"
        @outErrDate "Введите правильный город"


  outErrDate : (err) =>
    @out_err.show()
    @out_err.text err


  clearOutErrDate : (err) =>
    @out_err.hide()
    @out_err.text('')