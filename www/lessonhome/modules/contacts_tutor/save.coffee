

class @main
  Dom : =>
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





  save : => Q().then =>
    if @check_form()
      console.log @getData()
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
    for e in errs
      @parseError e
    return errs.length==0
  getData : =>
    mobile_phone  : @mobile_phone.getValue()
    extra_phone   : @extra_phone.getValue()
    post          : @post.getValue()
    skype         : @skype.getValue()
    site          : @site.getValue()
  parseError : (err)=>
    switch err
      when "wrong_mobile"
        @mobile_phone.outErr "Неккоректный телефон"
      when "wrong_extra_phone"
        @extra_phone.outErr "Неккоректный доп. телефон"
      when "wrong_post"
        @post.outErr "Некорректный email"
      when "wrong_skype"
        @skype.outErr "Только английские буквы"
      when "wrong_site"
        @site.outErr "Неверный формат названия"
