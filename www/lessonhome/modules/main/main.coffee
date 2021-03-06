history?.scrollRestoration = 'manual'

class @main extends EE
  Dom : =>
    @popup_wrap = $ @found.popup_wrap
    if @tree.popup_close_href?
      @popup_close_href = @tree.popup_close_href
    @content    = @found.content
    @initListenStateChange().done()
    
  initListenStateChange : => do Q.async =>
    yield @checkStateChange true
    window.onstatechange = =>
      @savedScroll = $(window).scrollTop()
      @onstatechange()
      return
  checkStateChange : (first=false)=>
    @oldurl = @nowurl
    @olddata = @nowdata
    url = yield Feel.urlData.getUrl()
    if url.match /\/tutor(\/\d+|\?|[^\/]|$)/
      @nowurl = 'tutor'
      unless first
        yield Feel.urlData.initFromUrl()
      @nowdata = yield Feel.urlData.get 'tutorProfile','index'
    else if url.match /\/second_step/
      @nowurl  = 'second_step'
      @nowdata = ''
    else if url.match(/\/$/) || url.match(/\/\?.*$/)
      @nowurl = 'main'
      @nowdata = ''
    else
      @nowurl = 'other'
      @nowdata = 'other'
    if first
      @oldurl = @nowurl
      @olddata = @nowdata
    return false unless @oldurl?
    return true if @nowurl != @oldurl
    switch @nowurl
      when 'second_step','main'
        return false
      when 'tutor'
        return true if @nowdata != @olddata
    return false
  show: =>
    @startSearch    = @dom.find(".start_search").find(".button")
    @inOut          = @tree.header.button_in_out.class
    @headerBackCall = @tree.header.back_call.class
    @footerBackCall = @tree.footer.back_call.class

    @footerBackCall.on  'showPopup', =>
      @inOut.hidePopup()
      @headerBackCall.hidePopup()

    @headerBackCall.on 'showPopup', @footerBackCall.hidePopup
    @inOut         .on 'showPopup', @footerBackCall.hidePopup

    @startSearch.on 'click', =>
      if @tree.filter_top.list_subject
        $('body').scrollTop(0)
        @listSubject = @tree.filter_top.list_subject.class
        @listSubject.focusInput()

    @popup_wrap.on 'click',  @check_place_click

  check_place_click :(e) =>
    if (!@content.is(e.target) && @content.has(e.target).length == 0)
      if @popup_close_href?
        Feel.go @popup_close_href
      else
        @goBack()
  goBack: =>
    document.location.href = window.history.back()
  onstatechange : => Q.spawn =>
    return unless yield @checkStateChange()
    if @tree.clear_profile && (@nowurl != 'tutor')
      setInterval @goHitoryUrl,100
      @goHistoryUrl()
      return
    yield @preShow()
    yield @hidePage()
    yield @showPage()
  preShow : => do Q.async =>
    switch @nowurl
      when 'tutor'
        @saveTutor = @tree.tutor_profile.class.$clone()
        @found.tutor_profile.find('>').off true,true
        @found.tutor_profile.empty()
        @found.tutor_profile.append @saveTutor.dom
        yield @saveTutor.open @urldata
  hidePage : => do Q.async =>
    switch @oldurl
      when 'tutor_profile'
        break if @nowurl == 'tutor'
        @found?.tutor_profile?.hide?()
        yield Feel.urlData.set 'tutorProfile',{index:0}
      when 'main','second_step','other'
        @saveScroll = @savedScroll
        $(window).off 'scroll.tutors'
        @found.filter_top?.hide?()
        @found.info_panel?.hide?()
        @found.content?.hide?()
  showPage : => do Q.async =>
    switch @nowurl
      when 'tutor'
        $(window).scrollTop 0
        @found.tutor_profile.show()
      when 'main','second_step','other'
        @found.filter_top?.show?()
        @found.info_panel?.show?()
        @found.content?.show?()
        $(window).scrollTop(@saveScroll)
        if @tree.content?.class?.onscroll?
          $(window).on 'scroll.tutors',@tree.content?.class?.onscroll
  goHistoryUrl : => Q.spawn =>
    document.location.href = History.getState().url
  showTutor : (index,href)=> Q.spawn =>
    yield Feel.gor(href)
  hideTutor : => Q.spawn =>
    History.back()
  

