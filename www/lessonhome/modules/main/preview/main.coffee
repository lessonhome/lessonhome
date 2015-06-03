class @main extends EE
  Dom : =>
    @sort = @tree.sort.class
  show : =>
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
        console.log @imgclone.offset()

    @sort.on 'change', => @emit 'change'
    @sort.on 'end', => @emit 'end'

    @on 'change', => console.log @getValue()
    @on 'end', => console.log @getValue()

  getValue : =>
    return {
      sort : @sort.getValue()
    }






