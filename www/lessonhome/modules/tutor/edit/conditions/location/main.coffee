class @main
  show : =>
    @tutor   = @tree.tutor.class
    @student = @tree.student.class
    @web     = @tree.web.class

    @tutor  .on 'active', =>
      @student .disable()
      @web     .disable()
    @student.on 'active', =>
      @tutor   .disable()
      @web     .disable()
    @web    .on 'active', =>
      @tutor   .disable()
      @student .disable()


    Feel.LabelHoverControl(@dom, '.drop_down_list, input')
