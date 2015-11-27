history?.scrollRestoration = 'manual'

class @main extends EE
  constructor : ->
    $W @
  Dom : =>
    @register 'main'
    @attached = @tree.bottom_block_attached.class
    @content    = @found.content
    Q.spawn => yield @initListenStateChange()
    
  initListenStateChange : =>
    yield @checkStateChange true
    window.onstatechange = =>
      @savedScroll = $(window).scrollTop()
      Q.spawn => yield @onstatechange()
  
  checkStateChange : (first=false)=>
    @oldurl = @nowurl
    @olddata = @nowdata
    url = History.getState().url
    if url.match /\/tutor_profile/
      @nowurl = 'tutor_profile'
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
      when 'tutor_profile'
        return true if @nowdata != @olddata
    return false
  show: =>
  goBack: =>
    document.location.href = window.history.back()
  onstatechange : =>
    return unless yield @checkStateChange()
    if @tree.clear_profile && (@nowurl != 'tutor_profile')
      setInterval @goHitoryUrl,100
      @goHistoryUrl()
      return
    yield @preShow()
    yield @hidePage()
    yield @showPage()
  preShow : =>
    switch @nowurl
      when 'tutor_profile'
        @saveTutor = @tree.profile.class.$clone()
        @found.profile.find('>').off true,true
        @found.profile.empty()
        @found.profile.append @saveTutor.dom
        #yield @saveTutor.open @urldata
  hidePage : =>
    switch @oldurl
      when 'tutor_profile'
        break if @nowurl == 'tutor_profile'
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
      when 'tutor_profile'
        $(window).scrollTop 0
        @found.profile?.removeClass? 'hidden'
      when 'other'
        #@found.filter_top?.show?()
        #@found.info_panel?.show?()
        @found.content?.removeClass? 'hidden'
        $(window).scrollTop(@saveScroll)
        if @tree.content?.class?.onscroll?
          $(window).on 'scroll.tutors',@tree.content?.class?.onscroll
  goHistoryUrl : =>
    setTimeout ->
      document.location.href = History.getState().url
    ,0
  showTutor : (index,href)=>
    yield Feel.gor(href)
  hideTutor : =>
    History.back()
  

