
class @main
  show : =>
    @student = @tree.status_student.class
    @teacher = @tree.status_teacher.class
    @phd     = @tree.status_phd.class

    @student.on 'active', =>
      @teacher.disable()
      @phd.disable()

    @teacher.on 'active', =>
      @student.disable()
      @phd.disable()

    @phd.on 'active', =>
      @teacher.disable()
      @student.disable()

    Feel.LabelHoverControl(@dom, 'input, .drop_down_list')
