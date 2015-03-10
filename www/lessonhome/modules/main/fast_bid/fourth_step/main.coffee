
class @main
  show : =>
    @student   = @tree.student.class
    @teacher   = @tree.teacher.class
    @professor = @tree.professor.class
    @native    = @tree.native.class

  ###
    @student.on 'active', =>
      @teacher.disable()
      @phd.disable()

    @teacher.on 'active', =>
      @student.disable()
      @phd.disable()

    @phd.on 'active', =>
      @teacher.disable()
      @student.disable()

  ###

