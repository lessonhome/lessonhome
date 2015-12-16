
class templ
  constructor : (jQ) ->
    @elems = null
    @current = null
    @fields = null
    @frag = $(document.createDocumentFragment())
    @template = jQ
    @_parse()

  _parse : ->
    that = @
    @fields = {}
    @current = @template.clone()
    @elems = @current.find('[data-val]').each ->
      el = $(this)
      that.fields[el.data('val')] = el

  add : ->
    @frag.append @current.children()
    @_parse()

  push : (where) ->
    where.append @frag
    @frag = $(document.createDocumentFragment())

  use : (key, h) ->
    if @fields[key]?
      return @fields[key] unless h
      @fields[key].text(h)

  useh : (key, h) ->
    if @fields[key]?
      unless h
        @fields[key].hide()
      else @fields[key].show().text(h)


class @main
  constructor : ->
    $W @
  Dom : =>

    @chooseTutor  = @found.tutor_trigger
    @triggerCount = 0
    @resolution = true


    #scroll spy
    @reviewMark   = @found.review_mark
    @profileTab   = @found.profile_tab

    @message_text = @found.message_text
    @message_phone = @found.message_phone
    @message_name = @found.message_name
    @message_send = @found.message_send
    @message_sub = @found.message_subject

    @templ = new templ @found.template_subject
    @templ_sub = new templ @found.template_sub
    @templ_pr = new templ @found.template_price
    @templ_educ = new templ @found.template_education
    @templ_short_place = new templ @found.template_short_places
    @templ_place = new templ @found.template_places
    @templ_review = new templ @found.template_reviews
  show: =>
    #scroll spy
    @reviewMark.scrollSpy()
    #tabs

#    @profileTab.find('.indicator').remove()



    @message_send.on 'click', @onSendMessage

    @found.show_detail.on 'click', @onShowDetail
    @chooseTutor.on 'click', => Q.spawn => yield @onTutorChoose()
    Feel.urlData.on 'change',=> Q.spawn => yield @setLinked()

    @found.back.on 'click', (e)=>
      return unless e.button == 0
      e.preventDefault()
      Q.spawn => yield @goBack()

    yield @open()

    @message_sub.find('select').material_select()

    @profileTab.addClass('tabs').tabs()
    if exist = @profileTab.data('exist') then @profileTab.tabs('select_tab', exist)
    $('.loaded').each @loadImage


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

  loadImage : (i, elem) =>
    photo_parent = $(elem).addClass 'materialboxed'

    photo_parent.removeClass 'initialized'
    photo_parent.materialbox()
    l_img = photo_parent.find('img:first')
    src_h = l_img.attr('data-src')
    if src_h
      h_img = l_img.clone().css({
        display: 'none'
        opacity: 0
        position: 'absolute'
        left: 0
        top: 0
      }).attr('data-src', '')

      photo_parent.one 'click', ->
        photo_parent.append h_img
        h_img.attr('src', src_h).load ->
          h_img.css('display', '').animate {opacity: 1}, ->
            l_img.remove()
            h_img.css({position: 'static'})


  setAvatar : (avatar)=>
    @found.avatar.attr {
      "src" : avatar.lurl
      "data-src" : avatar.hurl
    }

  setRating : (rating)=>


  addPrice : (prices, parent) =>
    for price in prices
      if price.name then @templ_pr.use 'title', price.name else @templ_pr.use('title').parent().hide()
      if typeof price.prices == 'string'
        @templ_pr.use 'plus', price.prices
        @templ_pr.use('table').remove()
      else
        body = @templ_pr.use('table').find('tbody')
        for _p in price.prices
          body.append "<tr><td>#{_p[0]}</td><td>#{_p[1]}</td></tr>"
      @templ_pr.add()
    @templ_pr.push parent.html('')
#  setValue : =>
  setValue : (value)=>
    #value = @js.parse data

    @setAvatar(value.src_avatar)

    if value.full_name then @found.full_name.text value.full_name
    if value.age       then @found.age_value.show().text(', ' + value.age)          else @found.age_value.hide()
    if value.slogan    then @found.slogan.show().text(value.slogan)                 else @found.slogan.hide()
    if value.location  then @found.location.text(value.location).parent().show()    else @found.location.parent().hide()
    if value.status    then @found.status.text(value.status).closest('.row').show() else @found.status.closest('.row').hide()

    @found.select_subject.hide()
    @found.short_places.closest('.row').hide()
    @found.block_prices.hide()
    @found.block_subjects.hide()
    @found.block_places.hide()
    @found.block_education.hide()
    @found.block_about.hide()
    @found.review_mark.hide()

    if value.dative_name? then @found.dative_name.text(value.dative_name)
    @message_sub.html('')
    if value.sub?
      select = $('<select>')
      for s in value.sub
        select.append "<option value='#{s}'>#{s}</option>"
      @message_sub.append select
    if value.sub.length > 1 then @found.select_subject.show()

    if value.places?.length

      for place in value.places
        #####
        @templ_short_place.use 'place', place.place
        @templ_short_place.add()
        ######
        if value.show_places and place.location
          @templ_place.use 'place', place.place
          @templ_place.useh 'location', place.location
          @templ_place.add()

      @templ_short_place.push @found.short_places.html('')
      @found.short_places.closest('.row').show()

      if value.show_places
        @templ_place.push @found.location_places.html('')
        @found.block_places.show()

    if value.short_price?.length and value.subjects?.length

      @addPrice value.short_price, @found.short_prices

      @found.short_prices.show()

      for sub in value.subjects
        #####
        @templ.use 'title', sub.name
        @addPrice(sub.prices, @templ.use('body') )
        @templ.add()
        #####
        @templ_sub.use 'name', sub.name
        @templ_sub.useh 'direct', sub.course
        @templ_sub.useh 'descr', sub.description
        @templ_sub.add()
        #####

      @templ.push @found.detail_prices.html('')
      @templ_sub.push @found.subjects.html('')

      @found.block_prices.show()
      @found.block_subjects.show()

    if value.education?.length

      for e in value.education
        @templ_educ.use 'title', e.name
        @templ_educ.useh 'city', e.city
        @templ_educ.useh 'period', e.period
        @templ_educ.useh 'info', e.info
        @templ_educ.useh 'about', e.about
        @templ_educ.add()

      @templ_educ.push @found.education.html('')
      @found.block_education.show()


    if value.about or value.why or value.interests
      if value.about then @found.about_me.show().text(value.about) else @found.about_me.hide()
      if value.why then @found.why.show().find('.text').text(value.why) else @found.why.hide()
      if value.interests then @found.interests.show().find('.text').text(value.interests) else @found.interests.hide()
      @found.block_about.show()

    exist_rev = value.reviews?.length
    exist_doc = value.documents?.length

    if exist_rev or exist_doc

      if exist_rev
        for r in value.reviews
          @templ_review.use 'mark', r.mark
          @templ_review.useh 'course', r.course
          @templ_review.useh 'subject', r.subject
          @templ_review.use 'name', r.name
          @templ_review.use 'review', r.review
          @templ_review.use 'date', r.date
          @templ_review.add()
        @templ_review.push @found.reviews.html('')

      if exist_doc
        @found.documents.html('')
        for d in value.documents
          @found.documents.append("<div class='list'><div class='loaded'><img src='#{d.lurl}' data-src='#{d.hurl}'></div></div>")

      @found.review_mark.show(
        0, =>
          if exist_rev
            @profileTab.attr('data-exist', 'tab1')
          else if exist_doc
            @profileTab.attr('data-exist', 'tab2')
      )


  onSendMessage : =>
    result =  yield @save(true)
    if result.status == 'success'
      @showSuccess()
#      setTimeout @showForm, 1100
    else
      @showError result.errs

  showSuccess : =>
    @resetError()
    @found.success.parent().css 'min-height', @found.success.outerHeight(true)
    @found.success.parent().css 'padding', '0 0 0 1rem'
    @found.send_form.animate({opacity: '0'}, 150)
    @found.send_form.slideUp 200, => @found.success.fadeIn()

  showForm : =>
    @message_text.val('')
    @found.success.fadeOut(200, =>
      @found.send_form.slideDown()
      @found.send_form.animate({opacity: '1'})
    )

  save : (show_er = false) => do Q.async =>
    data = @getData()
    errs = @js.check(data)

    if errs.length
      return show_er && {status: 'failed', errs}

    r = yield @$send('../main/attached/save', data)

    if r.status == 'success'
      Feel.sendActionOnce 'direct_bid'
    else
      return show_er && r

    return r


  check_form : () =>
    data = getData()
    errs = @js.check data
    @showError errs
    return errs.length==0

  showError : (errs) =>
    @resetError()
    for e in errs
      @parseError e

  parseError : (err)=>
    switch err
#      when "short_name"
#        @message_name.showError "Слишком короткое имя "
      when "short_phone"
        @errField @message_phone, 'Введите корректный телефон'
      when "empty_phone"
        @errField @message_phone, 'Введите телефон'
#      when "empty_name"
#        @message_name.showError "Введите имя"
#      when "empty_subject"
#        @message_sub.showError "Выберите предмет"

  resetError : =>
    @message_phone.removeClass('invalid')

  errField : (field, err) =>
    field.addClass('invalid').siblings('label').attr('data-error', err)

  hide : =>
    @chooseTutor.off 'click'
    @found.back.off 'click'

  getData : =>
    return {
      id:             @index
      comments:       @message_text.val()
      name:           @message_name.val()
      phone:          @message_phone.val()
      subject:        @message_sub.find('select').val()
    }
