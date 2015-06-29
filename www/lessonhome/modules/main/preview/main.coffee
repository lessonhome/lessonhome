
class @main extends EE
  constructor : ->
  Dom : =>
    @background_block = $ @found.background_block
    @popup            = @found.popup
    @sort             = @tree.sort.class
  show : => do Q.async =>
    yield @$send 'tutors'
    @tutors_result = @tree.tutors_result
    @choose_tutors_num = @found.choose_tutors_num
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

    @sort.on 'change',  => @emit 'change'
    @sort.on 'end',     => @emit 'end'


    @background_block.on 'click',  @check_place_click


  check_place_click :(e) =>
    if (!@popup.is(e.target) && @popup.has(e.target).length == 0)
      Feel.go '/second_step'

  getValue : =>
    return {
      sort : @sort.getValue()
    }






