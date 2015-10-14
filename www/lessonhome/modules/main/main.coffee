class @main extends EE
  Dom : =>
    @popup_wrap = $ @found.popup_wrap
    if @tree.popup_close_href?
      @popup_close_href = @tree.popup_close_href
    @content    = @found.content

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
        #Feel.go '/'
      #console.log @tree.popup?._name
      #switch @tree.popup?._name
        #when 'main/call_back_popup' then  Feel.go '/'
        #when 'main/terms_of_cooperation' then Feel.go '/main_tutor'

  goBack: =>
    document.location.href = window.history.back()
  showTutor : (index,href)=> Q.spawn =>
    @saveUrl = History.getState().url
    @saveScroll = $(window).scrollTop()
    yield Feel.gor(href)
    @saveTutor = @tree.tutor_profile.class.$clone()
    @found.tutor_profile.empty()
    @found.tutor_profile.append @saveTutor.dom
    yield @saveTutor.open(index)
    @found.tutor_profile.show()
    $(window).scrollTop(0)
    @found.content.hide()
    $(window).off 'scroll.tutors'
  hideTutor : => Q.spawn =>
    #yield Feel.urlData.set 'tutorProfile',{index:undefined}
    yield Feel.gor @saveUrl.replace /(\?.*)/gmi,''
    @found.tutor_profile.hide()
    @found.content.show()
    $(window).scrollTop(@saveScroll)
    yield Feel.urlData.set 'tutorProfule',{index:0}
    if @tree.content?.class?.onscroll?
      $(window).on 'scroll.tutors',@tree.content?.class?.onscroll


