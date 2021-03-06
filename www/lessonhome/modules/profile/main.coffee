
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
  _parent_url = History.getState().hash
  constructor : ->
    $W @
#  metro : =>
#    yield Q.delay 1000
#    obj = Feel.const('metro').metro_map
#    ret = {}
#    for line in obj
#      for s in line.stations
#        ret[_diff.metroPrepare(s)] = {
#          name : s
#          line : line.line
#          color : line.color
#        }
#    console.log ret
  Dom : =>
#    @metro()
    @chooseTutor  = @found.tutor_trigger
    @triggerCount = 0
    @resolution = true

    #scroll spy
    @reviewMark   = @found.review_mark
    @profileTab   = @found.profile_tab

    @message_text = @found.message_text
    @message_phone = @found.message_phone
    @message_phone.mask '9 (999) 999-99-99'
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

    getListener = (name) =>
      return (e) =>
        o = {}
        o[name] = $(e.target).val()
        Feel.urlData.set 'pupil', o
        Feel.sendActionOnce('interacting_with_form', 1000*60*10)

    @listenName = getListener 'name'
    @listenPhone = getListener 'phone'

  show: =>
#    @reviewMark.scrollSpy()
    @message_send.on 'click', @onSendMessage
    @found.show_detail.on 'click', @onShowDetail
    @chooseTutor.on 'click', => Q.spawn => yield @onTutorChoose()
    Feel.urlData.on 'change',=>
      pupil = Feel.urlData.get 'pupil'

      @message_name.val(pupil.name)
      @message_phone.val(pupil.phone)

      Q.spawn =>
        yield @setLinked()

    @message_name.on 'change', @listenName
    @message_phone.on 'change', (e) =>
      @listenPhone(e)
      @save(false, true)

    @found.back.on 'click', (e)=>
      return unless e.button == 0
      e.preventDefault()
      Q.spawn => yield @goBack()
    #yield @open()
    yield @matchAny() if @tree.single_profile== "tutor_profile"

    if @found.avatar.height() is 0
      @found.avatar.load @prepareAvatar
    else
      @prepareAvatar()

  prepareAvatar : =>
    @found.view_photo.css 'padding-top', ''
    .removeClass('avatar_loaded')

  matchAny : (force=false)=>
    #return unless @tree.value?.index
    if (((""+document.referrer).indexOf(document.location.href.substr(0,15)))!=0)&&(window.history.length<2)
      @found.back.addClass 'hidden'
    else
      @found.back.removeClass 'hidden'
    yield @matchExists()
    @message_sub.find('select').material_select()
    @profileTab.addClass('tabs').tabs()
    @dom.find('.loaded').each @loadImage
    setTimeout =>
      if exist = @profileTab.data('exist')
        @profileTab.tabs('select_tab', exist)

      Q.spawn =>
        inset = yield Feel.urlData.get('tutorProfile','inset')
        Q.spawn -> Feel.urlData.set('tutorProfile',{'inset': ''})
        if inset == 1
          top = @found.reviews.offset().top - 120
          a = $('body, html')
          a.delay(500).animate {scrollTop: top}, {duration: 1000}
          $(window).one 'mousewheel', -> a.stop(true)
    ,0
    yield @setLinked()
  open : (index)=>

    unless index?
      index = yield Feel.urlData.get('tutorProfile','index') ? 77
    preps = yield Feel.dataM.getTutor [index]
    prep = preps[index]
    return unless prep?
    yield @setValue prep
    yield @matchAny(true)
  goBack : =>
    if @tree.single_profile!='tutor_profile'
      return yield Feel.main.hideTutor()
    if (window.history.length>1) && History.back()
      setInterval (=> Q.spawn => yield @goHistoryUrl()),2000
      return yield @goHistoryUrl()
    document.location.href = document.referrer
  goHistoryUrl : => Q.spawn =>
    yield Q.delay 100
    document.location.href = History.getState().url

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
    return unless @tree.value.index
    linked = yield Feel.urlData.get 'mainFilter','linked','reload'
    state = active ? linked?[@tree.value.index]==true
    if active?
      unless state
        delete linked?[@tree.value.index]
      else
        linked?[@tree.value.index] = true
      yield Feel.urlData.set 'mainFilter','linked',linked
    @tutorChoose state==true if choose
  tutorChoose : (active)=>
    if active
      @found.tutor_trigger.addClass('waves-light blue-btn selected white-text').removeClass('btn-trigger waves-grey')
      @found.tutor_trigger.find('.tutor_button_text').html('Отменить')
      @found.tutor_trigger.find('.m_icon').removeClass('icon_add').addClass('icon_remove')
    else
      @found.tutor_trigger.removeClass('waves-light blue-btn selected white-text').addClass('btn-trigger waves-grey')
      @found.tutor_trigger.find('.tutor_button_text').html('Выбрать')
      @found.tutor_trigger.find('.m_icon').removeClass('icon_remove').addClass('icon_add')

  loadImage : (i, elem) =>
    photo_parent = $(elem).addClass 'materialboxed'
    photo_parent.parent().addClass('_fix_bug') #materialize bug fix

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
      }).attr('data-src', null)

      photo_parent.one 'click', ->
        l_img.before h_img
        h_img.attr('src', src_h).load ->
          h_img.css('display', '').animate {opacity: 1}, ->
            l_img.remove()
            h_img.css({position: ''})


  setAvatar : (avatar)=>
    @found.view_photo.css {
      'padding-top' : "#{avatar.ratio*100}%"
    }
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
  setValue : (value)=>
    value ?= @tree.value
    @tree.value = {}
    @tree.value[key] = val for key,val of value
    value = @tree.value

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
      for s in value.sub when s
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
        if sub.name
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


    @found.reviews.html('')
    @found.documents.html('')

    if value.reviews?.length
      for r in @tree.value.reviews
        @templ_review.use 'mark', r.mark
        @templ_review.useh 'course', r.course
        @templ_review.useh 'subject', r.subject
        @templ_review.use 'name', r.name
        @templ_review.use 'review', r.review
        @templ_review.use 'date', r.date
        @templ_review.add()
      @templ_review.push @found.reviews
    else
      @found.reviews.html('<p>Отзывов пока нет.</p>')

    if value.documents?.length
      for d in @tree.value.documents
        @found.documents.append("<div class='list'><div class='loaded'><img src='#{d.lurl}' data-src='#{d.hurl}'></div></div>")
    else
      @found.documents.html('<p>Нет загруженных фотографий.</p>')


    #@matchExists()
  matchExists : =>
    exist_rev = @tree.value.reviews?.length
    exist_doc = @tree.value.documents?.length

    if exist_rev or exist_doc

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

  save : (show_er = false, quiet = false) => do Q.async =>
    data = @getData()
    errs = @js.check(data)

    if errs.length
      return show_er && {status: 'failed', errs}


    #r = yield @$send('../main/attached/save', data, quiet && 'quiet' || '')
    r = yield Feel.bid.save {
      type : "message"
      message : data.comments
      name : data.name
      phone : data.phone
      subjects : [data.subject]
      to : data.id
    }

    if r.status == 'success'
      Feel.sendActionOnce 'direct_bid'
      url = _parent_url?.replace?(/\/?\?.*$/, '')
      url = '/' if url is ''
      Feel.sendActionOnce 'bid_action', null, {name: 'target', url}
    else
      return show_er && r

    return r


  check_form : () =>
    data = @getData()
    errs = @js.check data
    @showError errs
    return errs.length==0

  showError : (errs) =>
    Feel.sendAction 'error_on_page' if errs.length
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
    @found.show_detail.off 'click'
    @message_send.off 'click'
    @message_name.off 'change'
    @message_phone.off 'change'

  getData : =>
    return {
      id:             @tree.value.index
      comments:       @message_text.val()
      name:           @message_name.val()
      phone:          @message_phone.val()
      subject:        @message_sub.find('select').val()
    }
