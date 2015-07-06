status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'



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
    str   = @tree.value?.about ? ""
    str_length = str.length
    if str_length > max_length
      visible_text = str.substring(0, max_length)
      block.html(visible_text)
      block.append('<div class="visible_text">...подробнее</div>')
      block.find(".visible_text").one 'click', => block.text(@tree.value.about ? "")



  setValue : (value) =>
    @tree.value[key] = val for key,val of value
    value = @tree.value
    #@with_verification.css 'background-color', value.with_verification if value?.with_verification?
    @tutor_name.text("#{value.name.last ? ""} #{value.name.first ? ""} #{value.name.middle ? ""}")
    @tutor_subject.empty()
    for key,val of value.subjects
      @tutor_subject.append $("<div class='tag'>#{key}</div>") if key
    #@tutor_subject. text(value.tutor_subject) if value?.tutor_subject?
    #@tutor_status.  text(value.status ? "")
    #@tutor_exp.     text(value.experience ? "")
    exp = value.experience
    exp += " года" unless exp.match /\s/
    @tutor_status.text "#{status[value?.status] ? 'Репетитор'}, опыт #{exp}"
    @found.location.text(value.location?.city ? "")
    #@tutor_title.   text(value.tutor_title) if value?.tutor_title?
    @tutor_text.    text(value.about ? "")
    @found.price.text(Math.floor((value.price_per_hour ? 900)/10)*10)
    @hideExtraText()
  getValue : => @getData()

  getData : => @tree.value
  ###
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
  ###

