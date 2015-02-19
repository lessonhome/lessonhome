
class @main
  show : =>
    @student = @tree.status_student.class
    @teacher = @tree.status_teacher.class
    @phd     = @tree.status_phd.class
    @man     = @tree.sex_man.class
    @woman   = @tree.sex_woman.class

    @student.on 'active', =>
      @teacher.disable()
      @phd.disable()

    @teacher.on 'active', =>
      @student.disable()
      @phd.disable()

    @phd.on 'active', =>
      @teacher.disable()
      @student.disable()

    @man  .on 'active', => @woman .disable()
    @woman.on 'active', => @man   .disable()
