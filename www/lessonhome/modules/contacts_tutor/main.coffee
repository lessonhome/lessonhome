

class @main
  Dom : =>
    @out_err = @found.out_err

  show : =>
    @mobile_phone = @tree.mobile_phone.class
    @extra_phone  = @tree.extra_phone.class
    @post         = @tree.post.class
    @skype        = @tree.skype.class
    @site         = @tree.site.class
    @country      = @tree.country.class
    @city = @tree.city.class

    #TODO: move it's code in drop_down_list.coffee
    @country.input.on 'focus', => @clearOutErr
    @city.input.on    'focus', => @clearOutErr



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
    if !@country.exists() @
      errs.push 'bad_country'
    if !@city.exists()
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


  outErr : (err) =>
    @out_err.show()
    @out_err.text err


  clearOutErr : (err) =>
    @out_err.hide()
    @out_err.text('')





