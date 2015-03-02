class @main extends EE
  show : =>
    @backCall_t = @tree.back_call
    @backCall   = @backCall_t.class
    @pupil      = @backCall_t.call_back_popup.pupil.class
    @tutor      = @backCall_t.call_back_popup.tutor.class
    @inOut      = @tree.button_in_out.class

    @pupil.on 'active', @tutor.disable
    @tutor.on 'active', @pupil.disable

    @backCall.on  'showPopup',  @inOut.hidePopup
    @inOut.on     'showPopup',  @backCall.hidePopup