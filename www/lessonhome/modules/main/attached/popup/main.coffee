class @main
  Dom:=>
    @subject=@tree.subject.class
    @second_block=@found.second_block
  show : =>
    if !@subject.getValue()
      @subject.on 'focus', =>
        @second_block.show('slow')
    else  @second_block.show('slow')