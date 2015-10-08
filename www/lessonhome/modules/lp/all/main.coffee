class @main
  Dom : =>
    @firstStep      = @found.step_one
    @tutorsList     = @found.tutors_list
    @twoStep        = @found.step_two
    @seoText        = @found.seo_text
    @threeStep      = @found.step_three
    @tutorOffset    = @found.tutors_list.offset()
    @stepOffset     =
      one   : 100
      two   : @tutorOffset.top + @found.tutors_list.height() - 400
      three : @tutorOffset.top + @found.tutors_list.height() - 150
      four  : @tutorOffset.top + @found.tutors_list.height() + 50
  show: =>
    $(document).on 'scroll.lp', @onScroll
  hide : =>
    $(document).off 'scroll.lp'

  onScroll : (e) =>
    thisScroll = $(document).scrollTop()
    if thisScroll > @stepOffset.one
      @firstStep.animate
        top: 0
        500
      @tutorsList.animate
        opacity: 1
        1000
    if thisScroll > @stepOffset.two
      @twoStep.animate
        opacity: 1
        1000
    if thisScroll > @stepOffset.three
      @seoText.animate
        opacity: 1
        1000
    if thisScroll > @stepOffset.four
      @threeStep.animate
        opacity: 1
        1000