class @main extends EE
  show : =>
    ###
    @choose_block = @found.choose_tutors_block
    @choose_block_offset = @choose_block.offset().top
    console.log @choose_block_offset
    $(window).on 'scroll', =>
      current_scroll =  $(window).scrollTop()
      is_has = @choose_block.hasClass 'fixed'
      if current_scroll > @choose_block_offset
        if !is_has then @choose_block.addClass 'fixed'
      else
        if is_has then @choose_block.removeClass 'fixed'

    ###