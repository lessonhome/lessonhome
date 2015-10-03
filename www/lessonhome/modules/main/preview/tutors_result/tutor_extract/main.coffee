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
    #@tutor_price        = @found.tutor_price

  show: =>
    @hopacity ?= @dom.find('.g-hopacity')
    #@hideExtraText() # hide text that is larger than the maximum length and show full text by click
    @found.choose_button.click @addTutor
  addTutor : => Q.spawn =>
    linked = yield Feel.urlData.get 'mainFilter','linked'
    if linked[@tree.value.index]?
      delete linked[@tree.value.index]
#      feel.sendActionOnce('button')
    else
      linked[@tree.value.index] = true
    @setLinked linked
    yield Feel.urlData.set 'mainFilter','linked',linked
  setLinked : (linked)=> Q.spawn =>
    linked ?= yield Feel.urlData.get 'mainFilter','linked'
    if linked[@tree.value.index]?
      @tree.choose_button?.class?.setValue {text:'Убрать',color:'#3ab27d',pressed:true}
      @tree.choose_button?.class?.setActiveCheckbox()
      @hopacity.removeClass 'g-hopacity'
    else
      @tree.choose_button?.class?.setValue {text:'Выбрать'}
      @tree.choose_button?.class?.setDeactiveCheckbox()
      @hopacity.addClass 'g-hopacity'

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
    @setLinked()
    value = @tree.value
    #@with_verification.css 'background-color', value.with_verification if value?.with_verification?
    @tree.all_rating.class.setValue rating:value?.rating
    @tutor_name.text("#{value.name.last ? ""} #{value.name.first ? ""} #{value.name.middle ? ""}")
    @tutor_subject?.empty?()
    i = 0
    if @tutor_subject?.append? then for key,val of value.subjects
      i++
      if key
        key = key?.capitalizeFirstLetter?() ? key if i == 1
        skey = key
#        if i > 1
#          skey += ','
        @tutor_subject?.append? s=$("<div class='tag'></div>").text(skey ? "")
        do (s,key,val)=>
          s.click => Q.spawn =>
            link = '/tutor_profile?'+yield Feel.udata.d2u('tutorProfile',{index:@tree.value.index,subject:(key ? '').toLocaleLowerCase(),inset:1})
            #@found.link_name.attr 'href',link
            #@tree.view_button.class.activate link
            yield Feel.go link


        #do (s,key,val)=>
          #s.on 'mouseenter',=>
            #@tutor_text.text val.description if val?.description
            #s.on 'mouseleave', =>
              #s.off 'mouseleave'
              #@tutor_text.text value.about ? ""
    #@tutor_subject. text(value.tutor_subject) if value?.tutor_subject?
    #@tutor_status.  text(value.status ? "")
    #@tutor_exp.     text(value.experience ? "")

    exp = value.experience ? ""
    exp += " года" if exp && !exp?.match? /\s/
    @tutor_status.text "#{status[value?.status] ? 'Репетитор'}, опыт #{exp}"
    l = value?.location ? {}
    cA = (str="",val,rep=', ')->
      return str unless val
      val = ""+val
      val = val.replace /^\s+/,''
      val = val.replace /\s+$/,''
      return str unless val
      unless str
        str += val
      else
        str += rep+val

    ls1 = ""
    ls1 = cA ls1,l.city
#    ls1 = cA ls1,l.area
    ls2 = ""
    ls2 = cA ls2,l.street
    ls2 = cA ls2,l.house
    ls2 = cA ls2,l.building
    ls3 = ""
    ls3 += "м. #{l.metro}" if l.metro
    ls = ""
#    ls = cA ls,ls2,'<br>'
    ls = cA ls,ls3,'<br><br>'
    ls = cA ls,ls1,'<br>'
    @found.location.html(ls)
    #@tutor_title.   text(value.tutor_title) if value?.tutor_title?
    tutor_text = value.about || ''
    if (tutor_text.length > 210) && @tree.reclame
      tutor_text = tutor_text.substr 0,199
      tutor_text = tutor_text.replace /\s+[^\s]*$/gim,''
      tutor_text += '...'
      @tutor_text.text tutor_text
      @tutor_text.append $("<a class='about_link'>подробнее</a>")
    else
      @tutor_text.text tutor_text
    #@found.price_left.text(value.price_left)
    #@found.price_right.text(value.price_right)
    #@found.duration_left.text(value.duration_left)
    #@found.duration_right.text(value.duration_right)
    @found.price?.text?(value.price_per_hour)#Math.floor((Math.min(value.price_left,value.price_per_hour,value.price_right) ? 900)/10)*10)
    #@hideExtraText()
    do => Q.spawn =>
      link = '/tutor_profile?'+yield Feel.udata.d2u('tutorProfile',{index:@tree.value.index})
      @found.link_name.attr 'href',link
      @tree.view_button.class.activate link
      @dom.find('.about_link').attr 'href',link
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

