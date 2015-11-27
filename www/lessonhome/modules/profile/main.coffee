
class templ
  constructor : (jQ) ->
    that = @
    @template = jQ.clone()
    @fields = {}

    @elems = @template.find('[data-val]').each ->
      el = $(@)
      that.fields[el.data('val')] = el

  add : (where) ->
    where.append @template.clone().children()
    @elems.html ''

  use : (key, h) ->
    if @fields[key]?
      return @fields[key] unless h
      @fields[key].html(h)

  useh : (key, h) ->
    if @fields[key]?
      unless h
        @fields[key].hide()
      else @fields[key].show().html(h)


class @main
  constructor : ->
    $W @
  Dom : =>
    @status_values =
      student:"Студент"
      private_teacher:"Частный преподаватель"
      university_teacher:"Преподаватель ВУЗа"
      school_teacher:"Преподаватель школы"

    @chooseTutor  = @found.tutor_trigger
    @triggerCount = 0

    #scroll spy
    @reviewMark   = @found.review_mark
    @profileTab   = @found.profile_tab

    @template_subject = @tree.template_subject.class

    @message_text = @found.message_text
    @message_phone = @found.message_phone
    @message_name = @found.message_name
    @message_send = @found.message_send
    @message_sub = @found.message_subject

    @templ_sub = new templ @found.template_subjects
    @templ_educ = new templ @found.template_education
    @templ_short_place = new templ @found.template_short_places
    @templ_place = new templ @found.template_places
    @templ_review = new templ @found.template_reviews
  show: =>
    #scroll spy
    @reviewMark.scrollSpy()
    #tabs


#    @profileTab.tabs()

    @message_send.on 'click', @onSendMessage
    
    #@found.profile_tabs.tabs()
    @found.show_detail.on 'click', @onShowDetail
    @chooseTutor.on 'click', => Q.spawn => yield @onTutorChoose()
    Feel.urlData.on 'change',=> Q.spawn => yield @setLinked()
    @found.back.on 'click', (e)=>
      return unless e.button == 0
      e.preventDefault()
      Q.spawn => yield @goBack()
    yield @open()

  open : (index)=>
    state = History.getState()
    if (((""+document.referrer).indexOf(document.location.href.substr(0,15)))!=0)&&(window.history.length<2)
      @found.back.addClass 'hidden'
    else
      @found.back.removeClass 'hidden'

    unless index?
      @index = yield Feel.urlData.get('tutorProfile','index') ? 77
    else @index = index

    preps = yield Feel.dataM.getTutor [@index]
    prep = preps[@index]
    return unless prep?
    console.log prep
    @setValue prep
    yield @setLinked()
  goBack : =>
    if @tree.single_profile!='tutor_profile'
      return yield Feel.main.hideTutor()
    if (window.history.length>1) && History.back()
      setInterval (=> Q.spawn => yield @goHistoryUrl()),2000
      return yield @goHistoryUrl()
    document.location.href = document.referrer
  goHistoryUrl : => setTimeout (-> document.location.href = History.getState().url),100

  onSendMessage : =>
    console.log data = @getData()
    console.log @save(data)



  onShowDetail : (e) =>
    btn = $(e.currentTarget)
    if @found.short_prices.is ':visible'
      @found.short_prices.fadeOut 200,
        =>
          @found.detail_prices.fadeIn(200)
          btn.text('Скрыть')
    else
      @found.detail_prices.fadeOut 200,
        =>
          @found.short_prices.fadeIn(200)
          btn.text('Подробнее')
    return true

  onTutorChoose : =>
    active  = !@found.tutor_trigger.hasClass('selected')
    @tutorChoose      active
    yield @setLinked  active,false
  setLinked : (active,choose = true)=>
    return unless @index
    linked = yield Feel.urlData.get 'mainFilter','linked','reload'
    state = active ? linked?[@index]==true
    if active?
      unless state
        delete linked?[@index]
      else
        linked?[@index] = true
      yield Feel.urlData.set 'mainFilter','linked',linked
    @tutorChoose state==true if choose
  tutorChoose : (active)=>
    console.log 'tutorchoose',active
    if active
      @found.tutor_trigger.addClass('waves-light teal lighten-2 selected white-text').removeClass('btn-trigger waves-teal')
      @found.tutor_trigger.find('.tutor_button_text').html('Убрать')
      @found.tutor_trigger.find('.material-icons').html('remove')
    else
      @found.tutor_trigger.removeClass('waves-light teal lighten-2 selected white-text').addClass('btn-trigger waves-teal')
      @found.tutor_trigger.find('.tutor_button_text').html('Выбрать')
      @found.tutor_trigger.find('.material-icons').html('add')

  loadedImage : (photo_parent, litle, hight) =>
    photo_parent.addClass 'loaded-image materialboxed'
    photo_parent.materialbox()
    l_img = photo_parent.find('img:first').attr('src', litle)
    if hight
      h_img = l_img.clone().css({
        display: 'none'
        opacity: 0
        position: 'absolute'
        left: 0
        top: 0
      }).appendTo(photo_parent)

      photo_parent.one 'click', ->
        h_img.attr('src', hight).load ->
          h_img.css('display', '').animate {opacity: 1}, ->
            l_img.remove()
            h_img.css({position: 'static'})

  setPhotos : (photos)=>
    avatar = photos[photos.length-1]
    @loadedImage @found.view_photo.html('<img>'), avatar.lurl, avatar.hurl




  setRating : (rating)=>

  dativeName : (data)->
    name = _nameLib.get((data?.last ? ''),(data?.first ? ''),(data?.middle ? ''))
    return {
      first : name.firstName('dative')
      middle: name.middleName('dative')
      last  : name.lastName('dative')
    }

  setNewFormatPrice : (data) ->
    return unless data.subjects?

    places = []
    subject = data.subjects[ Object.keys(data.subjects)[0] ]

    for k in ['tutor', 'pupil', 'remote']
      return if subject.place_prices[k]?
      places.push(k) if data.place?[k]

    return unless places.length

    roundFifty = (val) ->
      val /= 50
      val = Math.round(val)
      val *= 50
      return val

    p1 = subject.price.left
    p2 = subject.price.right
    t1 = subject.duration.left
    t2 = subject.duration.right
    delta_t = t2 - t1

    if delta_t != 0 then k = (p2 - p1)/delta_t else k = 14
    if (k > 200 || k < 4) then k = 14

    new_price =
      v60 : roundFifty( k*(60 - t1)  + p1 )
      v90 : roundFifty( k*(90 - t1)  + p1 )
      v120 : roundFifty( k*(120 - t1) + p1 )

    delete new_price['v60'] if new_price['v60'] < 400

    subject.place_prices[k] = new_price for k in places

  setValue : (data={})=>

    @profileTab.find('.indicator')

    yield @setNewFormatPrice data
    @tree.value ?= {}
    @tree.value[key] = val for key,val of data
    data = @tree.value
    @name = "#{data.name.first || ""} #{data.name.middle || ''}"

    @setPhotos data.photos
#    yield @setRating data.rating

    @found.full_name.text("#{@name}")
    if data.age? && data.age
      age_end = data.age%10
      switch age_end
        when 1
          @found.age_value.text(", "+data.age+" год")
        when 2
          @found.age_value.text(", "+data.age+" года")
        when 3
          @found.age_value.text(", "+data.age+" года")
        when 4
          @found.age_value.text(", "+data.age+" года")
        else
          @found.age_value.text(", "+data.age+" лет")
    else
      @found.age_value.text("")

    l = data?.location ? {}

    trim = (val) -> val.replace(/^\s+/,'').replace(/\s+$/,'')

    cA = (str="",val,rep=', ')->
      return str unless val
      val = ""+val
      trim val
      return str unless val
      unless str
        str += val
      else
        str += rep+val

    ls1 = ""
    ls1 = cA ls1,l.city
    ls1 = cA ls1,l.area
    if l.metro
      stations = l.metro.split(',').map (station) -> "м. #{trim station}"
      ls1 = cA ls1, stations.join(', ')

    ls = ""
    ls = cA ls,ls1

    @found.location.text ls

    if Feel.user?.type?.admin
      @found.location.prepend('<br>').prepend $('<b>').text('login : ' +  data.login)
      @found.location.prepend('<br>').prepend $('<b>').text('phone : ' +  data.phone)
      @found.location.prepend('<br>').prepend $('<b>').text('email : ' + data.email)

    ###
    if data.location?.country
      if data.location?.city
        if data.location?.area
          @found.location.text("#{data.location?.country ? ""}, г.#{data.location?.city ? ""} р.#{data.location?.area ? ""}")
        else
          @found.location.text("#{data.location?.country ? ""}, г.#{data.location?.city ? ""}")
      else
        @found.location.text(data.location?.country ? "")
    else
      @found.location.hide()
    ###
    @setLinked()
    @found.slogan.hide()
    if data.slogan? && data.slogan
      @found.slogan.show().text data.slogan


    @found.location_places.html ''
    @found.short_places.html ''
    @found.block_places.hide()

    if data.place?
      for place, title of {tutor: 'У себя', pupil : 'Выезд', remote : 'Skype'}
        if data.place[place]?
          @templ_short_place.use 'place', title
          @templ_short_place.add @found.short_places

          location = ''

          switch place
            when 'tutor' then location = ls
            when 'pupil' then location =  data.check_out_the_areas?.join(', ')


          if location
            @found.block_places.show()
            @templ_place.use 'place', title
            @templ_place.use 'location', location
            @templ_place.add @found.location_places


    @found.status.hide()
    if data.status? and @status_values[data.status]?
      @found.status.show().text @status_values[data.status]


#    if data.experience? && data.experience
#      @found.experience.show().text data.experience
#    else
#      @found.experience.hide()

    @found.short_prices.html ''
    @found.detail_prices.hide().html ''
    @found.subjects.html ''
    @found.show_detail.text('Подробнее')

    @found.select_subject.hide()
    dative_tutor_name = @dativeName data.name
    @found.dative_name.text(dative_tutor_name.first)

    @found.block_prices.hide()
    @found.block_subjects.hide()


    if data.subjects? and data.ordered_subj?.length

      subjects = data.ordered_subj
      if subjects.length == 1 and (enumer = subjects[0].split(',')).length > 1
        subjects = enumer.map trim

      for sub, i in subjects then @message_sub.append $("<option>").text(sub).attr('value', sub)

      if i > 1
        @message_sub.material_select()
        @found.select_subject.show()


      @found.block_prices.show()

      subArr = []
      subArr.push(data.subjects[name].place_prices) for name in data.ordered_subj
      @found.short_prices.append @template_subject.getShort(subArr)

      for title, i in data.ordered_subj
        @found.detail_prices.append $('<li>').append(@template_subject.getOne(subArr[i], title))


      @found.block_subjects.show()

      for name, value of data.subjects

        @templ_sub.use 'name', name
        @templ_sub.useh 'direct', value.course?.join(', ')
        @templ_sub.useh 'descr', value.description
        @templ_sub.add @found.subjects


    @found.education.html('')
    @found.block_education.hide()


    if data.education? && data.education.length
      @found.block_education.show()
      for val in data.education
        @templ_educ.use 'title', val.name
        @templ_educ.useh 'city', if val.city then "г. #{val.city}"

        start = val.period?.start
        end = val.period?.end

        start = /\d{4}/.exec(start)[0] if start
        end = /\d{4}/.exec(end)[0] if end

        start = (unless end then 'c ' else '') + start if start
        end = (if start then ' - ' else 'до ') + end if end

        @templ_educ.useh 'period', "#{start} #{end} г." if start or end
        @templ_educ.useh 'info', "#{val.faculty}#{if val.qualification then ', ' + val.qualification}"
        @templ_educ.useh 'about', val.comment
        @templ_educ.add @found.education

    @found.about_me.hide()
    @found.why.hide()
    @found.interests.hide()

    if data.about then @found.about_me.show().text(data.about)
    if data.reason then @found.why.show().find('.text').text(data.reason)
    if data.interests? and data.interests.length and data.interests[0].description
      @found.interests.show().find('.text').text(data.interests[0].description)


    @found.reviews.html ''
    @found.documents.html ''
    @found.review_mark.hide()

    if data.reviews?.length or data.media?.length
      @found.review_mark.show()
      if data.reviews?.length
        for review in data.reviews
          @templ_review.use 'mark', review.mark
          @templ_review.useh 'course', review.course?.join(', ')
          @templ_review.useh 'subject', review.subject?.join(', ')
          @templ_review.use 'name', review.name
          @templ_review.use 'review', review.review
          @templ_review.use 'date', review.date
          @templ_review.add @found.reviews
      else
        @found.reviews.html '<p>Отзывов о данном репетиторе пока нет.</p>'
        @found.tab_doc.trigger('click')

      if data.media?.length
        exist = {}
        regexp = /^\/file\/(\w+)\//
        for photo in data.media
          hash = regexp.exec(photo.lurl, true)[1]
          unless exist[hash]
            exist[hash] = true
            wrap = $('<div><img></div>')
            @found.documents.append $('<div class="list">').append(wrap)
            @loadedImage wrap, photo.lurl, photo.hurl
      else
        @found.documents.html '<p>Данный репетитор пока не выкладывал фотографий.</p>'
        @found.tab_review.trigger('click')

  save : (data) => do Q.async =>
    return false unless @check_form(data)
    {status,errs} = yield @$send('../main/attached/save', data)
    if status=='success'
      Feel.sendActionOnce 'direct_bid'
      return true
    return false

  check_form : (data) =>
    errs = @js.check data
    for e in errs
      @parseError e
    return errs.length==0

  parseError : (err)=>
    switch err
#      when "short_name"
#        @message_name.showError "Слишком короткое имя "
      when "short_phone", "empty_phone"
        @message_phone.removeClass('valid').addClass 'invalid'
#      when "empty_name"
#        @message_name.showError "Введите имя"
#      when "empty_subject"
#        @message_sub.showError "Выберите предмет"

  hide : =>
    @chooseTutor.off 'click'
    @found.back.off 'click'

  getData : =>
    return {
      id:             @index
      comments:       @message_text.val()
      name:           @message_name.val()
      phone:          @message_phone.val()
      subject:        @message_sub.val()
    }