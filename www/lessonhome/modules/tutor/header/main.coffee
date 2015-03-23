class @main extends EE
  show : =>
    @backCall_t = @tree.back_call
    @backCall   = @backCall_t.class
    @inOut      = @tree.button_in_out.class

    @backCall.on  'showPopup',  @inOut.hidePopup
    @inOut.on     'showPopup',  @backCall.hidePopup



