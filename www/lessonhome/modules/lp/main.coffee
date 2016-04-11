history?.scrollRestoration = 'manual'

class @main extends EE
  constructor : ->
    $W @
  Dom : =>
    @register 'main'
    @attached = @tree.bottom_block_attached.class
    @content    = @found.content
    Q.spawn =>
      yield @initListenStateChange()
      yield Feel.jobs.onSignal 'bottomBarHide',@onBarHide
      yield Feel.jobs.onSignal 'bottomBarShow',@onBarShow

  initListenStateChange : =>
    yield @checkStateChange true
    window.onstatechange = =>
      @savedScroll = $(window).scrollTop()
      Q.spawn => yield @onstatechange()
    @inited = true

  onBarHide : =>
    @dom.css 'padding-bottom', ''
  onBarShow : =>
    pb = @dom.css 'padding-bottom'
    pb = parseInt pb, 10
    pb = pb + 70 + 'px'
    @dom.css 'padding-bottom', pb

  checkStateChange : (first=false)=>
    @oldurl = @nowurl
    @olddata = @nowdata
    url = yield Feel.urlData.getUrl()
    if url.match(/\/tutor(\/\d+|\?|[^\/]|$)/)
      @nowurl = 'tutor'
      unless first
        yield Feel.urlData.initFromUrl()
      @nowdata = yield Feel.urlData.get 'tutorProfile','index'
    else
      @nowurl = 'other'
      @nowdata = 'other'
    if first
      @oldurl = @nowurl
      @olddata = @nowdata
    return false unless @oldurl?
    return true if @nowurl != @oldurl
    switch @nowurl
      when 'other'
        return false
      when 'tutor'
        return true if @nowdata != @olddata
    return false
  show: =>
    @req_more_on = 0

  goBack: =>
    document.location.href = window.history.back()
  onstatechange : =>
    return unless yield @checkStateChange()
    if (@tree.profile?.single_profile == 'tutor_profile') && (@nowurl != 'tutor')
      #setTimeout @goHitoryUrl,100
      @goHistoryUrl()
      return
    yield @preShow()
    yield @hidePage()
    yield @showPage()
  preShow : =>
    switch @nowurl
      when 'tutor'
        #@tree.profile.class.dom.find('.avatar_loaded').css 'opacity',0
        @tree.profile.class.dom.find('img.avatar').attr 'src',''
        @saveTutor = @tree.profile.class.$clone()
        @saveTutor.dom.find('img.avatar').attr 'src',''
        @found.profile.find('>').off true,true
        @found.profile.empty()
        @found.profile.append @saveTutor.dom
        yield @saveTutor.open()
  hidePage : =>
    switch @oldurl
      when 'tutor'
        break if @nowurl == 'tutor'
        @found?.profile?.addClass? 'hidden'
        yield Feel.urlData.set 'tutorProfile',{index:0}
      when 'other'
        @saveScroll = @savedScroll
        $(window).off 'scroll.tutors'
        #@found.filter_top?.hide?()
        #@found.info_panel?.hide?()
        @found.content?.addClass? 'hidden'
  showPage : =>
    switch @nowurl
      when 'tutor'
        @found.profile?.removeClass? 'hidden'
        $(window).scrollTop 0
      when 'other'
        #@found.filter_top?.show?()
        #@found.info_panel?.show?()
        @found.content?.removeClass? 'hidden'
        $(window).scrollTop(@saveScroll)
        if @tree.content?.class?.onscroll?
          $(window).on 'scroll.tutors',@tree.content?.class?.onscroll
  goHistoryUrl : => Q.spawn =>
    document.location.href = History.getState().url
  showTutor : (index,href='')=>
    url1 = History.getState().url || ""
    url2 = href || ""
    #url1 = (url1.match(/(tutor\?.*)$/)?[0] || '')
    #url2 = (url2.match(/(tutor\?.*)$/)?[0] || '')
    if url1.match(/\/tutor(\/\d+|\?|[^\/]|$)/) && url2.match(/\/tutor(\/\d+|\?|[^\/]|$)/)
      index1 = _setKey (yield Feel.udata.u2d url1),'tutorProfile.index'
      index2 = _setKey (yield Feel.udata.u2d url2),'tutorProfile.index'
      return if index1 == index2
    yield Feel.gor(href)
  hideTutor : =>
    History.back()
  

