class @main extends EE
  show: =>
    @slider = @tree.move.class
    @start_input = @tree.start.class
    @end_input = @tree.end.class
###
    @slider.on 'left_cursor_move',  => @start_input.setValue()
    @slider.on 'right_cursor_move', => @end_input.setValue()

###