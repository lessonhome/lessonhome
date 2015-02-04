class @main extends EE
  show : =>
    @pupil = @tree.back_call.pupil.class
    @tutor = @tree.back_call.tutor.class

    @pupil.on 'active', => @tutor.disable()
    @tutor.on 'active', => @pupil.disable()