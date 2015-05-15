class @main extends EE
  Dom: =>
    @tutor_name         = @found.tutor_name
    @with_verification  = @found.with_verification
    @tutor_subject      = @found.tutor_subject
    @tutor_status       = @found.tutor_status
    @tutor_exp          = @found.tutor_exp
    @tutor_place        = @found.tutor_place
    @tutor_title        = @found.tutor_title
    @tutor_text         = @found.tutor_text
    @tutor_price        = @found.tutor_price


  show: =>
    @hideExtraText() # hide text that is larger than the maximum length and show full text by click
  hideExtraText: =>
    max_length = 147
    block = @tutor_text
    str   = @tree.value.tutor_text
    str_length = str.length
    if str_length > max_length
      visible_text = str.substring(0, max_length)
      block.html(visible_text)
      block.append('<div class="visible_text">...подробнее</div>')
      block.find(".visible_text").one 'click', => block.html(str)



  setValue : (value) =>
    @tree.value[key] = val for key,val of value
    @with_verification.css 'background-color', value.with_verification if value?.with_verification?
    @tutor_name.    text(value.tutor_name) if value?.tutor_name?
    @tutor_subject. text(value.tutor_subject) if value?.tutor_subject?
    @tutor_status.  text(value.tutor_status) if value?.tutor_status?
    @tutor_exp.     text(value.tutor_exp) if value?.tutor_exp?
    @tutor_place.   text(value.tutor_place) if value?.tutor_place?
    @tutor_title.   text(value.tutor_title) if value?.tutor_title?
    @tutor_text.    text(value.tutor_text) if value?.tutor_text?
    @tutor_price.   text(value.tutor_price) if value?.tutor_price?

  getValue : => @getData()

  getData : =>
    return {
      tutor_name        : @tree.value.tutor_name
      with_verification : @with_verification.css 'background-color'
      tutor_subject     : @tree.value.tutor_subject
      tutor_status      : @tree.value.tutor_status
      tutor_place       : @tree.value.tutor_place
      tutor_title       : @tree.value.tutor_title
      tutor_text        : @tree.value.tutor_text
      tutor_price       : @tree.value.tutor_price
    }


