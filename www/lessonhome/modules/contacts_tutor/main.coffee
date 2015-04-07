

class @main
  Dom : =>
    @err_country = @found.err_country
    @err_city = @found.err_city

  show : =>
    @mobile_phone = @tree.mobile_phone.class
    @extra_phone  = @tree.extra_phone.class
    @post         = @tree.post.class
    @skype        = @tree.skype.class
    @site         = @tree.site.class
    @country      = @tree.country.class
    @city         = @tree.city.class

    #TODO: move it's code in drop_down_list.coffee
    @country.input.on 'focus', => @clearOutErr @err_country, @country
    @city.input.on    'focus', => @clearOutErr @err_city, @city



  save : => Q().then =>
    console.log 'Call Save'
    if @check_form()
      console.log 'aaaaaaa'
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          console.log 'save_true'
          return true
        if errs?.length
          @parseError errs
        return false
    else
      console.log 'bbbbbb'
      return false

  check_form : =>

    errs = @js.check @getData()
    if !@country.exists() && @country.getValue().length!=0
      errs.push 'bad_country'
    if !@city.exists() && @city.getValue().length!=0
      errs.push 'bad_city'

    for e_ in errs
      @parseError e_
    console.log errs,1

    return errs.length==0


  getData : =>
    return {
      mobile_phone: @mobile_phone.getValue()
      extra_phone: @extra_phone.getValue()
      post: @post.getValue()
      skype: @skype.getValue()
      site: @site.getValue()
      country: @country.getValue()
      city: @city.getValue()
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
      when "bad_site"
        @site.showError "Неверный формат названия"
      when "bad_country"
        @outErr "Введите правильную страну"
      when "bad_city"
        @outErr "Введите правильный город"
      #empty
      when "empty_mobile"
        @mobile_phone.showError "Введите телефон"
      when "empty_extra_phone"
        @extra_phone.showError "Введите доп. телефон"
      when "empty_post"
        @post.showError "Введите email"
      when "empty_skype"
        @skype.showError "Введите скайп"
      when "empty_site"
        @site.showError "Введите сайт"
      when "empty_country"
        @outErr "Выберите страну"
      when "empty_city"
        @outErr "Выберите город"



  outErr : (err, err_el, el) =>
    el.err_effect()
    err_el.text err
    setTimeout =>
      err_el.show()
    , 100


  clearOutErr : (err_el ,el) =>
    el.clean_err_effect()
    err_el.addClass 'hide'
    err_el.text('')





