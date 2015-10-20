class @main
  constructor : ->
    $W @
  Dom : =>
    @firstStep      = @found.step_one
    @firstHeight    = @found.step_one.height()
    @tutorsList     = @found.tutors_list
    @twoStep        = @found.step_two
    @seoText        = @found.seo_text
    @threeStep      = @found.step_three
    @charset_boy    = @found.charset
    @stepOffset     =
      one   : 100

    @oldScroll      = $(document).scrollTop()
  show: =>
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

    $(document).on 'scroll.lp', @onScroll

    #fuckid crutch
    @charset_boy.css('top', '20%')

    #init modals
#    @modalShow.leanModal
#      dismissible: true,
#      opacity: .5,
#      in_duration: 300,
#      out_duration: 200
#      ready: =>
#        console.log 'open modal'
#      complete: =>
#        console.log 'complete modal work'
#  hide : =>
#    $(document).off 'scroll.lp'

  onScroll : (e) =>

    e = e || window.event
    thisScroll = $(e.currentTarget).scrollTop()
    charsetPosition = @charset_boy[0].style.top

    if(thisScroll > @oldScroll)
      #SCROLL DOWN
      @oldScroll = thisScroll

      #first step
      if thisScroll > @stepOffset.one
#        @firstStep.animate
#          opacity: 0
#          700
#          =>
        _tutorOffset = @found.tutors_list.offset()
        #update stepOffset
        @stepOffset     =
          one   : 100
          two   : _tutorOffset.top + @found.tutors_list.height() - 400
          three : _tutorOffset.top + @found.tutors_list.height() - 150
          four  : _tutorOffset.top + @found.tutors_list.height() + 50

        @tutorsList.animate
          opacity: 1
          1000

        if charsetPosition == '20%'
          @charset_boy.animate
            top: '45%'
            700

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
      if thisScroll < @stepOffset.one || thisScroll == @stepOffset.one
#        @firstStep.animate
#          opacity: 1
#          700

        if charsetPosition == '45%'
          @charset_boy.animate
            top: '20%'
            700
