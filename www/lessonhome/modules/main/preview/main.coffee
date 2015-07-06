
class @main extends EE
  constructor : ->
  Dom : =>
    @background_block  = $ @found.background_block
    @popup             = @found.popup
    @sort              = @tree.sort.class
    @test              = @found.test
    @tutors_result     = @found.tutors_result
    @profiles_20       = @found.profiles_20
    @profiles_40       = @found.profiles_40
    @profiles_60       = @found.profiles_60
    @profiles_80       = @found.profiles_80
    @reset_all_filters = @found.reset_all_filters
    @advanced_filter   = @tree.advanced_filter.class
  show : => do Q.async =>
    @tutors = yield @$send 'tutors'
    for acc,tutor of @tutors
      nt = @tree.tutor_test.class.$clone()
      nt.setValue tutor
      @tutors_result.append nt.dom
    ###
    @tutors_result = @tree.tutors_result
    ###
    @choose_tutors_num = @found.choose_tutors_num
    ###
    @tutors_result[1].tutor_extract.class.found.add_button_bid.on 'click', =>
      @imgtodrag = $($('.photo')[1]).eq(0)
      if @imgtodrag
        @imgclone = @imgtodrag.clone()
        @imgclone.offset({
          top:  @imgtodrag.offset().top
          left: @imgtodrag.offset().left
        })
        @imgclone.css({
            'opacity': '0.5',
            'position': 'absolute',
            'height': '150px',
            'width': '150px',
            'z-index': '100'
          })
    ###
    @sort.on 'change',  => @emit 'change'
    @sort.on 'end',     => @emit 'end'


    @background_block.on 'click',  @check_place_click

    $(@profiles_20).on 'click', =>
      @setItemActive   @profiles_20
      @setItemInactive @profiles_40
      @setItemInactive @profiles_60
      @setItemInactive @profiles_80

    $(@profiles_40).on 'click', =>
      @setItemActive   @profiles_40
      @setItemInactive @profiles_20
      @setItemInactive @profiles_60
      @setItemInactive @profiles_80

    $(@profiles_60).on 'click', =>
      @setItemActive   @profiles_60
      @setItemInactive @profiles_40
      @setItemInactive @profiles_20
      @setItemInactive @profiles_80

    $(@profiles_80).on 'click', =>
      @setItemActive   @profiles_80
      @setItemInactive @profiles_40
      @setItemInactive @profiles_60
      @setItemInactive @profiles_20

    $(@reset_all_filters).on 'click', => @advanced_filter.resetAllFilters()

  check_place_click :(e) =>
    if (!@popup.is(e.target) && @popup.has(e.target).length == 0)
      Feel.go '/second_step'

  getValue : =>
    return {
      sort : @sort.getValue()
    }


  setItemActive: (div)=>
    return if div.hasClass 'active'
    div.addClass 'active'
    return 0

  setItemInactive: (div)=>
    return if !div.hasClass 'active'
    div.removeClass 'active'
    return 0


