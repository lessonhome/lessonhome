class @main extends EE
  show: =>
    @pupil = @tree.pupil.class
    @tutor = @tree.tutor.class

    @pupil.on 'active', @tutor.disable
    @tutor.on 'active', @pupil.disable
