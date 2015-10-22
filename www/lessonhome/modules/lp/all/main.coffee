class @main
  constructor : ->
    $W @
  Dom : =>
    @commonBlock    = @found.lp_custom
    @firstStep      = @found.step_one
    @firstHeight    = @found.step_one.height()
    @tutorsList     = @found.tutors_list
    @twoStep        = @found.step_two
    @seoText        = @found.seo_text
    @threeStep      = @found.step_three
#    @charset_boy    = @found.charset
    @stepOffset     =
      one   : 100
    @oldScroll      = $(document).scrollTop()
    @attached = @tree.bottom_block_attached.class
    @fastest = @dom.find '.fastest'
  show: =>
    Q.spawn =>
      @found.go_find.attr 'href','/second_step?'+yield Feel.udata.d2u('mainFilter',@tree.filter)
    isMobile =
      Android:    ->
        return navigator.userAgent.match(/Android/i)
      BlackBerry: ->
        return navigator.userAgent.match(/BlackBerry/i)
      iOS:        ->
        return navigator.userAgent.match(/iPhone|iPad|iPod/i)
      Opera:      ->
        return navigator.userAgent.match(/Opera Mini/i)
      Windows:    ->
        return navigator.userAgent.match(/IEMobile/i)
      any:        ->
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows())

    @found.tutors_list.find('>div').remove()
    numTutors = 5
    tutors = yield Feel.dataM.getByFilter numTutors, (@tree.filter ? {})
    tutors ?= []
    if tutors.length < numTutors
      newt = yield Feel.dataM.getByFilter numTutors*2, ({})
      exists = {}
      for t in tutors
        exists[t.index]= true
      i = 0
      while tutors.length < numTutors
        t = newt[i++]
        break unless t?
        continue if exists[t.index]
        tutors.push t
    for tutor,i in tutors
      clone = @tree.tutor.class.$clone()
      clone.dom.css opacity:0
      @found.tutors_list.append clone.dom
      yield clone.setValue tutor
      clone.dom.show()
      clone.dom.animate (opacity:1),1400

    if !isMobile.any()
      $(document).on 'scroll.lp', @onScroll
    else
      @commonBlock.addClass 'any_devices'

    #fuckid crutch
#    @charset_boy.css('top', '20%')
    @found.input_phone.on 'input',(e)=>
      val = $(e.target).val()
      @tree.value ?= {}
      @tree.value.phone = val
      @found.input_phone.filter(':not(:focus)').val val
      @found.input_phone.removeClass 'invalid'
      if val
        @found.input_phone.filter(':not(:focus)').parent().find('>i,>label').addClass 'active'
      else
        @found.input_phone.filter(':not(:focus)').parent().find('>i,>label').removeClass 'active'
      @emit 'change'
    @found.input_name.on 'input',(e)=>
      val = $(e.target).val()
      @tree.value ?= {}
      @tree.value.name = val
      @found.input_name.filter(':not(:focus)').val val
      if val
        @found.input_name.filter(':not(:focus)').parent().find('>i,>label').addClass 'active'
      else
        @found.input_name.filter(':not(:focus)').parent().find('>i,>label').removeClass 'active'
      @found.input_name.val val
      @emit 'change'
    @found.btn_send.on 'click',=> Q.spawn => yield @sendForm()
  sendForm : =>
    error = yield @attached.sendForm('')
    return @found.input_phone.addClass 'invalid' if error['phone']?
    @fastest.find(':not(.on_send)').remove()
    @fastest.find('.on_send').show()
    Feel.sendGActionOnceIf 6000,'bid_quick','form_submit'
  setValue : (value={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    value = @tree.value
    @found.input_phone.val value.phone || ''
    @found.input_name.val  value.name || ''
  getValue : =>
    phone : @tree.value.phone
    name  : @tree.value.name
  onScroll : (e) =>

    e = e || window.event
    thisScroll = $(e.currentTarget).scrollTop()
#    charsetPosition = @charset_boy[0].style.top

    if(thisScroll > @oldScroll)
      #SCROLL DOWN
      @oldScroll = thisScroll

      #first step
      if thisScroll > @stepOffset.one
        _tutorOffset = @found.tutors_list.offset()
        #update stepOffset
        @stepOffset     =
          one   : 100
          two   : _tutorOffset.top + @found.tutors_list.height() - 400
          three : _tutorOffset.top + @found.tutors_list.height() - 350
          four  : _tutorOffset.top + @found.tutors_list.height() - 250

        @tutorsList.animate
          opacity: 1
          1000

#        if charsetPosition == '20%'
#          @charset_boy.animate
#            top: '45%'
#            700

      #two step
      if thisScroll > @stepOffset.two
        @twoStep.animate
          opacity: 1
          1000

      #three step
      if thisScroll > @stepOffset.three
        @seoText.animate
          opacity: 1
          1000

      #four step
      if thisScroll > @stepOffset.four
        @threeStep.animate
          opacity: 1
          1000
    else
      #SCROLL UP
      @oldScroll = thisScroll

      #first step
#      if thisScroll < @stepOffset.one || thisScroll == @stepOffset.one
#        if charsetPosition == '45%'
#          @charset_boy.animate
#            top: '20%'
#            700
